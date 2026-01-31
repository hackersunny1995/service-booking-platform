package com.servicebooking.repository;

import com.servicebooking.model.Booking;
import com.servicebooking.model.BookingStatus;
import com.servicebooking.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface BookingRepository extends JpaRepository<Booking, Long> {
    List<Booking> findByCustomer(User customer);

    @Query("SELECT b FROM Booking b LEFT JOIN FETCH b.customer LEFT JOIN FETCH b.provider LEFT JOIN FETCH b.service s LEFT JOIN FETCH s.category WHERE b.customer.id = :customerId")
    List<Booking> findByCustomerId(@Param("customerId") Long customerId);

    List<Booking> findByProvider(User provider);

    @Query("SELECT b FROM Booking b LEFT JOIN FETCH b.customer LEFT JOIN FETCH b.provider LEFT JOIN FETCH b.service s LEFT JOIN FETCH s.category WHERE b.provider.id = :providerId")
    List<Booking> findByProviderId(@Param("providerId") Long providerId);

    @Query("SELECT b FROM Booking b LEFT JOIN FETCH b.customer LEFT JOIN FETCH b.provider LEFT JOIN FETCH b.service s LEFT JOIN FETCH s.category WHERE b.status = :status")
    List<Booking> findByStatus(@Param("status") BookingStatus status);

    @Query("SELECT b FROM Booking b LEFT JOIN FETCH b.customer LEFT JOIN FETCH b.provider LEFT JOIN FETCH b.service s LEFT JOIN FETCH s.category WHERE b.customer.id = :customerId AND b.status = :status")
    List<Booking> findByCustomerIdAndStatus(@Param("customerId") Long customerId, @Param("status") BookingStatus status);

    @Query("SELECT b FROM Booking b LEFT JOIN FETCH b.customer LEFT JOIN FETCH b.provider LEFT JOIN FETCH b.service s LEFT JOIN FETCH s.category WHERE b.provider.id = :providerId AND b.status = :status")
    List<Booking> findByProviderIdAndStatus(@Param("providerId") Long providerId, @Param("status") BookingStatus status);

    @Query("SELECT b FROM Booking b LEFT JOIN FETCH b.customer LEFT JOIN FETCH b.provider LEFT JOIN FETCH b.service s LEFT JOIN FETCH s.category WHERE b.scheduledDate BETWEEN :startDate AND :endDate")
    List<Booking> findByScheduledDateBetween(@Param("startDate") LocalDate startDate, @Param("endDate") LocalDate endDate);

    @Query("SELECT COUNT(b) FROM Booking b WHERE b.status = :status")
    Long countByStatus(@Param("status") BookingStatus status);

    @Query("SELECT b FROM Booking b LEFT JOIN FETCH b.customer LEFT JOIN FETCH b.provider LEFT JOIN FETCH b.service s LEFT JOIN FETCH s.category WHERE b.provider.id = :providerId AND b.scheduledDate = :date")
    List<Booking> findProviderBookingsForDate(@Param("providerId") Long providerId, @Param("date") LocalDate date);

    @Query("SELECT b FROM Booking b LEFT JOIN FETCH b.customer LEFT JOIN FETCH b.provider LEFT JOIN FETCH b.service s LEFT JOIN FETCH s.category WHERE b.id = :id")
    Optional<Booking> findByIdWithRelations(@Param("id") Long id);

    @Query("SELECT b FROM Booking b LEFT JOIN FETCH b.customer LEFT JOIN FETCH b.provider LEFT JOIN FETCH b.service s LEFT JOIN FETCH s.category")
    List<Booking> findAllWithRelations();
}
