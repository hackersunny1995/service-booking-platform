package com.servicebooking.repository;

import com.servicebooking.model.ProviderAvailability;
import com.servicebooking.model.ProviderProfile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ProviderAvailabilityRepository extends JpaRepository<ProviderAvailability, Long> {
    List<ProviderAvailability> findByProvider(ProviderProfile provider);

    List<ProviderAvailability> findByProviderId(Long providerId);

    Optional<ProviderAvailability> findByProviderIdAndDayOfWeek(Long providerId, Integer dayOfWeek);

    List<ProviderAvailability> findByProviderIdAndIsAvailable(Long providerId, Boolean isAvailable);
}
