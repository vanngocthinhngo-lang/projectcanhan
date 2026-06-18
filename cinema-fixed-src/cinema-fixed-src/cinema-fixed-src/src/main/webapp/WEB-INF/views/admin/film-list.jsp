<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Quản lý phim - Admin</title>
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
    <a href="/admin/films" class="active">🎬 Quản lý phim</a>
    <a href="/admin/showtimes">🕐 Suất chiếu</a>
    <a href="/admin/bookings">🎟 Đặt vé</a>
    <a href="/admin/users">👥 Người dùng</a>
    <hr style="border-color:#333;margin:10px 20px;">
    <a href="/films">🏠 Về trang chủ</a>
</div>
<div class="main">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="section-title">🎬 Danh sách phim</h4>
        <a href="/admin/films/add" class="btn" style="background:#f5c518;color:#000;font-weight:bold;">+ Thêm phim</a>
    </div>
    <c:if test="${not empty success}"><div class="alert alert-success">${success}</div></c:if>
    <div class="table-responsive">
        <table class="table table-dark table-hover">
            <thead><tr><th>ID</th><th>Poster</th><th>Tên phim</th><th>Thể loại</th><th>Thời lượng</th><th>Trạng thái</th><th>Thao tác</th></tr></thead>
            <tbody>
            <c:forEach var="film" items="${films}">
                <tr>
                    <td>${film.id}</td>
                    <td><img src="${not empty film.poster ? film.poster : 'https://via.placeholder.com/50x70?text=N/A'}" width="40" height="55" style="object-fit:cover;border-radius:4px;"></td>
                    <td class="fw-bold">${film.title}</td>
                    <td><span class="badge bg-secondary">${film.genre}</span></td>
                    <td>${film.duration} phút</td>
                    <td><span class="badge ${film.status == 'SHOWING' ? 'bg-success' : film.status == 'UPCOMING' ? 'bg-warning text-dark' : 'bg-secondary'}">${film.status}</span></td>
                    <td>
                        <a href="/admin/films/edit/${film.id}" class="btn btn-sm btn-outline-warning">Sửa</a>
                        <a href="/admin/films/delete/${film.id}" class="btn btn-sm btn-outline-danger ms-1" onclick="return confirm('Xóa phim này?')">Xóa</a>
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
