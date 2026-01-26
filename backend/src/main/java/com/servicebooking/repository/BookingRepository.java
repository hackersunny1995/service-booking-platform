package com.servicebooking.repository;

import com.servicebooking.model.Booking;
import com.servicebooking.model.BookingStatus;
import com.servicebooking.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface BookingRepository extends JpaRepository<Booking, Long> {
    List<Booking> findByCustomer(User customer);

    List<Booking> findByCustomerId(Long customerId);

    List<Booking> findByProvider(User provider);

    List<Booking> findByProviderId(Long providerId);

    List<Booking> findByStatus(BookingStatus status);

    List<Booking> findByCustomerIdAndStatus(Long customerId, BookingStatus status);

    List<Booking> findByProviderIdAndStatus(Long providerId, BookingStatus status);

    List<Booking> findByScheduledDateBetween(LocalDate startDate, LocalDate endDate);

    @Query("SELECT COUNT(b) FROM Booking b WHERE b.status = :status")
    Long countByStatus(BookingStatus status);

    @Query("SELECT b FROM Booking b WHERE b.provider.id = :providerId AND b.scheduledDate = :date")
    List<Booking> findProviderBookingsForDate(Long providerId, LocalDate date);
}
