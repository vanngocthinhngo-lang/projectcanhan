package com.cinema.repository;

import com.cinema.model.Showtime;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.time.LocalDateTime;
import java.util.List;

public interface ShowtimeRepository extends JpaRepository<Showtime, Long> {

    List<Showtime> findByFilmId(Long filmId);

    List<Showtime> findByRoomId(Long roomId);

    @Query("SELECT s FROM Showtime s WHERE s.film.id = :filmId AND s.startTime >= :from ORDER BY s.startTime")
    List<Showtime> findUpcomingByFilm(@Param("filmId") Long filmId, @Param("from") LocalDateTime from);

    @Query("SELECT s FROM Showtime s WHERE s.startTime BETWEEN :from AND :to ORDER BY s.startTime")
    List<Showtime> findByDateRange(@Param("from") LocalDateTime from, @Param("to") LocalDateTime to);
}
