package com.servicebooking.service;

import com.servicebooking.exception.ResourceNotFoundException;
import com.servicebooking.model.ServiceCategory;
import com.servicebooking.repository.ServiceCategoryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ServiceCategoryService {

    private final ServiceCategoryRepository serviceCategoryRepository;

    public List<ServiceCategory> getAllCategories() {
        return serviceCategoryRepository.findAll();
    }

    public List<ServiceCategory> getActiveCategories() {
        return serviceCategoryRepository.findByIsActive(true);
    }

    public ServiceCategory getCategoryById(Long id) {
        return serviceCategoryRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Category not found with id: " + id));
    }

    @Transactional
    public ServiceCategory createCategory(ServiceCategory category) {
        return serviceCategoryRepository.save(category);
    }

    @Transactional
    public ServiceCategory updateCategory(Long id, ServiceCategory categoryDetails) {
        ServiceCategory category = getCategoryById(id);
        category.setName(categoryDetails.getName());
        category.setDescription(categoryDetails.getDescription());
        category.setIconUrl(categoryDetails.getIconUrl());
        category.setIsActive(categoryDetails.getIsActive());
        return serviceCategoryRepository.save(category);
    }

    @Transactional
    public void deleteCategory(Long id) {
        ServiceCategory category = getCategoryById(id);
        serviceCategoryRepository.delete(category);
    }
}
