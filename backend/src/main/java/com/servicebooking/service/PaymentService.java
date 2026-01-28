package com.servicebooking.service;

import com.razorpay.Order;
import com.razorpay.RazorpayClient;
import com.razorpay.RazorpayException;
import com.servicebooking.dto.PaymentRequest;
import com.servicebooking.exception.BadRequestException;
import com.servicebooking.exception.ResourceNotFoundException;
import com.servicebooking.model.Booking;
import com.servicebooking.model.Payment;
import com.servicebooking.model.PaymentStatus;
import com.servicebooking.repository.BookingRepository;
import com.servicebooking.repository.PaymentRepository;
import lombok.RequiredArgsConstructor;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.HexFormat;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class PaymentService {

    private final PaymentRepository paymentRepository;
    private final BookingRepository bookingRepository;
    private final NotificationService notificationService;

    @Value("${razorpay.key.id}")
    private String razorpayKeyId;

    @Value("${razorpay.key.secret}")
    private String razorpayKeySecret;

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

        // Create Razorpay order
        String razorpayOrderId = createRazorpayOrder(request.getAmount());

        Payment payment = new Payment();
        payment.setBooking(booking);
        payment.setAmount(request.getAmount());
        payment.setPaymentMethod(request.getPaymentMethod());
        payment.setTransactionId(generateTransactionId());
        payment.setRazorpayOrderId(razorpayOrderId);
        payment.setStatus(PaymentStatus.PENDING);

        return paymentRepository.save(payment);
    }

    private String createRazorpayOrder(java.math.BigDecimal amount) {
        try {
            RazorpayClient razorpayClient = new RazorpayClient(razorpayKeyId, razorpayKeySecret);

            // Convert amount to paise (Razorpay uses smallest currency unit)
            int amountInPaise = amount.multiply(java.math.BigDecimal.valueOf(100)).intValue();

            JSONObject orderRequest = new JSONObject();
            orderRequest.put("amount", amountInPaise);
            orderRequest.put("currency", "INR");
            orderRequest.put("receipt", generateTransactionId());

            Order order = razorpayClient.orders.create(orderRequest);
            return order.get("id");

        } catch (RazorpayException e) {
            throw new BadRequestException("Failed to create Razorpay order: " + e.getMessage());
        }
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
        if (orderId == null || paymentId == null || signature == null) {
            return false;
        }

        try {
            // Create the payload: order_id + "|" + payment_id
            String payload = orderId + "|" + paymentId;

            // Generate HMAC SHA256 signature
            Mac mac = Mac.getInstance("HmacSHA256");
            SecretKeySpec secretKeySpec = new SecretKeySpec(
                razorpayKeySecret.getBytes(StandardCharsets.UTF_8),
                "HmacSHA256"
            );
            mac.init(secretKeySpec);

            byte[] hash = mac.doFinal(payload.getBytes(StandardCharsets.UTF_8));

            // Convert to hex string
            String generatedSignature = HexFormat.of().formatHex(hash);

            // Compare signatures (constant-time comparison to prevent timing attacks)
            return constantTimeEquals(generatedSignature, signature);

        } catch (NoSuchAlgorithmException | InvalidKeyException e) {
            throw new BadRequestException("Error verifying payment signature: " + e.getMessage());
        }
    }

    /**
     * Constant-time string comparison to prevent timing attacks
     */
    private boolean constantTimeEquals(String a, String b) {
        if (a.length() != b.length()) {
            return false;
        }

        int result = 0;
        for (int i = 0; i < a.length(); i++) {
            result |= a.charAt(i) ^ b.charAt(i);
        }

        return result == 0;
    }

    private String generateTransactionId() {
        return "TXN-" + UUID.randomUUID().toString();
    }

    public List<Payment> getAllPayments() {
        return paymentRepository.findAll();
    }
}
