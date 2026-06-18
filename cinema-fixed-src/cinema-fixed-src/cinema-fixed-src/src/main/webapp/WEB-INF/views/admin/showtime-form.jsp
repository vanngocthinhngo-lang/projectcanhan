<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Form suất chiếu - Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body{background:#0f0f0f;color:#fff;}
        .sidebar{background:#1a1a1a;min-height:100vh;padding:20px 0;width:220px;position:fixed;top:0;left:0;}
        .sidebar a{color:#aaa;display:block;padding:10px 20px;text-decoration:none;border-radius:6px;margin:2px 10px;}
        .sidebar a:hover,.sidebar a.active{background:#f5c518;color:#000;font-weight:bold;}
        .sidebar .brand{color:#f5c518;font-weight:bold;font-size:1.2rem;padding:10px 20px 20px;}
        .main{margin-left:220px;padding:30px;}
        .form-card{background:#1f1f1f;border-radius:12px;padding:30px;max-width:600px;}
        .form-control,.form-select{background:#2a2a2a;border-color:#444;color:#fff;}
        .form-control:focus,.form-select:focus{background:#2a2a2a;color:#fff;border-color:#f5c518;}
        label{color:#ccc;}
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
</div>
<div class="main">
    <h4 class="section-title mb-4">${empty showtime.id ? '➕ Thêm suất chiếu' : '✏️ Sửa suất chiếu'}</h4>
    <div class="form-card">
        <form action="/admin/showtimes/save" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <input type="hidden" name="id" value="${showtime.id}"/>
            <div class="row g-3">
                <div class="col-12">
                    <label>Phim *</label>
                    <select name="film.id" class="form-select" required>
                        <option value="">-- Chọn phim --</option>
                        <c:forEach var="f" items="${films}">
                            <option value="${f.id}" <c:if test="${showtime.film != null and showtime.film.id == f.id}">selected</c:if>>${f.title}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-12">
                    <label>Phòng chiếu *</label>
                    <select name="room.id" class="form-select" required>
                        <option value="">-- Chọn phòng --</option>
                        <c:forEach var="r" items="${rooms}">
                            <option value="${r.id}" <c:if test="${showtime.room != null and showtime.room.id == r.id}">selected</c:if>>${r.name} (${r.roomType} - ${r.capacity} ghế)</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-6">
                    <label>Giờ bắt đầu *</label>
                    <input type="datetime-local" name="startTime" class="form-control" value="${showtime.startTime}" required>
                </div>
                <div class="col-md-6">
                    <label>Giờ kết thúc *</label>
                    <input type="datetime-local" name="endTime" class="form-control" value="${showtime.endTime}" required>
                </div>
                <div class="col-md-6">
                    <label>Giá vé (VNĐ) *</label>
                    <input type="number" name="price" class="form-control" value="${showtime.price}" step="1000" required>
                </div>
            </div>
            <div class="d-flex gap-2 mt-4">
                <button type="submit" class="btn px-4" style="background:#f5c518;color:#000;font-weight:bold;">💾 Lưu</button>
                <a href="/admin/showtimes" class="btn btn-outline-secondary">Hủy</a>
            </div>
        </form>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
