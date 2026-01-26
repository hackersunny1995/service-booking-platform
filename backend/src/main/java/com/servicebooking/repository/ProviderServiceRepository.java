package com.servicebooking.repository;

import com.servicebooking.model.ProviderProfile;
import com.servicebooking.model.ProviderService;
import com.servicebooking.model.Service;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ProviderServiceRepository extends JpaRepository<ProviderService, Long> {
    List<ProviderService> findByProvider(ProviderProfile provider);

    List<ProviderService> findByProviderId(Long providerId);

    List<ProviderService> findByService(Service service);

    List<ProviderService> findByServiceId(Long serviceId);

    List<ProviderService> findByProviderIdAndIsActive(Long providerId, Boolean isActive);

    Optional<ProviderService> findByProviderIdAndServiceId(Long providerId, Long serviceId);
}
