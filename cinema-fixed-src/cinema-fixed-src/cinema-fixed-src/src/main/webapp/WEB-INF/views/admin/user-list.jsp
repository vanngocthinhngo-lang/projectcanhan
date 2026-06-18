<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Quản lý người dùng - Admin</title>
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
    <a href="/admin/bookings">🎟 Đặt vé</a>
    <a href="/admin/users" class="active">👥 Người dùng</a>
    <hr style="border-color:#333;margin:10px 20px;">
    <a href="/films">🏠 Về trang chủ</a>
</div>
<div class="main">
    <h4 class="section-title mb-4">👥 Danh sách người dùng</h4>
    <c:if test="${not empty success}"><div class="alert alert-success">${success}</div></c:if>
    <div class="table-responsive">
        <table class="table table-dark table-hover">
            <thead><tr><th>ID</th><th>Họ tên</th><th>Email</th><th>Điện thoại</th><th>Vai trò</th><th>Ngày tạo</th><th>Thao tác</th></tr></thead>
            <tbody>
            <c:forEach var="u" items="${users}">
                <tr>
                    <td>${u.id}</td>
                    <td class="fw-bold">${u.fullName}</td>
                    <td>${u.email}</td>
                    <td>${u.phone}</td>
                    <td><span class="badge ${u.role == 'ROLE_ADMIN' ? 'bg-danger' : 'bg-primary'}">${u.role == 'ROLE_ADMIN' ? 'Admin' : 'User'}</span></td>
                    <td class="text-muted small">${u.createdAt.dayOfMonth}/${u.createdAt.monthValue}/${u.createdAt.year}</td>
                    <td>
                        <c:if test="${u.role != 'ROLE_ADMIN'}">
                            <a href="/admin/users/delete/${u.id}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Xóa người dùng này?')">Xóa</a>
                        </c:if>
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
