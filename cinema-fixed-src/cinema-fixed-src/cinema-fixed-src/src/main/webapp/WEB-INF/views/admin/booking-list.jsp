<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Quản lý đặt vé - Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body{background:#0f0f0f;color:#fff;}
        .sidebar{background:#1a1a1a;min-height:100vh;padding:20px 0;width:220px;position:fixed;top:0;left:0;}
        .sidebar a{color:#aaa;display:block;padding:10px 20px;text-decoration:none;border-radius:6px;margin:2px 10px;}
        .sidebar a:hover,.sidebar a.active{background:#f5c518;color:#000;font-weight:bold;}
        .sidebar .brand{color:#f5c518;font-weight:bold;font-size:1.2rem;padding:10px 20px 20px;}
        .main{margin-left:220px;padding:30px;}
        .section-title{color:#f5c518;font-weight:bold;border-left:4px solid #f5c518;padding-left:10px;}
    </style>
</head>
<body>
<div class="sidebar">
    <div class="brand">🎬 CinemaHub</div>
    <a href="/admin/dashboard">📊 Dashboard</a>
    <a href="/admin/films">🎬 Quản lý phim</a>
    <a href="/admin/showtimes">🕐 Suất chiếu</a>
    <a href="/admin/bookings" class="active">🎟 Đặt vé</a>
    <a href="/admin/users">👥 Người dùng</a>
    <hr style="border-color:#333;margin:10px 20px;">
    <a href="/films">🏠 Về trang chủ</a>
</div>
<div class="main">
    <h4 class="section-title mb-4">🎟 Danh sách đặt vé</h4>
    <div class="table-responsive">
        <table class="table table-dark table-hover">
            <thead><tr><th>ID</th><th>Khách hàng</th><th>Phim</th><th>Suất chiếu</th><th>Ghế</th><th>Tổng tiền</th><th>Trạng thái</th></tr></thead>
            <tbody>
            <c:forEach var="b" items="${bookings}">
                <tr>
                    <td>#${b.id}</td>
                    <td>${b.user.fullName}<br><small class="text-muted">${b.user.email}</small></td>
                    <td>${b.showtime.film.title}</td>
                    <td class="small">${b.showtime.startTime.hour}:${b.showtime.startTime.minute < 10 ? "0" : ""}${b.showtime.startTime.minute} ${b.showtime.startTime.dayOfMonth}/${b.showtime.startTime.monthValue}/${b.showtime.startTime.year}</td>
                    <td><c:forEach var="s" items="${b.seats}"><span class="badge bg-dark border border-warning text-warning me-1">${s}</span></c:forEach></td>
                    <td class="text-warning fw-bold">${b.totalPrice} đ</td>
                    <td><span class="badge ${b.status == 'CONFIRMED' ? 'bg-success' : b.status == 'CANCELLED' ? 'bg-danger' : 'bg-warning text-dark'}">${b.status}</span></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
