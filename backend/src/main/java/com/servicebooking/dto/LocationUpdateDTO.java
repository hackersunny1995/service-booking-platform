package com.servicebooking.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LocationUpdateDTO {
    private Long bookingId;
    private Long providerId;
    private Double latitude;
    private Double longitude;
    private LocalDateTime timestamp;
}
