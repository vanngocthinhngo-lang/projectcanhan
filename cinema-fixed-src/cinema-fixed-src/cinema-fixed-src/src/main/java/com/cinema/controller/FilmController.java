package com.cinema.controller;

import com.cinema.service.FilmService;
import com.cinema.service.ShowtimeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
public class FilmController {

    private final FilmService filmService;
    private final ShowtimeService showtimeService;

    @GetMapping({"/", "/films"})
    public String listFilms(@RequestParam(required = false) String keyword,
                            @RequestParam(required = false) String genre,
                            Model model) {
        if ((keyword != null && !keyword.isBlank()) || (genre != null && !genre.isBlank())) {
            model.addAttribute("films", filmService.search(keyword, genre));
        } else {
            model.addAttribute("films", filmService.getAll());
        }
        model.addAttribute("genres", filmService.getAllGenres());
        model.addAttribute("keyword", keyword);
        model.addAttribute("selectedGenre", genre);
        return "film/list";
    }

    @GetMapping("/films/{id}")
    public String filmDetail(@PathVariable Long id, Model model) {
        model.addAttribute("film", filmService.getById(id));
        model.addAttribute("showtimes", showtimeService.getUpcomingByFilm(id));
        return "film/detail";
    }
}
