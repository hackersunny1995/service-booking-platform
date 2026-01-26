package com.servicebooking.repository;

import com.servicebooking.model.Service;
import com.servicebooking.model.ServiceCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ServiceRepository extends JpaRepository<Service, Long> {
    List<Service> findByCategory(ServiceCategory category);

    List<Service> findByCategoryId(Long categoryId);

    List<Service> findByIsActive(Boolean isActive);

    List<Service> findByCategoryIdAndIsActive(Long categoryId, Boolean isActive);
}
