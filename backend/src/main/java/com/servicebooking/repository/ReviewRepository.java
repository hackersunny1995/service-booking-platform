package com.servicebooking.repository;

import com.servicebooking.model.Booking;
import com.servicebooking.model.Review;
import com.servicebooking.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ReviewRepository extends JpaRepository<Review, Long> {
    Optional<Review> findByBooking(Booking booking);

    Optional<Review> findByBookingId(Long bookingId);

    List<Review> findByProvider(User provider);

    List<Review> findByProviderId(Long providerId);

    List<Review> findByCustomer(User customer);

    List<Review> findByCustomerId(Long customerId);

    @Query("SELECT AVG(r.rating) FROM Review r WHERE r.provider.id = :providerId")
    Double getAverageRatingByProviderId(Long providerId);
}
