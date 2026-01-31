package com.servicebooking.repository;

import com.servicebooking.model.Booking;
import com.servicebooking.model.Payment;
import com.servicebooking.model.PaymentStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, Long> {
    List<Payment> findByBooking(Booking booking);

    @Query("SELECT p FROM Payment p LEFT JOIN FETCH p.booking b LEFT JOIN FETCH b.customer LEFT JOIN FETCH b.provider LEFT JOIN FETCH b.service s LEFT JOIN FETCH s.category WHERE p.booking.id = :bookingId")
    List<Payment> findByBookingId(@Param("bookingId") Long bookingId);

    @Query("SELECT p FROM Payment p LEFT JOIN FETCH p.booking b LEFT JOIN FETCH b.customer LEFT JOIN FETCH b.provider LEFT JOIN FETCH b.service s LEFT JOIN FETCH s.category WHERE p.transactionId = :transactionId")
    Optional<Payment> findByTransactionId(@Param("transactionId") String transactionId);

    @Query("SELECT p FROM Payment p LEFT JOIN FETCH p.booking b LEFT JOIN FETCH b.customer LEFT JOIN FETCH b.provider LEFT JOIN FETCH b.service s LEFT JOIN FETCH s.category WHERE p.status = :status")
    List<Payment> findByStatus(@Param("status") PaymentStatus status);

    @Query("SELECT p FROM Payment p LEFT JOIN FETCH p.booking b LEFT JOIN FETCH b.customer LEFT JOIN FETCH b.provider LEFT JOIN FETCH b.service s LEFT JOIN FETCH s.category WHERE p.id = :id")
    Optional<Payment> findByIdWithRelations(@Param("id") Long id);

    @Query("SELECT p FROM Payment p LEFT JOIN FETCH p.booking b LEFT JOIN FETCH b.customer LEFT JOIN FETCH b.provider LEFT JOIN FETCH b.service s LEFT JOIN FETCH s.category")
    List<Payment> findAllWithRelations();
}
