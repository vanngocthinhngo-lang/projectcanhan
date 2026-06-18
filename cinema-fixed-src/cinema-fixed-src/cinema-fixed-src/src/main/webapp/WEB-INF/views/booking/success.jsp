<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đặt vé thành công - CinemaHub</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { background: #141414; color: #fff; }
        .ticket { background: #1f1f1f; border-radius: 16px; max-width: 500px; margin: 0 auto; overflow: hidden; }
        .ticket-header { background: #f5c518; color: #000; padding: 20px; text-align: center; }
        .ticket-body { padding: 30px; }
        .ticket-row { display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #333; }
        .ticket-row:last-child { border-bottom: none; }
        .btn-gold { background: #f5c518; color: #000; font-weight: bold; border: none; }
    </style>
</head>
<body>
<jsp:include page="../layout/header.jsp"/>
<div class="container mt-5">
    <div class="text-center mb-4">
        <div style="font-size:4rem;">✅</div>
        <h3 class="fw-bold text-warning">Đặt vé thành công!</h3>
        <p class="text-muted">Mã booking: <strong class="text-white">#${booking.id}</strong></p>
    </div>
    <div class="ticket">
        <div class="ticket-header">
            <h5 class="mb-0">🎬 ${booking.showtime.film.title}</h5>
        </div>
        <div class="ticket-body">
            <div class="ticket-row">
                <span style="color:#888;">Suất chiếu</span>
                <span class="fw-bold">
                    ${booking.showtime.startTime.hour}:<c:choose><c:when test="${booking.showtime.startTime.minute < 10}">0${booking.showtime.startTime.minute}</c:when><c:otherwise>${booking.showtime.startTime.minute}</c:otherwise></c:choose>
                    - ${booking.showtime.startTime.dayOfMonth}/${booking.showtime.startTime.monthValue}/${booking.showtime.startTime.year}
                </span>
            </div>
            <div class="ticket-row">
                <span style="color:#888;">Phòng chiếu</span>
                <span class="fw-bold">${booking.showtime.room.name}</span>
            </div>
            <div class="ticket-row">
                <span style="color:#888;">Ghế</span>
                <span class="fw-bold text-warning">
                    <c:forEach var="seat" items="${booking.seats}" varStatus="s">
                        ${seat}<c:if test="${!s.last}">, </c:if>
                    </c:forEach>
                </span>
            </div>
            <div class="ticket-row">
                <span style="color:#888;">Số ghế</span>
                <span class="fw-bold">${booking.seats.size()} ghế</span>
            </div>
            <div class="ticket-row">
                <span style="color:#888;">Tổng tiền</span>
                <span class="fw-bold text-warning fs-5">${booking.totalPrice} VNĐ</span>
            </div>
            <div class="ticket-row">
                <span style="color:#888;">Trạng thái</span>
                <span class="badge bg-success">${booking.status}</span>
            </div>
        </div>
    </div>
    <div class="text-center mt-4 d-flex gap-3 justify-content-center">
        <a href="/my-bookings" class="btn btn-outline-warning">Xem lịch sử vé</a>
        <a href="/films" class="btn btn-gold">Về trang chủ</a>
    </div>
</div>
<jsp:include page="../layout/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
