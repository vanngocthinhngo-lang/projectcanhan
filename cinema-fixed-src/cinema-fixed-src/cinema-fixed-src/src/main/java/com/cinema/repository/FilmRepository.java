package com.cinema.repository;

import com.cinema.model.Film;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

public interface FilmRepository extends JpaRepository<Film, Long> {

    List<Film> findByTitleContainingIgnoreCase(String keyword);

    List<Film> findByStatus(String status);

    List<Film> findByGenre(String genre);

    @Query("SELECT DISTINCT f.genre FROM Film f ORDER BY f.genre")
    List<String> findAllGenres();

    @Query("SELECT f FROM Film f WHERE f.status = 'SHOWING' ORDER BY f.releaseDate DESC")
    List<Film> findNowShowing();

    @Query("SELECT f FROM Film f WHERE (:keyword IS NULL OR LOWER(f.title) LIKE LOWER(CONCAT('%', :keyword, '%'))) AND (:genre IS NULL OR f.genre = :genre)")
    List<Film> searchFilms(@Param("keyword") String keyword, @Param("genre") String genre);
}
