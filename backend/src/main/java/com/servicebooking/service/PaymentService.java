package com.servicebooking.service;

import com.servicebooking.dto.PaymentRequest;
import com.servicebooking.exception.BadRequestException;
import com.servicebooking.exception.ResourceNotFoundException;
import com.servicebooking.model.Booking;
import com.servicebooking.model.Payment;
import com.servicebooking.model.PaymentStatus;
import com.servicebooking.repository.BookingRepository;
import com.servicebooking.repository.PaymentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class PaymentService {

    private final PaymentRepository paymentRepository;
    private final BookingRepository bookingRepository;
    private final NotificationService notificationService;

    public List<Payment> getBookingPayments(Long bookingId) {
        return paymentRepository.findByBookingId(bookingId);
    }

    public Payment getPaymentById(Long id) {
        return paymentRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Payment not found with id: " + id));
    }

    @Transactional
    public Payment createPayment(PaymentRequest request) {
        Booking booking = bookingRepository.findById(request.getBookingId())
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found"));

        if (booking.getPaymentStatus() == PaymentStatus.SUCCESS) {
            throw new BadRequestException("Booking is already paid");
        }

        Payment payment = new Payment();
        payment.setBooking(booking);
        payment.setAmount(request.getAmount());
        payment.setPaymentMethod(request.getPaymentMethod());
        payment.setTransactionId(generateTransactionId());
        payment.setStatus(PaymentStatus.PENDING);

        return paymentRepository.save(payment);
    }

    @Transactional
    public Payment verifyAndCompletePayment(PaymentRequest request) {
        Booking booking = bookingRepository.findById(request.getBookingId())
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found"));

        // In a real implementation, verify Razorpay signature here
        // For now, we'll mark as successful
        boolean isValid = verifyRazorpaySignature(
                request.getRazorpayOrderId(),
                request.getRazorpayPaymentId(),
                request.getRazorpaySignature()
        );

        Payment payment = new Payment();
        payment.setBooking(booking);
        payment.setAmount(request.getAmount());
        payment.setPaymentMethod(request.getPaymentMethod());
        payment.setTransactionId(request.getRazorpayPaymentId());
        payment.setStatus(isValid ? PaymentStatus.SUCCESS : PaymentStatus.FAILED);

        payment = paymentRepository.save(payment);

        if (isValid) {
            booking.setPaymentStatus(PaymentStatus.SUCCESS);
            booking.setPaymentId(request.getRazorpayPaymentId());
            bookingRepository.save(booking);

            // Send notification
            notificationService.sendNotification(
                    booking.getProvider().getId(),
                    "Payment Received",
                    "Payment received for booking #" + booking.getId(),
                    "PAYMENT_SUCCESS"
            );
        }

        return payment;
    }

    @Transactional
    public Payment refundPayment(Long paymentId) {
        Payment payment = getPaymentById(paymentId);

        if (payment.getStatus() != PaymentStatus.SUCCESS) {
            throw new BadRequestException("Only successful payments can be refunded");
        }

        // In a real implementation, initiate Razorpay refund here
        payment.setStatus(PaymentStatus.REFUNDED);
        payment = paymentRepository.save(payment);

        Booking booking = payment.getBooking();
        booking.setPaymentStatus(PaymentStatus.REFUNDED);
        bookingRepository.save(booking);

        return payment;
    }

    private boolean verifyRazorpaySignature(String orderId, String paymentId, String signature) {
        // TODO: Implement actual Razorpay signature verification
        // For development, return true
        // In production, use Razorpay SDK to verify:
        // String generatedSignature = hmac_sha256(orderId + "|" + paymentId, secret);
        // return generatedSignature.equals(signature);
        return signature != null && !signature.isEmpty();
    }

    private String generateTransactionId() {
        return "TXN-" + UUID.randomUUID().toString();
    }

    public List<Payment> getAllPayments() {
        return paymentRepository.findAll();
    }
}
