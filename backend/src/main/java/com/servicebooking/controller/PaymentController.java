package com.servicebooking.controller;

import com.servicebooking.dto.PaymentRequest;
import com.servicebooking.model.Payment;
import com.servicebooking.service.PaymentService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/payments")
@RequiredArgsConstructor
@Tag(name = "Payments", description = "Payment processing")
@SecurityRequirement(name = "bearer-jwt")
public class PaymentController {

    private final PaymentService paymentService;

    @GetMapping("/booking/{bookingId}")
    @Operation(summary = "Get booking payments")
    public ResponseEntity<List<Payment>> getBookingPayments(@PathVariable Long bookingId) {
        return ResponseEntity.ok(paymentService.getBookingPayments(bookingId));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get payment by ID")
    public ResponseEntity<Payment> getPaymentById(@PathVariable Long id) {
        return ResponseEntity.ok(paymentService.getPaymentById(id));
    }

    @GetMapping("/all")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get all payments (Admin only)")
    public ResponseEntity<List<Payment>> getAllPayments() {
        return ResponseEntity.ok(paymentService.getAllPayments());
    }

    @PostMapping("/create")
    @Operation(summary = "Create payment order")
    public ResponseEntity<Payment> createPayment(@Valid @RequestBody PaymentRequest request) {
        Payment payment = paymentService.createPayment(request);
        return new ResponseEntity<>(payment, HttpStatus.CREATED);
    }

    @PostMapping("/verify")
    @Operation(summary = "Verify and complete payment")
    public ResponseEntity<Payment> verifyPayment(@Valid @RequestBody PaymentRequest request) {
        Payment payment = paymentService.verifyAndCompletePayment(request);
        return ResponseEntity.ok(payment);
    }

    @PostMapping("/{id}/refund")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Refund payment (Admin only)")
    public ResponseEntity<Payment> refundPayment(@PathVariable Long id) {
        Payment payment = paymentService.refundPayment(id);
        return ResponseEntity.ok(payment);
    }
}
