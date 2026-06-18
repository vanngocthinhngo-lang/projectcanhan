package com.cinema.controller;

import com.cinema.model.Film;

import com.cinema.model.Showtime;

import com.cinema.repository.RoomRepository;
import com.cinema.service.*;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin")
@PreAuthorize("hasRole('ADMIN')")
@RequiredArgsConstructor
public class AdminController {

    private final FilmService filmService;
    private final ShowtimeService showtimeService;
    private final BookingService bookingService;
    private final UserService userService;
    private final RoomRepository roomRepository;

    // ======================== DASHBOARD ========================
    @GetMapping({"/", "/dashboard"})
    public String dashboard(Model model) {
        model.addAttribute("totalFilms", filmService.count());
        model.addAttribute("totalBookings", bookingService.countConfirmed());
        model.addAttribute("totalUsers", userService.count());
        model.addAttribute("totalRevenue", bookingService.sumRevenue());
        // Limit recent bookings to latest 10 to avoid heavy payloads
        model.addAttribute("recentBookings", bookingService.getAll().stream().limit(10).toList());
        return "admin/dashboard";
    }

    // ======================== PHIM ========================
    @GetMapping("/films")
    public String filmList(Model model) {
        model.addAttribute("films", filmService.getAll());
        return "admin/film-list";
    }

    @GetMapping("/films/add")
    public String filmAddForm(Model model) {
        model.addAttribute("film", new Film());
        return "admin/film-form";
    }

    @GetMapping("/films/edit/{id}")
    public String filmEditForm(@PathVariable Long id, Model model) {
        model.addAttribute("film", filmService.getById(id));
        return "admin/film-form";
    }

    @PostMapping("/films/save")
    public String filmSave(@ModelAttribute Film film, RedirectAttributes ra) {
        filmService.save(film);
        ra.addFlashAttribute("success", "Lưu phim thành công!");
        return "redirect:/admin/films";
    }

    @GetMapping("/films/delete/{id}")
    public String filmDelete(@PathVariable Long id, RedirectAttributes ra) {
        filmService.delete(id);
        ra.addFlashAttribute("success", "Xóa phim thành công!");
        return "redirect:/admin/films";
    }

    // ======================== SUAT CHIEU ========================
    @GetMapping("/showtimes")
    public String showtimeList(Model model) {
        model.addAttribute("showtimes", showtimeService.getAll());
        return "admin/showtime-list";
    }

    @GetMapping("/showtimes/add")
    public String showtimeAddForm(Model model) {
        model.addAttribute("showtime", new Showtime());
        model.addAttribute("films", filmService.getAll());
        model.addAttribute("rooms", roomRepository.findAll());
        return "admin/showtime-form";
    }

    @GetMapping("/showtimes/edit/{id}")
    public String showtimeEditForm(@PathVariable Long id, Model model) {
        model.addAttribute("showtime", showtimeService.getById(id));
        model.addAttribute("films", filmService.getAll());
        model.addAttribute("rooms", roomRepository.findAll());
        return "admin/showtime-form";
    }

    @PostMapping("/showtimes/save")
    public String showtimeSave(@ModelAttribute Showtime showtime, RedirectAttributes ra) {
        showtimeService.save(showtime);
        ra.addFlashAttribute("success", "Lưu suất chiếu thành công!");
        return "redirect:/admin/showtimes";
    }

    @GetMapping("/showtimes/delete/{id}")
    public String showtimeDelete(@PathVariable Long id, RedirectAttributes ra) {
        showtimeService.delete(id);
        ra.addFlashAttribute("success", "Xóa suất chiếu thành công!");
        return "redirect:/admin/showtimes";
    }

    // ======================== NGUOI DUNG ========================
    @GetMapping("/users")
    public String userList(Model model) {
        model.addAttribute("users", userService.getAll());
        return "admin/user-list";
    }

    @GetMapping("/users/delete/{id}")
    public String userDelete(@PathVariable Long id, RedirectAttributes ra) {
        userService.delete(id);
        ra.addFlashAttribute("success", "Xóa người dùng thành công!");
        return "redirect:/admin/users";
    }

    // ======================== BOOKING ========================
    @GetMapping("/bookings")
    public String bookingList(Model model) {
        model.addAttribute("bookings", bookingService.getAll());
        return "admin/booking-list";
    }
}