<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Admin CinemaHub</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { background: #0f0f0f; color: #fff; }
        .sidebar { background: #1a1a1a; min-height: 100vh; padding: 20px 0; width: 220px; position: fixed; top:0; left:0; }
        .sidebar a { color: #aaa; display: block; padding: 10px 20px; text-decoration: none; border-radius: 6px; margin: 2px 10px; }
        .sidebar a:hover, .sidebar a.active { background: #f5c518; color: #000; font-weight: bold; }
        .sidebar .brand { color: #f5c518; font-weight: bold; font-size: 1.2rem; padding: 10px 20px 20px; }
        .main { margin-left: 220px; padding: 30px; }
        .stat-card { background: #1f1f1f; border-radius: 12px; padding: 20px; border-left: 4px solid; }
        .section-title { color: #f5c518; font-weight: bold; border-left: 4px solid #f5c518; padding-left: 10px; }
    </style>
</head>
<body>
<div class="sidebar">
    <div class="brand">🎬 CinemaHub</div>
    <a href="/admin/dashboard" class="active">📊 Dashboard</a>
    <a href="/admin/films">🎬 Quản lý phim</a>
    <a href="/admin/showtimes">🕐 Suất chiếu</a>
    <a href="/admin/bookings">🎟 Đặt vé</a>
    <a href="/admin/users">👥 Người dùng</a>
    <hr style="border-color:#333;margin:10px 20px;">
    <a href="/films">🏠 Về trang chủ</a>
    <form action="/logout" method="post" style="margin:2px 10px;">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        <button style="background:none;border:none;color:#aaa;padding:10px;cursor:pointer;width:100%;text-align:left;">🚪 Đăng xuất</button>
    </form>
</div>
<div class="main">
    <h4 class="mb-4">📊 Dashboard Tổng quan</h4>
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="stat-card" style="border-color:#f5c518;">
                <div class="fw-bold text-warning" style="font-size:2rem;">${totalFilms}</div>
                <div style="color:#888;">Tổng phim</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card" style="border-color:#28a745;">
                <div class="fw-bold" style="font-size:2rem;color:#28a745;">${totalBookings}</div>
                <div style="color:#888;">Tổng vé đã bán</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card" style="border-color:#007bff;">
                <div class="fw-bold" style="font-size:2rem;color:#007bff;">${totalUsers}</div>
                <div style="color:#888;">Người dùng</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card" style="border-color:#dc3545;">
                <div class="fw-bold" style="font-size:1.4rem;color:#dc3545;">
                    ${totalRevenue}
                </div>
                <div style="color:#888;">Doanh thu (VNĐ)</div>
            </div>
        </div>
    </div>
    <h5 class="section-title mb-3">Đặt vé gần đây</h5>
    <div class="table-responsive">
        <table class="table table-dark table-hover">
            <thead><tr><th>#</th><th>Khách hàng</th><th>Phim</th><th>Ghế</th><th>Tổng tiền</th><th>Trạng thái</th></tr></thead>
            <tbody>
                <c:forEach var="b" items="${recentBookings}" varStatus="vs" end="9">
                <tr>
                    <td>${b.id}</td>
                    <td>${b.user.fullName}</td>
                    <td>${b.showtime.film.title}</td>
                    <td><c:forEach var="s" items="${b.seats}" varStatus="ss">${s}<c:if test="${!ss.last}">, </c:if></c:forEach></td>
                    <td class="text-warning">${b.totalPrice} đ</td>
                    <td><span class="badge ${b.status == 'CONFIRMED' ? 'bg-success' : b.status == 'CANCELLED' ? 'bg-danger' : 'bg-warning text-dark'}">${b.status}</span></td>
                </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
    <a href="/admin/bookings" class="btn btn-outline-warning btn-sm">Xem tất cả →</a>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
