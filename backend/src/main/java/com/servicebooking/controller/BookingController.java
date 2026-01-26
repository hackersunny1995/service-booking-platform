package com.servicebooking.controller;

import com.servicebooking.dto.BookingRequest;
import com.servicebooking.model.Booking;
import com.servicebooking.model.BookingStatus;
import com.servicebooking.security.UserPrincipal;
import com.servicebooking.service.BookingService;
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
import java.util.Map;

@RestController
@RequestMapping("/api/bookings")
@RequiredArgsConstructor
@Tag(name = "Bookings", description = "Booking management")
@SecurityRequirement(name = "bearer-jwt")
public class BookingController {

    private final BookingService bookingService;

    @GetMapping
    @Operation(summary = "Get current user's bookings")
    public ResponseEntity<List<Booking>> getCurrentUserBookings(
            @AuthenticationPrincipal UserPrincipal currentUser) {
        // Check role and return appropriate bookings
        return ResponseEntity.ok(bookingService.getCustomerBookings(currentUser.getId()));
    }

    @GetMapping("/all")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get all bookings (Admin only)")
    public ResponseEntity<List<Booking>> getAllBookings() {
        return ResponseEntity.ok(bookingService.getAllBookings());
    }

    @GetMapping("/customer")
    @PreAuthorize("hasRole('CUSTOMER')")
    @Operation(summary = "Get customer's bookings")
    public ResponseEntity<List<Booking>> getCustomerBookings(
            @AuthenticationPrincipal UserPrincipal currentUser) {
        return ResponseEntity.ok(bookingService.getCustomerBookings(currentUser.getId()));
    }

    @GetMapping("/provider")
    @PreAuthorize("hasRole('PROVIDER')")
    @Operation(summary = "Get provider's bookings")
    public ResponseEntity<List<Booking>> getProviderBookings(
            @AuthenticationPrincipal UserPrincipal currentUser) {
        return ResponseEntity.ok(bookingService.getProviderBookings(currentUser.getId()));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get booking by ID")
    public ResponseEntity<Booking> getBookingById(@PathVariable Long id) {
        return ResponseEntity.ok(bookingService.getBookingById(id));
    }

    @PostMapping
    @PreAuthorize("hasRole('CUSTOMER')")
    @Operation(summary = "Create new booking (Customer only)")
    public ResponseEntity<Booking> createBooking(
            @AuthenticationPrincipal UserPrincipal currentUser,
            @Valid @RequestBody BookingRequest request) {
        Booking booking = bookingService.createBooking(currentUser.getId(), request);
        return new ResponseEntity<>(booking, HttpStatus.CREATED);
    }

    @PutMapping("/{id}/status")
    @Operation(summary = "Update booking status")
    public ResponseEntity<Booking> updateBookingStatus(
            @PathVariable Long id,
            @AuthenticationPrincipal UserPrincipal currentUser,
            @RequestBody Map<String, String> statusUpdate) {
        BookingStatus status = BookingStatus.valueOf(statusUpdate.get("status"));
        return ResponseEntity.ok(bookingService.updateBookingStatus(id, currentUser.getId(), status));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Cancel booking")
    public ResponseEntity<Void> cancelBooking(
            @PathVariable Long id,
            @AuthenticationPrincipal UserPrincipal currentUser) {
        bookingService.cancelBooking(id, currentUser.getId());
        return ResponseEntity.noContent().build();
    }
}
