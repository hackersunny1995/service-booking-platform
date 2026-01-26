package com.servicebooking.service;

import com.servicebooking.exception.BadRequestException;
import com.servicebooking.exception.ResourceNotFoundException;
import com.servicebooking.model.ProviderProfile;
import com.servicebooking.model.User;
import com.servicebooking.model.UserRole;
import com.servicebooking.repository.ProviderProfileRepository;
import com.servicebooking.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ProviderService {

    private final ProviderProfileRepository providerProfileRepository;
    private final UserRepository userRepository;

    public List<ProviderProfile> getAllProviders() {
        return providerProfileRepository.findAll();
    }

    public List<ProviderProfile> getAvailableProviders() {
        return providerProfileRepository.findByIsAvailableAndIsApproved(true, true);
    }

    public List<ProviderProfile> getNearbyProviders(Double latitude, Double longitude) {
        return providerProfileRepository.findNearbyProviders(latitude, longitude);
    }

    public ProviderProfile getProviderById(Long id) {
        return providerProfileRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Provider not found with id: " + id));
    }

    public ProviderProfile getProviderByUserId(Long userId) {
        return providerProfileRepository.findByUserId(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Provider profile not found for user id: " + userId));
    }

    @Transactional
    public ProviderProfile updateProviderProfile(Long userId, ProviderProfile profileDetails) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + userId));

        if (user.getRole() != UserRole.PROVIDER) {
            throw new BadRequestException("User is not a provider");
        }

        ProviderProfile profile = providerProfileRepository.findByUserId(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Provider profile not found"));

        if (profileDetails.getBio() != null) {
            profile.setBio(profileDetails.getBio());
        }
        if (profileDetails.getExperienceYears() != null) {
            profile.setExperienceYears(profileDetails.getExperienceYears());
        }
        if (profileDetails.getServiceRadiusKm() != null) {
            profile.setServiceRadiusKm(profileDetails.getServiceRadiusKm());
        }
        if (profileDetails.getLatitude() != null && profileDetails.getLongitude() != null) {
            profile.setLatitude(profileDetails.getLatitude());
            profile.setLongitude(profileDetails.getLongitude());
        }
        if (profileDetails.getIsAvailable() != null) {
            profile.setIsAvailable(profileDetails.getIsAvailable());
        }

        return providerProfileRepository.save(profile);
    }

    @Transactional
    public ProviderProfile updateLocation(Long userId, Double latitude, Double longitude) {
        ProviderProfile profile = getProviderByUserId(userId);
        profile.setLatitude(latitude);
        profile.setLongitude(longitude);
        return providerProfileRepository.save(profile);
    }

    @Transactional
    public ProviderProfile updateAvailability(Long userId, Boolean isAvailable) {
        ProviderProfile profile = getProviderByUserId(userId);
        profile.setIsAvailable(isAvailable);
        return providerProfileRepository.save(profile);
    }

    @Transactional
    public ProviderProfile approveProvider(Long providerId) {
        ProviderProfile profile = getProviderById(providerId);
        profile.setIsApproved(true);
        return providerProfileRepository.save(profile);
    }

    @Transactional
    public void updateProviderRating(Long providerId) {
        ProviderProfile profile = getProviderById(providerId);
        // Rating will be updated by Review service
        providerProfileRepository.save(profile);
    }
}
