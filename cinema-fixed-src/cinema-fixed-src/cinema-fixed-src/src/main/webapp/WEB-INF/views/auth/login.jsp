<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập - CinemaHub</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { background: #141414; min-height: 100vh; display: flex; align-items: center; }
        .login-box { background: #1f1f1f; border-radius: 12px; padding: 40px; max-width: 420px; width: 100%; }
        .brand { color: #f5c518; font-size: 2rem; font-weight: bold; }
        .form-control { background: #2a2a2a; border-color: #444; color: #fff; }
        .form-control:focus { background: #2a2a2a; color: #fff; border-color: #f5c518; box-shadow: 0 0 0 .2rem rgba(245,197,24,.25); }
        .btn-login { background: #f5c518; color: #000; font-weight: bold; border: none; }
        label { color: #ccc; }
    </style>
</head>
<body>
<div class="container d-flex justify-content-center">
    <div class="login-box mt-5">
        <div class="text-center mb-4">
            <div class="brand">&#127916; CinemaHub</div>
            <p class="text-muted mt-1">Đăng nhập để đặt vé</p>
        </div>

        <% if ("true".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger">Email hoặc mật khẩu không đúng!</div>
        <% } %>
        <% if ("true".equals(request.getParameter("logout"))) { %>
            <div class="alert alert-success">Đăng xuất thành công!</div>
        <% } %>

        <form action="/login" method="post">
            <input type="hidden" name="_csrf" value="${_csrf.token}"/>
            <div class="mb-3">
                <label>Email</label>
                <input type="email" name="email" class="form-control" placeholder="example@email.com" required autofocus>
            </div>
            <div class="mb-3">
                <label>Mật khẩu</label>
                <input type="password" name="password" class="form-control" placeholder="&#9679;&#9679;&#9679;&#9679;&#9679;&#9679;&#9679;&#9679;" required>
            </div>
            <button type="submit" class="btn btn-login w-100 py-2">Đăng nhập</button>
        </form>

        <div class="text-center mt-3">
            <span class="text-muted">Chưa có tài khoản?</span>
            <a href="/register" class="text-warning ms-1">Đăng ký ngay</a>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
