package com.servicebooking.service;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import com.servicebooking.model.User;
import com.servicebooking.repository.NotificationRepository;
import com.servicebooking.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class NotificationService {

    private final NotificationRepository notificationRepository;
    private final UserRepository userRepository;

    public List<com.servicebooking.model.Notification> getUserNotifications(Long userId) {
        return notificationRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }

    public Long getUnreadNotificationCount(Long userId) {
        return notificationRepository.countByUserIdAndIsRead(userId, false);
    }

    @Transactional
    public void markAsRead(Long notificationId) {
        notificationRepository.findById(notificationId).ifPresent(notification -> {
            notification.setIsRead(true);
            notificationRepository.save(notification);
        });
    }

    @Transactional
    public void markAllAsRead(Long userId) {
        List<com.servicebooking.model.Notification> notifications =
                notificationRepository.findByUserIdAndIsRead(userId, false);
        notifications.forEach(notification -> {
            notification.setIsRead(true);
            notificationRepository.save(notification);
        });
    }

    @Transactional
    public void sendNotification(Long userId, String title, String body, String type) {
        User user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            return;
        }

        // Save notification to database
        com.servicebooking.model.Notification notification = new com.servicebooking.model.Notification();
        notification.setUser(user);
        notification.setTitle(title);
        notification.setBody(body);
        notification.setType(type);
        notification.setIsRead(false);
        notificationRepository.save(notification);

        // Send push notification via Firebase
        if (user.getFcmToken() != null && !user.getFcmToken().isEmpty()) {
            sendPushNotification(user.getFcmToken(), title, body);
        }
    }

    private void sendPushNotification(String fcmToken, String title, String body) {
        try {
            Message message = Message.builder()
                    .setToken(fcmToken)
                    .setNotification(Notification.builder()
                            .setTitle(title)
                            .setBody(body)
                            .build())
                    .build();

            String response = FirebaseMessaging.getInstance().send(message);
            System.out.println("Successfully sent message: " + response);
        } catch (Exception e) {
            System.err.println("Error sending notification: " + e.getMessage());
        }
    }

    @Transactional
    public void updateFcmToken(Long userId, String fcmToken) {
        userRepository.findById(userId).ifPresent(user -> {
            user.setFcmToken(fcmToken);
            userRepository.save(user);
        });
    }

    // Helper methods for specific notification types
    public void sendBookingCreatedNotification(Long providerId, Long bookingId) {
        sendNotification(
                providerId,
                "New Booking Request",
                "You have received a new booking request #" + bookingId,
                "BOOKING_REQUEST"
        );
    }

    public void sendBookingConfirmedNotification(Long customerId, Long bookingId) {
        sendNotification(
                customerId,
                "Booking Confirmed",
                "Your booking #" + bookingId + " has been confirmed",
                "BOOKING_CONFIRMED"
        );
    }

    public void sendBookingCancelledNotification(Long userId, Long bookingId) {
        sendNotification(
                userId,
                "Booking Cancelled",
                "Booking #" + bookingId + " has been cancelled",
                "BOOKING_CANCELLED"
        );
    }

    public void sendBookingCompletedNotification(Long customerId, Long bookingId) {
        sendNotification(
                customerId,
                "Service Completed",
                "Your booking #" + bookingId + " has been completed. Please rate your experience!",
                "BOOKING_COMPLETED"
        );
    }

    public void sendNewMessageNotification(Long receiverId, String senderName) {
        sendNotification(
                receiverId,
                "New Message",
                "You have a new message from " + senderName,
                "NEW_MESSAGE"
        );
    }
}
