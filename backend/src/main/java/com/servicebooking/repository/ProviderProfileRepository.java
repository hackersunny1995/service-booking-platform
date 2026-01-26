package com.servicebooking.repository;

import com.servicebooking.model.ProviderProfile;
import com.servicebooking.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ProviderProfileRepository extends JpaRepository<ProviderProfile, Long> {
    Optional<ProviderProfile> findByUser(User user);

    Optional<ProviderProfile> findByUserId(Long userId);

    List<ProviderProfile> findByIsAvailableAndIsApproved(Boolean isAvailable, Boolean isApproved);

    List<ProviderProfile> findByIsApproved(Boolean isApproved);

    @Query("SELECT p FROM ProviderProfile p WHERE p.isAvailable = true AND p.isApproved = true " +
           "AND (6371 * acos(cos(radians(:lat)) * cos(radians(p.latitude)) * " +
           "cos(radians(p.longitude) - radians(:lng)) + sin(radians(:lat)) * " +
           "sin(radians(p.latitude)))) <= p.serviceRadiusKm")
    List<ProviderProfile> findNearbyProviders(@Param("lat") Double latitude, @Param("lng") Double longitude);
}
