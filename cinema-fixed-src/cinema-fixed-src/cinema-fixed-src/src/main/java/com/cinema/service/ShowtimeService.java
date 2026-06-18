package com.cinema.service;

import com.cinema.model.Showtime;
import com.cinema.repository.ShowtimeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ShowtimeService {

    private final ShowtimeRepository showtimeRepository;

    public List<Showtime> getAll() {
        return showtimeRepository.findAll();
    }

    public Showtime getById(Long id) {
        return showtimeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Showtime not found: " + id));
    }

    public List<Showtime> getByFilm(Long filmId) {
        return showtimeRepository.findByFilmId(filmId);
    }

    public List<Showtime> getUpcomingByFilm(Long filmId) {
        return showtimeRepository.findUpcomingByFilm(filmId, LocalDateTime.now());
    }

    public Showtime save(Showtime showtime) {
        return showtimeRepository.save(showtime);
    }

    public void delete(Long id) {
        showtimeRepository.deleteById(id);
    }

    public long count() {
        return showtimeRepository.count();
    }
}
