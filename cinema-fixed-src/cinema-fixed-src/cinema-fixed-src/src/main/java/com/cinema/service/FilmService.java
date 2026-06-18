package com.cinema.service;

import com.cinema.model.Film;
import com.cinema.repository.FilmRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FilmService {

    private final FilmRepository filmRepository;

    public List<Film> getAll() {
        return filmRepository.findAll();
    }

    public Film getById(Long id) {
        return filmRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Film not found: " + id));
    }

    public List<Film> getNowShowing() {
        return filmRepository.findByStatus("SHOWING");
    }

    public List<Film> getUpcoming() {
        return filmRepository.findByStatus("UPCOMING");
    }

    public List<Film> search(String keyword, String genre) {
        return filmRepository.searchFilms(
                (keyword == null || keyword.isBlank()) ? null : keyword,
                (genre == null || genre.isBlank()) ? null : genre
        );
    }

    public List<String> getAllGenres() {
        return filmRepository.findAllGenres();
    }

    public Film save(Film film) {
        return filmRepository.save(film);
    }

    public void delete(Long id) {
        filmRepository.deleteById(id);
    }

    public long count() {
        return filmRepository.count();
    }
}
