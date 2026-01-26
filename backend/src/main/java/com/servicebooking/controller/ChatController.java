package com.servicebooking.controller;

import com.servicebooking.dto.ChatMessageDTO;
import com.servicebooking.security.UserPrincipal;
import com.servicebooking.service.ChatService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/chat")
@RequiredArgsConstructor
@Tag(name = "Chat", description = "Chat messaging")
@SecurityRequirement(name = "bearer-jwt")
public class ChatController {

    private final ChatService chatService;

    @GetMapping("/booking/{bookingId}")
    @Operation(summary = "Get booking chat messages")
    public ResponseEntity<List<ChatMessageDTO>> getBookingMessages(@PathVariable Long bookingId) {
        return ResponseEntity.ok(chatService.getBookingMessages(bookingId));
    }

    @PutMapping("/booking/{bookingId}/read")
    @Operation(summary = "Mark booking messages as read")
    public ResponseEntity<Void> markBookingMessagesAsRead(
            @PathVariable Long bookingId,
            @AuthenticationPrincipal UserPrincipal currentUser) {
        chatService.markBookingMessagesAsRead(bookingId, currentUser.getId());
        return ResponseEntity.ok().build();
    }

    @GetMapping("/unread-count")
    @Operation(summary = "Get unread message count")
    public ResponseEntity<Long> getUnreadMessageCount(
            @AuthenticationPrincipal UserPrincipal currentUser) {
        return ResponseEntity.ok(chatService.getUnreadMessageCount(currentUser.getId()));
    }
}
