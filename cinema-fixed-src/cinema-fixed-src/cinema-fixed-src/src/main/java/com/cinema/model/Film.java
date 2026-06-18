package com.cinema.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;
import org.springframework.format.annotation.DateTimeFormat;
import java.util.List;

@Entity
@Table(name = "films")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Film {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 200)
    private String title;

    @Column(length = 50)
    private String genre;

    @Column(nullable = false)
    private int duration; // phút

    @Column(length = 100)
    private String director;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(length = 500)
    private String poster;

    @Column(name = "release_date")
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    private LocalDate releaseDate;

    @Column(length = 20)
    private String status; // SHOWING, UPCOMING, ENDED

    @OneToMany(mappedBy = "film", cascade = CascadeType.ALL)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private List<Showtime> showtimes;
}
