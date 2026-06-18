<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Quản lý suất chiếu - Admin</title>
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
    <a href="/admin/showtimes" class="active">🕐 Suất chiếu</a>
    <a href="/admin/bookings">🎟 Đặt vé</a>
    <a href="/admin/users">👥 Người dùng</a>
    <hr style="border-color:#333;margin:10px 20px;">
    <a href="/films">🏠 Về trang chủ</a>
</div>
<div class="main">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="section-title">🕐 Danh sách suất chiếu</h4>
        <a href="/admin/showtimes/add" class="btn" style="background:#f5c518;color:#000;font-weight:bold;">+ Thêm suất chiếu</a>
    </div>
    <c:if test="${not empty success}"><div class="alert alert-success">${success}</div></c:if>
    <div class="table-responsive">
        <table class="table table-dark table-hover">
            <thead><tr><th>ID</th><th>Phim</th><th>Phòng</th><th>Giờ bắt đầu</th><th>Giờ kết thúc</th><th>Giá vé</th><th>Thao tác</th></tr></thead>
            <tbody>
            <c:forEach var="st" items="${showtimes}">
                <tr>
                    <td>${st.id}</td>
                    <td class="fw-bold">${st.film.title}</td>
                    <td>${st.room.name} <span class="badge bg-secondary">${st.room.roomType}</span></td>
                    <td>${st.startTime.hour}:${st.startTime.minute < 10 ? "0" : ""}${st.startTime.minute} ${st.startTime.dayOfMonth}/${st.startTime.monthValue}/${st.startTime.year}</td>
                    <td>${st.endTime.hour}:${st.endTime.minute < 10 ? "0" : ""}${st.endTime.minute} ${st.endTime.dayOfMonth}/${st.endTime.monthValue}/${st.endTime.year}</td>
                    <td class="text-warning fw-bold">${st.price} đ</td>
                    <td>
                        <a href="/admin/showtimes/edit/${st.id}" class="btn btn-sm btn-outline-warning">Sửa</a>
                        <a href="/admin/showtimes/delete/${st.id}" class="btn btn-sm btn-outline-danger ms-1" onclick="return confirm('Xóa suất chiếu này?')">Xóa</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
