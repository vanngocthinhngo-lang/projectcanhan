package com.cinema.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "bookings")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Booking {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "showtime_id", nullable = false)
    private Showtime showtime;

    @Column(name = "total_price", nullable = false)
    private double totalPrice;

    @Column(name = "booking_time")
    private LocalDateTime bookingTime;

    @Column(length = 20)
    private String status; // PENDING, CONFIRMED, CANCELLED

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "booking_seats", joinColumns = @JoinColumn(name = "booking_id"))
    @Column(name = "seat_label")
    private List<String> seats;

    @PrePersist
    public void prePersist() {
        this.bookingTime = LocalDateTime.now();
        if (this.status == null) this.status = "CONFIRMED";
    }
}
