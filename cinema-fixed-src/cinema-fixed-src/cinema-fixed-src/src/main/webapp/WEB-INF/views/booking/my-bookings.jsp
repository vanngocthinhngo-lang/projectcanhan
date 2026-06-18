<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Vé của tôi - CinemaHub</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { background: #141414; color: #fff; }
        .booking-card { background: #1f1f1f; border-radius: 10px; padding: 20px; margin-bottom: 16px; border-left: 4px solid #f5c518; }
        .section-title { color: #f5c518; font-weight: bold; border-left: 4px solid #f5c518; padding-left: 12px; }
    </style>
</head>
<body>
<jsp:include page="../layout/header.jsp"/>
<div class="container mt-4">
    <h4 class="section-title mb-4">🎟 Vé của tôi</h4>
    <c:if test="${not empty success}"><div class="alert alert-success">${success}</div></c:if>
    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

    <c:if test="${empty bookings}">
        <div class="text-center py-5 text-muted">
            <h5>Bạn chưa đặt vé nào</h5>
            <a href="/films" class="btn btn-warning mt-3">Xem phim ngay</a>
        </div>
    </c:if>

    <c:forEach var="b" items="${bookings}">
        <div class="booking-card">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h5 class="fw-bold mb-1">${b.showtime.film.title}</h5>
                    <div class="text-muted small mb-1">
                        🕐 ${b.showtime.startTime.hour}:<c:choose><c:when test="${b.showtime.startTime.minute < 10}">0${b.showtime.startTime.minute}</c:when><c:otherwise>${b.showtime.startTime.minute}</c:otherwise></c:choose>
                        - ${b.showtime.startTime.dayOfMonth}/${b.showtime.startTime.monthValue}/${b.showtime.startTime.year}
                        &nbsp;|&nbsp; 🏛 ${b.showtime.room.name}
                    </div>
                    <div class="small mb-1">🪑 Ghế:
                        <c:forEach var="seat" items="${b.seats}">
                            <span class="badge bg-dark border border-warning text-warning">${seat}</span>
                        </c:forEach>
                    </div>
                    <div class="small text-muted">Đặt lúc: ${b.bookingTime.hour}:<c:choose><c:when test="${b.bookingTime.minute < 10}">0${b.bookingTime.minute}</c:when><c:otherwise>${b.bookingTime.minute}</c:otherwise></c:choose> ${b.bookingTime.dayOfMonth}/${b.bookingTime.monthValue}/${b.bookingTime.year}</div>
                </div>
                <div class="col-md-4 text-md-end mt-3 mt-md-0">
                    <div class="fs-5 fw-bold text-warning mb-2">${b.totalPrice} VNĐ</div>
                    <span class="badge ${b.status == 'CONFIRMED' ? 'bg-success' : b.status == 'CANCELLED' ? 'bg-danger' : 'bg-warning text-dark'}">${b.status}</span>
                    <c:if test="${b.status == 'CONFIRMED'}">
                        <form action="/booking/cancel/${b.id}" method="post" class="d-inline ms-2"
                              onsubmit="return confirm('Bạn có chắc muốn hủy vé?')">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <button class="btn btn-sm btn-outline-danger">Hủy vé</button>
                        </form>
                    </c:if>
                </div>
            </div>
        </div>
    </c:forEach>
</div>
<jsp:include page="../layout/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
