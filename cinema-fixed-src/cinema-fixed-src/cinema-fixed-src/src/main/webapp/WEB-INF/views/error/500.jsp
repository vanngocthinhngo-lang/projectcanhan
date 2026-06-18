<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lỗi - CinemaHub</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>body{background:#141414;color:#fff;}</style>
</head>
<body>
<div class="container mt-5 text-center">
    <h1 style="font-size:5rem;color:#f5c518;">⚠️</h1>
    <h2 class="text-warning">Đã xảy ra lỗi</h2>
    <p class="text-muted mt-3">${not empty errorMessage ? errorMessage : 'Lỗi máy chủ nội bộ. Vui lòng thử lại.'}</p>
    <c:if test="${not empty status}"><p class="text-muted small">Mã lỗi: ${status}</p></c:if>
    <a href="/films" class="btn btn-warning mt-4">🏠 Về trang chủ</a>
</div>
</body>
</html>
