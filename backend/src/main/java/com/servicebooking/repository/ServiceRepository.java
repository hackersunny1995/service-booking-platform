package com.servicebooking.repository;

import com.servicebooking.model.Service;
import com.servicebooking.model.ServiceCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ServiceRepository extends JpaRepository<Service, Long> {
    List<Service> findByCategory(ServiceCategory category);

    List<Service> findByCategoryId(Long categoryId);

    @Query("SELECT s FROM Service s LEFT JOIN FETCH s.category WHERE s.isActive = :isActive")
    List<Service> findByIsActive(@Param("isActive") Boolean isActive);

    @Query("SELECT s FROM Service s LEFT JOIN FETCH s.category WHERE s.category.id = :categoryId AND s.isActive = :isActive")
    List<Service> findByCategoryIdAndIsActive(@Param("categoryId") Long categoryId, @Param("isActive") Boolean isActive);

    @Query("SELECT s FROM Service s LEFT JOIN FETCH s.category WHERE s.id = :id")
    Optional<Service> findByIdWithCategory(@Param("id") Long id);
}
