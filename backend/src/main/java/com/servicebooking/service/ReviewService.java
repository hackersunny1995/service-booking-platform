package com.servicebooking.service;

import com.servicebooking.dto.ReviewRequest;
import com.servicebooking.exception.BadRequestException;
import com.servicebooking.exception.ResourceNotFoundException;
import com.servicebooking.model.*;
import com.servicebooking.repository.BookingRepository;
import com.servicebooking.repository.ProviderProfileRepository;
import com.servicebooking.repository.ReviewRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ReviewService {

    private final ReviewRepository reviewRepository;
    private final BookingRepository bookingRepository;
    private final ProviderProfileRepository providerProfileRepository;

    public List<Review> getProviderReviews(Long providerId) {
        return reviewRepository.findByProviderId(providerId);
    }

    public Review getReviewById(Long id) {
        return reviewRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Review not found with id: " + id));
    }

    public Review getReviewByBookingId(Long bookingId) {
        return reviewRepository.findByBookingId(bookingId)
                .orElse(null);
    }

    @Transactional
    public Review createReview(Long customerId, ReviewRequest request) {
        Booking booking = bookingRepository.findById(request.getBookingId())
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found"));

        // Verify customer owns the booking
        if (!booking.getCustomer().getId().equals(customerId)) {
            throw new BadRequestException("You can only review your own bookings");
        }

        // Verify booking is completed
        if (booking.getStatus() != BookingStatus.COMPLETED) {
            throw new BadRequestException("Can only review completed bookings");
        }

        // Check if review already exists
        if (reviewRepository.findByBookingId(request.getBookingId()).isPresent()) {
            throw new BadRequestException("Review already exists for this booking");
        }

        Review review = new Review();
        review.setBooking(booking);
        review.setCustomer(booking.getCustomer());
        review.setProvider(booking.getProvider());
        review.setRating(request.getRating());
        review.setComment(request.getComment());

        review = reviewRepository.save(review);

        // Update provider rating
        updateProviderRating(booking.getProvider().getId());

        return review;
    }

    @Transactional
    public void updateProviderRating(Long providerId) {
        ProviderProfile profile = providerProfileRepository.findByUserId(providerId)
                .orElseThrow(() -> new ResourceNotFoundException("Provider profile not found"));

        List<Review> reviews = reviewRepository.findByProviderId(providerId);

        if (reviews.isEmpty()) {
            profile.setAverageRating(BigDecimal.ZERO);
            profile.setTotalReviews(0);
        } else {
            double average = reviews.stream()
                    .mapToInt(Review::getRating)
                    .average()
                    .orElse(0.0);

            profile.setAverageRating(BigDecimal.valueOf(average).setScale(2, RoundingMode.HALF_UP));
            profile.setTotalReviews(reviews.size());
        }

        providerProfileRepository.save(profile);
    }

    public Double getProviderAverageRating(Long providerId) {
        return reviewRepository.getAverageRatingByProviderId(providerId);
    }
}
