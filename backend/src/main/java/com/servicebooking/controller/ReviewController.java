package com.servicebooking.controller;

import com.servicebooking.dto.ReviewRequest;
import com.servicebooking.model.Review;
import com.servicebooking.security.UserPrincipal;
import com.servicebooking.service.ReviewService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/reviews")
@RequiredArgsConstructor
@Tag(name = "Reviews", description = "Review and rating management")
@SecurityRequirement(name = "bearer-jwt")
public class ReviewController {

    private final ReviewService reviewService;

    @GetMapping("/provider/{providerId}")
    @Operation(summary = "Get provider reviews")
    public ResponseEntity<List<Review>> getProviderReviews(@PathVariable Long providerId) {
        return ResponseEntity.ok(reviewService.getProviderReviews(providerId));
    }

    @GetMapping("/booking/{bookingId}")
    @Operation(summary = "Get review by booking ID")
    public ResponseEntity<Review> getReviewByBookingId(@PathVariable Long bookingId) {
        Review review = reviewService.getReviewByBookingId(bookingId);
        if (review == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(review);
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get review by ID")
    public ResponseEntity<Review> getReviewById(@PathVariable Long id) {
        return ResponseEntity.ok(reviewService.getReviewById(id));
    }

    @PostMapping
    @PreAuthorize("hasRole('CUSTOMER')")
    @Operation(summary = "Create review (Customer only)")
    public ResponseEntity<Review> createReview(
            @AuthenticationPrincipal UserPrincipal currentUser,
            @Valid @RequestBody ReviewRequest request) {
        Review review = reviewService.createReview(currentUser.getId(), request);
        return new ResponseEntity<>(review, HttpStatus.CREATED);
    }

    @GetMapping("/provider/{providerId}/rating")
    @Operation(summary = "Get provider average rating")
    public ResponseEntity<Double> getProviderAverageRating(@PathVariable Long providerId) {
        Double rating = reviewService.getProviderAverageRating(providerId);
        return ResponseEntity.ok(rating != null ? rating : 0.0);
    }
}
