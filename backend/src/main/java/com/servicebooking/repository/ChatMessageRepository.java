package com.servicebooking.repository;

import com.servicebooking.model.Booking;
import com.servicebooking.model.ChatMessage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ChatMessageRepository extends JpaRepository<ChatMessage, Long> {
    List<ChatMessage> findByBooking(Booking booking);

    List<ChatMessage> findByBookingId(Long bookingId);

    List<ChatMessage> findByBookingIdOrderByCreatedAtAsc(Long bookingId);

    List<ChatMessage> findByReceiverIdAndIsRead(Long receiverId, Boolean isRead);
}
