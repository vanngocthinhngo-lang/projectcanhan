<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký - CinemaHub</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { background: #141414; min-height: 100vh; display: flex; align-items: center; }
        .register-box { background: #1f1f1f; border-radius: 12px; padding: 40px; max-width: 460px; width: 100%; }
        .brand { color: #f5c518; font-size: 2rem; font-weight: bold; }
        .form-control { background: #2a2a2a; border-color: #444; color: #fff; }
        .form-control:focus { background: #2a2a2a; color: #fff; border-color: #f5c518; box-shadow: 0 0 0 .2rem rgba(245,197,24,.25); }
        .btn-register { background: #f5c518; color: #000; font-weight: bold; border: none; }
        label { color: #ccc; }
    </style>
</head>
<body>
<div class="container d-flex justify-content-center">
    <div class="register-box mt-5">
        <div class="text-center mb-4">
            <div class="brand">🎬 CinemaHub</div>
            <p class="text-muted mt-1">Tạo tài khoản mới</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <form action="/register" method="post">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <div class="mb-3">
                <label>Họ và tên</label>
                <input type="text" name="fullName" class="form-control" placeholder="Nguyễn Văn A" required>
            </div>
            <div class="mb-3">
                <label>Email</label>
                <input type="email" name="email" class="form-control" placeholder="example@email.com" required>
            </div>
            <div class="mb-3">
                <label>Số điện thoại</label>
                <input type="tel" name="phone" class="form-control" placeholder="09xxxxxxxx">
            </div>
            <div class="mb-3">
                <label>Mật khẩu</label>
                <input type="password" name="password" class="form-control" placeholder="Tối thiểu 6 ký tự" required>
            </div>
            <button type="submit" class="btn btn-register w-100 py-2">Đăng ký</button>
        </form>

        <div class="text-center mt-3">
            <span class="text-muted">Đã có tài khoản?</span>
            <a href="/login" class="text-warning ms-1">Đăng nhập</a>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
