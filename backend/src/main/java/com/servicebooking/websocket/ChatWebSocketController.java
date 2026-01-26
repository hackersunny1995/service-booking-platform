package com.servicebooking.websocket;

import com.servicebooking.dto.ChatMessageDTO;
import com.servicebooking.service.ChatService;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

@Controller
@RequiredArgsConstructor
public class ChatWebSocketController {

    private final SimpMessagingTemplate messagingTemplate;
    private final ChatService chatService;

    @MessageMapping("/chat/{bookingId}/send")
    public void sendMessage(@DestinationVariable Long bookingId,
                           @Payload ChatMessageDTO message) {
        // Save message to database
        ChatMessageDTO savedMessage = chatService.sendMessage(message.getSenderId(), message);

        // Send to specific booking channel
        messagingTemplate.convertAndSend(
                "/topic/booking/" + bookingId + "/chat",
                savedMessage
        );

        // Send notification to receiver
        messagingTemplate.convertAndSend(
                "/queue/user/" + message.getReceiverId() + "/notifications",
                savedMessage
        );
    }

    @MessageMapping("/chat/{messageId}/read")
    public void markAsRead(@DestinationVariable Long messageId) {
        chatService.markMessageAsRead(messageId);
    }
}
