package com.servicebooking.service;

import com.servicebooking.dto.ChatMessageDTO;
import com.servicebooking.exception.ResourceNotFoundException;
import com.servicebooking.model.Booking;
import com.servicebooking.model.ChatMessage;
import com.servicebooking.model.User;
import com.servicebooking.repository.BookingRepository;
import com.servicebooking.repository.ChatMessageRepository;
import com.servicebooking.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ChatService {

    private final ChatMessageRepository chatMessageRepository;
    private final BookingRepository bookingRepository;
    private final UserRepository userRepository;

    public List<ChatMessageDTO> getBookingMessages(Long bookingId) {
        List<ChatMessage> messages = chatMessageRepository.findByBookingIdOrderByCreatedAtAsc(bookingId);
        return messages.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    public ChatMessageDTO sendMessage(Long senderId, ChatMessageDTO messageDTO) {
        Booking booking = bookingRepository.findById(messageDTO.getBookingId())
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found"));

        User sender = userRepository.findById(senderId)
                .orElseThrow(() -> new ResourceNotFoundException("Sender not found"));

        User receiver = userRepository.findById(messageDTO.getReceiverId())
                .orElseThrow(() -> new ResourceNotFoundException("Receiver not found"));

        ChatMessage chatMessage = new ChatMessage();
        chatMessage.setBooking(booking);
        chatMessage.setSender(sender);
        chatMessage.setReceiver(receiver);
        chatMessage.setMessage(messageDTO.getMessage());
        chatMessage.setMessageType(messageDTO.getMessageType() != null ? messageDTO.getMessageType() : "TEXT");
        chatMessage.setIsRead(false);

        chatMessage = chatMessageRepository.save(chatMessage);
        return convertToDTO(chatMessage);
    }

    @Transactional
    public void markMessageAsRead(Long messageId) {
        ChatMessage message = chatMessageRepository.findById(messageId)
                .orElseThrow(() -> new ResourceNotFoundException("Message not found"));
        message.setIsRead(true);
        chatMessageRepository.save(message);
    }

    @Transactional
    public void markBookingMessagesAsRead(Long bookingId, Long userId) {
        List<ChatMessage> unreadMessages = chatMessageRepository.findByReceiverIdAndIsRead(userId, false);
        unreadMessages.stream()
                .filter(msg -> msg.getBooking().getId().equals(bookingId))
                .forEach(msg -> {
                    msg.setIsRead(true);
                    chatMessageRepository.save(msg);
                });
    }

    public Long getUnreadMessageCount(Long userId) {
        return (long) chatMessageRepository.findByReceiverIdAndIsRead(userId, false).size();
    }

    private ChatMessageDTO convertToDTO(ChatMessage message) {
        return new ChatMessageDTO(
                message.getId(),
                message.getBooking().getId(),
                message.getSender().getId(),
                message.getReceiver().getId(),
                message.getMessage(),
                message.getMessageType(),
                message.getIsRead(),
                message.getCreatedAt()
        );
    }
}
