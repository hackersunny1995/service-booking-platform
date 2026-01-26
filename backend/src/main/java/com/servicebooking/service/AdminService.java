package com.servicebooking.service;

import com.servicebooking.dto.DashboardStats;
import com.servicebooking.model.BookingStatus;
import com.servicebooking.model.PaymentStatus;
import com.servicebooking.model.User;
import com.servicebooking.model.UserRole;
import com.servicebooking.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AdminService {

    private final UserRepository userRepository;
    private final BookingRepository bookingRepository;
    private final PaymentRepository paymentRepository;
    private final ReviewRepository reviewRepository;

    public DashboardStats getDashboardStats() {
        DashboardStats stats = new DashboardStats();

        // User stats
        stats.setTotalUsers((long) userRepository.findAll().size());
        stats.setTotalCustomers((long) userRepository.findByRole(UserRole.CUSTOMER).size());
        stats.setTotalProviders((long) userRepository.findByRole(UserRole.PROVIDER).size());

        // Booking stats
        stats.setTotalBookings((long) bookingRepository.findAll().size());
        stats.setPendingBookings(bookingRepository.countByStatus(BookingStatus.PENDING));
        stats.setConfirmedBookings(bookingRepository.countByStatus(BookingStatus.CONFIRMED));
        stats.setCompletedBookings(bookingRepository.countByStatus(BookingStatus.COMPLETED));
        stats.setCancelledBookings(bookingRepository.countByStatus(BookingStatus.CANCELLED));

        // Revenue stats
        BigDecimal totalRevenue = paymentRepository.findByStatus(PaymentStatus.SUCCESS)
                .stream()
                .map(payment -> payment.getAmount())
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        stats.setTotalRevenue(totalRevenue);

        // Review stats
        stats.setTotalReviews((long) reviewRepository.findAll().size());
        Double avgRating = reviewRepository.findAll().stream()
                .mapToInt(review -> review.getRating())
                .average()
                .orElse(0.0);
        stats.setAverageRating(avgRating);

        return stats;
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public User updateUserStatus(Long userId, Boolean isActive) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        user.setIsActive(isActive);
        return userRepository.save(user);
    }
}
