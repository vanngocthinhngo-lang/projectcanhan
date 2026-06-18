<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><title>Form phim - Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body{background:#0f0f0f;color:#fff;}
        .sidebar{background:#1a1a1a;min-height:100vh;padding:20px 0;width:220px;position:fixed;top:0;left:0;}
        .sidebar a{color:#aaa;display:block;padding:10px 20px;text-decoration:none;border-radius:6px;margin:2px 10px;}
        .sidebar a:hover,.sidebar a.active{background:#f5c518;color:#000;font-weight:bold;}
        .sidebar .brand{color:#f5c518;font-weight:bold;font-size:1.2rem;padding:10px 20px 20px;}
        .main{margin-left:220px;padding:30px;}
        .form-card{background:#1f1f1f;border-radius:12px;padding:30px;max-width:700px;}
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
    <a href="/admin/films" class="active">🎬 Quản lý phim</a>
    <a href="/admin/showtimes">🕐 Suất chiếu</a>
    <a href="/admin/bookings">🎟 Đặt vé</a>
    <a href="/admin/users">👥 Người dùng</a>
</div>
<div class="main">
    <h4 class="section-title mb-4">${empty film.id ? '➕ Thêm phim mới' : '✏️ Sửa phim'}</h4>
    <div class="form-card">
        <form action="/admin/films/save" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <input type="hidden" name="id" value="${film.id}"/>
            <div class="row g-3">
                <div class="col-md-8">
                    <label>Tên phim *</label>
                    <input type="text" name="title" class="form-control" value="${film.title}" required>
                </div>
                <div class="col-md-4">
                    <label>Thể loại</label>
                    <select name="genre" class="form-select">
                            <option value="Hành động" <c:if test="${'Hành động' == film.genre}">selected</c:if>>Hành động</option>
                        <option value="Tình cảm" <c:if test="${'Tình cảm' == film.genre}">selected</c:if>>Tình cảm</option>
                        <option value="Hài hước" <c:if test="${'Hài hước' == film.genre}">selected</c:if>>Hài hước</option>
                        <option value="Kinh dị" <c:if test="${'Kinh dị' == film.genre}">selected</c:if>>Kinh dị</option>
                        <option value="Khoa học viễn tưởng" <c:if test="${'Khoa học viễn tưởng' == film.genre}">selected</c:if>>Khoa học viễn tưởng</option>
                        <option value="Hoạt hình" <c:if test="${'Hoạt hình' == film.genre}">selected</c:if>>Hoạt hình</option>
                        <option value="Tâm lý" <c:if test="${'Tâm lý' == film.genre}">selected</c:if>>Tâm lý</option>
                        <option value="Siêu anh hùng" <c:if test="${'Siêu anh hùng' == film.genre}">selected</c:if>>Siêu anh hùng</option>
                        <option value="Phiêu lưu" <c:if test="${'Phiêu lưu' == film.genre}">selected</c:if>>Phiêu lưu</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <label>Thời lượng (phút) *</label>
                    <input type="number" name="duration" class="form-control" value="${film.duration}" required>
                </div>
                <div class="col-md-4">
                    <label>Đạo diễn</label>
                    <input type="text" name="director" class="form-control" value="${film.director}">
                </div>
                <div class="col-md-4">
                    <label>Ngày ra mắt</label>
                    <input type="date" name="releaseDate" class="form-control" value="${film.releaseDate}">
                </div>
                <div class="col-12">
                    <label>URL Poster</label>
                    <input type="text" name="poster" class="form-control" value="${film.poster}" placeholder="https://...">
                </div>
                <div class="col-md-4">
                    <label>Trạng thái</label>
                    <select name="status" class="form-select">
                        <option value="SHOWING" <c:if test="${film.status == 'SHOWING'}">selected</c:if>>Đang chiếu</option>
                        <option value="UPCOMING" <c:if test="${film.status == 'UPCOMING'}">selected</c:if>>Sắp chiếu</option>
                        <option value="ENDED" <c:if test="${film.status == 'ENDED'}">selected</c:if>>Đã kết thúc</option>
                    </select>
                </div>
                <div class="col-12">
                    <label>Mô tả</label>
                    <textarea name="description" class="form-control" rows="4">${film.description}</textarea>
                </div>
            </div>
            <div class="d-flex gap-2 mt-4">
                <button type="submit" class="btn px-4" style="background:#f5c518;color:#000;font-weight:bold;">💾 Lưu phim</button>
                <a href="/admin/films" class="btn btn-outline-secondary">Hủy</a>
            </div>
        </form>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
