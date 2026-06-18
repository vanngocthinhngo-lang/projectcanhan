package com.cinema.repository;

import com.cinema.model.ReservedSeat;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ReservedSeatRepository extends JpaRepository<ReservedSeat, Long> {
    List<ReservedSeat> findByShowtimeId(Long showtimeId);
    List<ReservedSeat> findByBookingId(Long bookingId);
}
