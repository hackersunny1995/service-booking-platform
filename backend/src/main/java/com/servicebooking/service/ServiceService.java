package com.servicebooking.service;

import com.servicebooking.exception.ResourceNotFoundException;
import com.servicebooking.repository.ServiceRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ServiceService {

    private final ServiceRepository serviceRepository;
    private final ServiceCategoryService serviceCategoryService;

    public List<com.servicebooking.model.Service> getAllServices() {
        return serviceRepository.findAll();
    }

    public List<com.servicebooking.model.Service> getActiveServices() {
        return serviceRepository.findByIsActive(true);
    }

    public List<com.servicebooking.model.Service> getServicesByCategory(Long categoryId) {
        return serviceRepository.findByCategoryIdAndIsActive(categoryId, true);
    }

    public com.servicebooking.model.Service getServiceById(Long id) {
        return serviceRepository.findByIdWithCategory(id)
                .orElseThrow(() -> new ResourceNotFoundException("Service not found with id: " + id));
    }

    @Transactional
    public com.servicebooking.model.Service createService(com.servicebooking.model.Service service) {
        // Verify category exists
        serviceCategoryService.getCategoryById(service.getCategory().getId());
        return serviceRepository.save(service);
    }

    @Transactional
    public com.servicebooking.model.Service updateService(Long id, com.servicebooking.model.Service serviceDetails) {
        com.servicebooking.model.Service service = getServiceById(id);
        service.setName(serviceDetails.getName());
        service.setDescription(serviceDetails.getDescription());
        service.setBasePrice(serviceDetails.getBasePrice());
        service.setDurationMinutes(serviceDetails.getDurationMinutes());
        service.setImageUrl(serviceDetails.getImageUrl());
        service.setIsActive(serviceDetails.getIsActive());
        if (serviceDetails.getCategory() != null) {
            service.setCategory(serviceDetails.getCategory());
        }
        return serviceRepository.save(service);
    }

    @Transactional
    public void deleteService(Long id) {
        com.servicebooking.model.Service service = getServiceById(id);
        serviceRepository.delete(service);
    }
}
