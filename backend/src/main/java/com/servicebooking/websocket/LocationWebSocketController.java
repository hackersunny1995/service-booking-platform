package com.servicebooking.websocket;

import com.servicebooking.dto.LocationUpdateDTO;
import com.servicebooking.service.ProviderService;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import java.time.LocalDateTime;

@Controller
@RequiredArgsConstructor
public class LocationWebSocketController {

    private final SimpMessagingTemplate messagingTemplate;
    private final ProviderService providerService;

    @MessageMapping("/location/{bookingId}/update")
    public void updateLocation(@DestinationVariable Long bookingId,
                              @Payload LocationUpdateDTO locationUpdate) {
        // Update provider location in database
        providerService.updateLocation(
                locationUpdate.getProviderId(),
                locationUpdate.getLatitude(),
                locationUpdate.getLongitude()
        );

        // Set timestamp
        locationUpdate.setTimestamp(LocalDateTime.now());

        // Broadcast location to booking channel
        messagingTemplate.convertAndSend(
                "/topic/booking/" + bookingId + "/location",
                locationUpdate
        );
    }
}
