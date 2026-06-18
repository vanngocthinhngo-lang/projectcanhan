package com.cinema.controller;

import com.cinema.model.Booking;
import com.cinema.service.BookingService;
import com.cinema.service.ShowtimeService;
import com.cinema.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Objects;

@Controller
@RequiredArgsConstructor
public class BookingController {

    private final BookingService bookingService;
    private final ShowtimeService showtimeService;
    private final UserService userService;

    // Trang chon ghe
    @GetMapping("/booking/{showtimeId}")
    public String selectSeat(@PathVariable Long showtimeId, Model model) {
        model.addAttribute("showtime", showtimeService.getById(showtimeId));
        model.addAttribute("bookedSeats", bookingService.getBookedSeats(showtimeId));
        return "booking/seat-select";
    }

    // Xac nhan dat ve
    @PostMapping("/booking/confirm")
    public String confirmBooking(@RequestParam Long showtimeId,
                                 @RequestParam List<String> seats,
                                 Authentication auth,
                                 RedirectAttributes ra) {
        // Authentication check
        if (auth == null || !auth.isAuthenticated()) {
            ra.addFlashAttribute("error", "Vui lòng đăng nhập trước khi đặt vé.");
            return "redirect:/login";
        }

        // Seats validation
        if (seats == null || seats.isEmpty() || seats.stream().allMatch(s -> s == null || s.isBlank())) {
            ra.addFlashAttribute("error", "Vui lòng chọn ít nhất một ghế.");
            return "redirect:/booking/" + showtimeId;
        }

        try {
            String email = auth.getName();
            Long userId = userService.getByEmail(email).getId();
            Booking booking = bookingService.book(userId, showtimeId, seats);
            ra.addFlashAttribute("booking", booking);
            return "redirect:/booking/success/" + booking.getId();
        } catch (Exception e) {
            // Preserve message for user and redirect back to seat selection
            ra.addFlashAttribute("error", Objects.toString(e.getMessage(), "Đã có lỗi xảy ra khi đặt vé."));
            return "redirect:/booking/" + showtimeId;
        }
    }

    // Trang thanh cong
    @GetMapping("/booking/success/{id}")
    public String bookingSuccess(@PathVariable Long id, Model model) {
        model.addAttribute("booking", bookingService.getById(id));
        return "booking/success";
    }

    // Lich su dat ve cua nguoi dung
    @GetMapping("/my-bookings")
    public String myBookings(Authentication auth, Model model) {
        if (auth == null || !auth.isAuthenticated()) {
            return "redirect:/login";
        }
        Long userId = userService.getByEmail(auth.getName()).getId();
        model.addAttribute("bookings", bookingService.getByUser(userId));
        return "booking/my-bookings";
    }

    // Huy ve
    @PostMapping("/booking/cancel/{id}")
    public String cancelBooking(@PathVariable Long id, RedirectAttributes ra) {
        try {
            bookingService.cancel(id);
            ra.addFlashAttribute("success", "Hủy vé thành công!");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Không thể hủy vé: " + e.getMessage());
        }
        return "redirect:/my-bookings";
    }
}
