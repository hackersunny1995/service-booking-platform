package com.servicebooking.controller;

import com.servicebooking.model.ProviderProfile;
import com.servicebooking.security.UserPrincipal;
import com.servicebooking.service.ProviderService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/providers")
@RequiredArgsConstructor
@Tag(name = "Providers", description = "Provider management")
@SecurityRequirement(name = "bearer-jwt")
public class ProviderController {

    private final ProviderService providerService;

    @GetMapping
    @Operation(summary = "Get all available providers")
    public ResponseEntity<List<ProviderProfile>> getAvailableProviders() {
        return ResponseEntity.ok(providerService.getAvailableProviders());
    }

    @GetMapping("/all")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get all providers (Admin only)")
    public ResponseEntity<List<ProviderProfile>> getAllProviders() {
        return ResponseEntity.ok(providerService.getAllProviders());
    }

    @GetMapping("/nearby")
    @Operation(summary = "Get nearby providers")
    public ResponseEntity<List<ProviderProfile>> getNearbyProviders(
            @RequestParam Double latitude,
            @RequestParam Double longitude) {
        return ResponseEntity.ok(providerService.getNearbyProviders(latitude, longitude));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get provider by ID")
    public ResponseEntity<ProviderProfile> getProviderById(@PathVariable Long id) {
        return ResponseEntity.ok(providerService.getProviderById(id));
    }

    @GetMapping("/me")
    @PreAuthorize("hasRole('PROVIDER')")
    @Operation(summary = "Get current provider profile")
    public ResponseEntity<ProviderProfile> getCurrentProviderProfile(
            @AuthenticationPrincipal UserPrincipal currentUser) {
        return ResponseEntity.ok(providerService.getProviderByUserId(currentUser.getId()));
    }

    @PutMapping("/me")
    @PreAuthorize("hasRole('PROVIDER')")
    @Operation(summary = "Update current provider profile")
    public ResponseEntity<ProviderProfile> updateProviderProfile(
            @AuthenticationPrincipal UserPrincipal currentUser,
            @RequestBody ProviderProfile profile) {
        return ResponseEntity.ok(providerService.updateProviderProfile(currentUser.getId(), profile));
    }

    @PutMapping("/me/location")
    @PreAuthorize("hasRole('PROVIDER')")
    @Operation(summary = "Update provider location")
    public ResponseEntity<ProviderProfile> updateLocation(
            @AuthenticationPrincipal UserPrincipal currentUser,
            @RequestBody Map<String, Double> location) {
        return ResponseEntity.ok(providerService.updateLocation(
                currentUser.getId(),
                location.get("latitude"),
                location.get("longitude")
        ));
    }

    @PutMapping("/me/availability")
    @PreAuthorize("hasRole('PROVIDER')")
    @Operation(summary = "Update provider availability")
    public ResponseEntity<ProviderProfile> updateAvailability(
            @AuthenticationPrincipal UserPrincipal currentUser,
            @RequestBody Map<String, Boolean> availability) {
        return ResponseEntity.ok(providerService.updateAvailability(
                currentUser.getId(),
                availability.get("isAvailable")
        ));
    }

    @PutMapping("/{id}/approve")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Approve provider (Admin only)")
    public ResponseEntity<ProviderProfile> approveProvider(@PathVariable Long id) {
        return ResponseEntity.ok(providerService.approveProvider(id));
    }
}
