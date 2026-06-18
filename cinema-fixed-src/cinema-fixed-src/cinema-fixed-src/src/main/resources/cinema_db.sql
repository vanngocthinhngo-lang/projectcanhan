-- ============================================================
--  CINEMA MANAGEMENT - MS SQL SERVER SCRIPT
--  Chay script nay truoc khi khoi dong Spring Boot
-- ============================================================

-- Tao database
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'CinemaDB')
BEGIN
    CREATE DATABASE CinemaDB;
END
GO

USE CinemaDB;
GO

-- ============================================================
-- BANG USERS
-- ============================================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='users' AND xtype='U')
CREATE TABLE users (
    id          BIGINT IDENTITY(1,1) PRIMARY KEY,
    full_name   NVARCHAR(100) NOT NULL,
    email       NVARCHAR(100) NOT NULL UNIQUE,
    password    NVARCHAR(255) NOT NULL,
    phone       NVARCHAR(15),
    role        NVARCHAR(20) DEFAULT 'ROLE_USER',
    created_at  DATETIME DEFAULT GETDATE()
);
GO

-- ============================================================
-- BANG FILMS
-- ============================================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='films' AND xtype='U')
CREATE TABLE films (
    id           BIGINT IDENTITY(1,1) PRIMARY KEY,
    title        NVARCHAR(200) NOT NULL,
    genre        NVARCHAR(50),
    duration     INT NOT NULL,
    director     NVARCHAR(100),
    description  NVARCHAR(MAX),
    poster       NVARCHAR(500),
    release_date DATE,
    status       NVARCHAR(20) DEFAULT 'SHOWING'  -- SHOWING, UPCOMING, ENDED
);
GO

-- ============================================================
-- BANG ROOMS (phong chieu)
-- ============================================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='rooms' AND xtype='U')
CREATE TABLE rooms (
    id         BIGINT IDENTITY(1,1) PRIMARY KEY,
    name       NVARCHAR(50) NOT NULL,
    capacity   INT NOT NULL,
    room_type  NVARCHAR(20) DEFAULT '2D'  -- 2D, 3D, IMAX
);
GO

-- ============================================================
-- BANG SEATS (ghe ngoi)
-- ============================================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='seats' AND xtype='U')
CREATE TABLE seats (
    id        BIGINT IDENTITY(1,1) PRIMARY KEY,
    room_id   BIGINT NOT NULL REFERENCES rooms(id),
    row_label NVARCHAR(5) NOT NULL,   -- A, B, C...
    col_num   INT NOT NULL,           -- 1, 2, 3...
    seat_type NVARCHAR(20) DEFAULT 'NORMAL'  -- NORMAL, VIP
);
GO

-- ============================================================
-- BANG SHOWTIMES (suat chieu)
-- ============================================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='showtimes' AND xtype='U')
CREATE TABLE showtimes (
    id         BIGINT IDENTITY(1,1) PRIMARY KEY,
    film_id    BIGINT NOT NULL REFERENCES films(id),
    room_id    BIGINT NOT NULL REFERENCES rooms(id),
    start_time DATETIME NOT NULL,
    end_time   DATETIME NOT NULL,
    price      DECIMAL(10,2) NOT NULL
);
GO

-- ============================================================
-- BANG BOOKINGS (dat ve)
-- ============================================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='bookings' AND xtype='U')
CREATE TABLE bookings (
    id           BIGINT IDENTITY(1,1) PRIMARY KEY,
    user_id      BIGINT NOT NULL REFERENCES users(id),
    showtime_id  BIGINT NOT NULL REFERENCES showtimes(id),
    total_price  DECIMAL(10,2) NOT NULL,
    booking_time DATETIME DEFAULT GETDATE(),
    status       NVARCHAR(20) DEFAULT 'CONFIRMED'  -- PENDING, CONFIRMED, CANCELLED
);
GO

-- ============================================================
-- BANG BOOKING_SEATS (chi tiet ghe trong booking)
-- ============================================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='booking_seats' AND xtype='U')
CREATE TABLE booking_seats (
    id         BIGINT IDENTITY(1,1) PRIMARY KEY,
    booking_id BIGINT NOT NULL REFERENCES bookings(id),
    seat_label NVARCHAR(10) NOT NULL  -- vd: A1, B3
);
GO

-- ============================================================
-- BANG RESERVED_SEATS (danh dau ghe da duoc dat tam thoi/chan)
-- Su dung unique constraint de tranh double-booking o cap DB
-- ============================================================
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='reserved_seats' AND xtype='U')
CREATE TABLE reserved_seats (
    id          BIGINT IDENTITY(1,1) PRIMARY KEY,
    showtime_id BIGINT NOT NULL REFERENCES showtimes(id),
    booking_id  BIGINT NOT NULL REFERENCES bookings(id),
    seat_label  NVARCHAR(10) NOT NULL,
    CONSTRAINT UQ_reserved_showtime_seat UNIQUE (showtime_id, seat_label)
);
GO

-- ============================================================
-- DU LIEU MAU
-- ============================================================

-- Admin account (password: admin123 - BCrypt)
INSERT INTO users (full_name, email, password, phone, role)
VALUES (N'Quản trị viên', 'admin@cinema.com',
        '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
        '0900000001', 'ROLE_ADMIN');

-- User thuong (password: user123 - BCrypt)
INSERT INTO users (full_name, email, password, phone, role)
VALUES (N'Nguyễn Văn A', 'user@cinema.com',
        '$2a$10$8K1p/a0dhrx/07wV4XpFD.7WGbZS.8Sx7ZxIr1BvIxqe6N0JLGFC',
        '0900000002', 'ROLE_USER');

-- Phim mau
INSERT INTO films (title, genre, duration, director, description, poster, release_date, status)
VALUES
(N'Avengers: Endgame', N'Hành động', 181, N'Anthony Russo',
 N'Sau sự kiện Infinity War, các Avengers tập hợp lại để đánh bại Thanos.',
 'https://via.placeholder.com/300x450?text=Avengers', '2024-01-15', 'SHOWING'),

(N'Inception', N'Khoa học viễn tưởng', 148, N'Christopher Nolan',
 N'Một tên trộm xâm nhập vào giấc mơ của người khác để đánh cắp bí mật.',
 'https://via.placeholder.com/300x450?text=Inception', '2024-02-01', 'SHOWING'),

(N'The Dark Knight', N'Hành động', 152, N'Christopher Nolan',
 N'Batman đối mặt với kẻ phản diện nguy hiểm nhất - The Joker.',
 'https://via.placeholder.com/300x450?text=DarkKnight', '2024-03-10', 'UPCOMING');

-- Phong chieu mau
INSERT INTO rooms (name, capacity, room_type) VALUES (N'Phòng 1', 50, '2D');
INSERT INTO rooms (name, capacity, room_type) VALUES (N'Phòng 2', 60, '3D');
INSERT INTO rooms (name, capacity, room_type) VALUES (N'Phòng VIP', 30, 'IMAX');

-- Suat chieu mau
INSERT INTO showtimes (film_id, room_id, start_time, end_time, price)
VALUES
(1, 1, '2025-01-20 10:00:00', '2025-01-20 13:01:00', 75000),
(1, 2, '2025-01-20 14:00:00', '2025-01-20 17:01:00', 90000),
(2, 1, '2025-01-20 10:30:00', '2025-01-20 13:00:00', 75000),
(2, 3, '2025-01-20 19:00:00', '2025-01-20 21:28:00', 120000);
GO

PRINT 'CinemaDB initialized successfully!';
GO
