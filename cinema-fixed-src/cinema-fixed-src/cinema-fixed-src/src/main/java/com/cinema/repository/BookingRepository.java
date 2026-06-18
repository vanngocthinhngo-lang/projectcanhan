package com.cinema.repository;

import com.cinema.model.Booking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

public interface BookingRepository extends JpaRepository<Booking, Long> {

    List<Booking> findByUserIdOrderByBookingTimeDesc(Long userId);

    List<Booking> findByShowtimeId(Long showtimeId);

    @Query("SELECT bs FROM Booking b JOIN b.seats bs WHERE b.showtime.id = :showtimeId AND b.status != 'CANCELLED'")
    List<String> findBookedSeatsByShowtime(@Param("showtimeId") Long showtimeId);

    @Query("SELECT COUNT(b) FROM Booking b WHERE b.status = 'CONFIRMED'")
    long countConfirmed();

    @Query("SELECT SUM(b.totalPrice) FROM Booking b WHERE b.status = 'CONFIRMED'")
    Double sumRevenue();
}
