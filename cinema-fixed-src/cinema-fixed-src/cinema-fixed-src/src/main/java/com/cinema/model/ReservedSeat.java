package com.cinema.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "reserved_seats", uniqueConstraints = @UniqueConstraint(columnNames = {"showtime_id", "seat_label"}))
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ReservedSeat {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "showtime_id", nullable = false)
    private Long showtimeId;

    @Column(name = "booking_id", nullable = false)
    private Long bookingId;

    @Column(name = "seat_label", nullable = false, length = 10)
    private String seatLabel;
}
