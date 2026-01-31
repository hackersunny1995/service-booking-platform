package com.servicebooking.service;

import com.servicebooking.dto.BookingRequest;
import com.servicebooking.exception.BadRequestException;
import com.servicebooking.exception.ResourceNotFoundException;
import com.servicebooking.model.*;
import com.servicebooking.repository.BookingRepository;
import com.servicebooking.repository.ServiceRepository;
import com.servicebooking.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class BookingService {

    private final BookingRepository bookingRepository;
    private final UserRepository userRepository;
    private final ServiceRepository serviceRepository;

    public List<Booking> getAllBookings() {
        return bookingRepository.findAllWithRelations();
    }

    public List<Booking> getCustomerBookings(Long customerId) {
        return bookingRepository.findByCustomerId(customerId);
    }

    public List<Booking> getProviderBookings(Long providerId) {
        return bookingRepository.findByProviderId(providerId);
    }

    public List<Booking> getBookingsByStatus(BookingStatus status) {
        return bookingRepository.findByStatus(status);
    }

    public Booking getBookingById(Long id) {
        return bookingRepository.findByIdWithRelations(id)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found with id: " + id));
    }

    @Transactional
    public Booking createBooking(Long customerId, BookingRequest request) {
        User customer = userRepository.findById(customerId)
                .orElseThrow(() -> new ResourceNotFoundException("Customer not found"));

        if (customer.getRole() != UserRole.CUSTOMER) {
            throw new BadRequestException("Only customers can create bookings");
        }

        User provider = userRepository.findById(request.getProviderId())
                .orElseThrow(() -> new ResourceNotFoundException("Provider not found"));

        if (provider.getRole() != UserRole.PROVIDER) {
            throw new BadRequestException("Invalid provider");
        }

        com.servicebooking.model.Service service = serviceRepository.findByIdWithCategory(request.getServiceId())
                .orElseThrow(() -> new ResourceNotFoundException("Service not found"));

        Booking booking = new Booking();
        booking.setCustomer(customer);
        booking.setProvider(provider);
        booking.setService(service);
        booking.setScheduledDate(request.getScheduledDate());
        booking.setScheduledTime(request.getScheduledTime());
        booking.setCustomerAddress(request.getCustomerAddress());
        booking.setCustomerLatitude(request.getCustomerLatitude());
        booking.setCustomerLongitude(request.getCustomerLongitude());
        booking.setNotes(request.getNotes());
        booking.setTotalAmount(service.getBasePrice());
        booking.setStatus(BookingStatus.PENDING);
        booking.setPaymentStatus(PaymentStatus.PENDING);

        return bookingRepository.save(booking);
    }

    @Transactional
    public Booking updateBookingStatus(Long bookingId, Long userId, BookingStatus status) {
        Booking booking = getBookingById(bookingId);

        // Verify user has permission to update
        if (!booking.getProvider().getId().equals(userId) &&
            !booking.getCustomer().getId().equals(userId)) {
            throw new BadRequestException("You don't have permission to update this booking");
        }

        // Validate status transitions
        validateStatusTransition(booking.getStatus(), status, userId, booking);

        booking.setStatus(status);
        return bookingRepository.save(booking);
    }

    @Transactional
    public void cancelBooking(Long bookingId, Long userId) {
        Booking booking = getBookingById(bookingId);

        if (!booking.getProvider().getId().equals(userId) &&
            !booking.getCustomer().getId().equals(userId)) {
            throw new BadRequestException("You don't have permission to cancel this booking");
        }

        if (booking.getStatus() == BookingStatus.COMPLETED) {
            throw new BadRequestException("Cannot cancel completed booking");
        }

        if (booking.getStatus() == BookingStatus.CANCELLED) {
            throw new BadRequestException("Booking is already cancelled");
        }

        booking.setStatus(BookingStatus.CANCELLED);
        bookingRepository.save(booking);
    }

    private void validateStatusTransition(BookingStatus currentStatus, BookingStatus newStatus,
                                         Long userId, Booking booking) {
        // Only provider can confirm booking
        if (newStatus == BookingStatus.CONFIRMED && !booking.getProvider().getId().equals(userId)) {
            throw new BadRequestException("Only provider can confirm booking");
        }

        // Only provider can mark in progress
        if (newStatus == BookingStatus.IN_PROGRESS && !booking.getProvider().getId().equals(userId)) {
            throw new BadRequestException("Only provider can start service");
        }

        // Only provider can mark completed
        if (newStatus == BookingStatus.COMPLETED && !booking.getProvider().getId().equals(userId)) {
            throw new BadRequestException("Only provider can complete service");
        }

        // Cannot go backwards in status
        if (currentStatus == BookingStatus.COMPLETED) {
            throw new BadRequestException("Cannot modify completed booking");
        }

        if (currentStatus == BookingStatus.CANCELLED) {
            throw new BadRequestException("Cannot modify cancelled booking");
        }
    }

    public Long countBookingsByStatus(BookingStatus status) {
        return bookingRepository.countByStatus(status);
    }
}
