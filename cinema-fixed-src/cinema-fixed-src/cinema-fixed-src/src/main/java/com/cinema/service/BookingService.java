package com.cinema.service;

import com.cinema.model.Booking;
import com.cinema.model.Showtime;
import com.cinema.model.User;
import com.cinema.repository.BookingRepository;
import com.cinema.repository.ShowtimeRepository;
import com.cinema.repository.UserRepository;
import com.cinema.repository.ReservedSeatRepository;
import com.cinema.model.ReservedSeat;
import org.springframework.dao.DataIntegrityViolationException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class BookingService {

    private final BookingRepository bookingRepository;
    private final ShowtimeRepository showtimeRepository;
    private final UserRepository userRepository;
    private final ReservedSeatRepository reservedSeatRepository;

    @Transactional
    public Booking book(Long userId, Long showtimeId, List<String> seats) {
        Showtime showtime = showtimeRepository.findById(showtimeId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy suất chiếu"));
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng"));

        // Create booking as PENDING first
        Booking booking = Booking.builder()
                .user(user)
                .showtime(showtime)
                .seats(seats)
                .totalPrice(showtime.getPrice() * seats.size())
                .status("PENDING")
                .build();

        booking = bookingRepository.save(booking);

        // Try to reserve seats at DB-level using unique constraint
        try {
            for (String seat : seats) {
                ReservedSeat rs = ReservedSeat.builder()
                        .showtimeId(showtimeId)
                        .bookingId(booking.getId())
                        .seatLabel(seat)
                        .build();
                reservedSeatRepository.save(rs);
            }
        } catch (DataIntegrityViolationException ex) {
            // A unique constraint on (showtime_id, seat_label) failed -> some seat already reserved
            throw new RuntimeException("Một hoặc nhiều ghế đã được đặt. Vui lòng chọn ghế khác.");
        }

        // All seats reserved successfully -> confirm booking
        booking.setStatus("CONFIRMED");
        return bookingRepository.save(booking);
    }

    public List<Booking> getByUser(Long userId) {
        return bookingRepository.findByUserIdOrderByBookingTimeDesc(userId);
    }

    public Booking getById(Long id) {
        return bookingRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Booking not found: " + id));
    }

    public List<String> getBookedSeats(Long showtimeId) {
        return bookingRepository.findBookedSeatsByShowtime(showtimeId);
    }

    public void cancel(Long id) {
        Booking booking = getById(id);
        // remove reserved seats for this booking
        reservedSeatRepository.findByBookingId(booking.getId()).forEach(reservedSeatRepository::delete);
        booking.setStatus("CANCELLED");
        bookingRepository.save(booking);
    }

    public List<Booking> getAll() {
        return bookingRepository.findAll();
    }

    public long countConfirmed() {
        return bookingRepository.countConfirmed();
    }

    public Double sumRevenue() {
        Double rev = bookingRepository.sumRevenue();
        return rev != null ? rev : 0.0;
    }
}
