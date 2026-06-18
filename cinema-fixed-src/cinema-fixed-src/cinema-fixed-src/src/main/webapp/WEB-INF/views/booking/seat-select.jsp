<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chọn ghế - CinemaHub</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { background: #141414; color: #fff; }
        .screen { background: linear-gradient(to bottom, #f5c518, #b8960a); height: 10px; border-radius: 50%; margin: 0 auto 30px; width: 80%; box-shadow: 0 0 20px rgba(245,197,24,.5); }
        .screen-label { text-align: center; color: #aaa; font-size: .8rem; margin-bottom: 10px; }
        .seat-grid { display: flex; flex-direction: column; gap: 8px; align-items: center; }
        .seat-row { display: flex; gap: 6px; align-items: center; }
        .row-label { width: 24px; text-align: center; color: #888; font-size: .85rem; }
        .seat { width: 36px; height: 36px; border-radius: 6px 6px 2px 2px; display: flex; align-items: center; justify-content: center; font-size: .7rem; cursor: pointer; transition: all .15s; border: 2px solid transparent; }
        .seat.available { background: #2a2a2a; border-color: #555; color: #ccc; }
        .seat.available:hover { background: #f5c518; color: #000; border-color: #f5c518; }
        .seat.booked { background: #555; color: #888; cursor: not-allowed; border-color: #555; }
        .seat.selected { background: #f5c518; color: #000; border-color: #f5c518; font-weight: bold; }
        .booking-panel { background: #1f1f1f; border-radius: 12px; padding: 24px; position: sticky; top: 20px; }
        .btn-confirm { background: #f5c518; color: #000; font-weight: bold; border: none; width: 100%; padding: 12px; border-radius: 8px; font-size: 1rem; }
        .btn-confirm:disabled { background: #555; color: #888; cursor: not-allowed; }
    </style>
</head>
<body>
<jsp:include page="../layout/header.jsp"/>

<div class="container mt-4">
    <a href="/films/${showtime.film.id}" class="text-warning text-decoration-none">← Quay lại</a>

    <div class="row mt-4 g-4">
        <div class="col-md-8">
            <div class="text-center mb-4">
                <h4 class="fw-bold">${showtime.film.title}</h4>
                <p class="text-muted">
                    🕐 ${showtime.startTime.hour}:<c:choose><c:when test="${showtime.startTime.minute < 10}">0${showtime.startTime.minute}</c:when><c:otherwise>${showtime.startTime.minute}</c:otherwise></c:choose>
                    - ${showtime.startTime.dayOfMonth}/${showtime.startTime.monthValue}/${showtime.startTime.year}
                    &nbsp;|&nbsp; 🏛 ${showtime.room.name} (${showtime.room.roomType})
                </p>
            </div>
            <div class="screen-label">MÀN HÌNH</div>
            <div class="screen"></div>

            <div class="seat-grid">
                <%-- Fix: dung bien Java thay vi EL array literal --%>
                <c:forEach var="rowChar" items="A,B,C,D,E,F,G,H">
                    <div class="seat-row">
                        <div class="row-label">${rowChar}</div>
                        <c:forEach begin="1" end="10" var="col">
                            <c:set var="seatLabel" value="${rowChar}${col}"/>
                            <c:choose>
                                <c:when test="${bookedSeats.contains(seatLabel)}">
                                    <div class="seat booked" title="${seatLabel} - Đã đặt">${seatLabel}</div>
                                </c:when>
                                <c:otherwise>
                                    <div class="seat available" data-seat="${seatLabel}" onclick="toggleSeat(this)">${seatLabel}</div>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </div>
                </c:forEach>
            </div>

            <div style="display:flex;gap:16px;justify-content:center;margin-top:20px;">
                <div style="display:flex;align-items:center;gap:6px;font-size:.85rem;color:#aaa;">
                    <div style="width:20px;height:20px;border-radius:4px;background:#2a2a2a;border:2px solid #555;"></div>Còn trống
                </div>
                <div style="display:flex;align-items:center;gap:6px;font-size:.85rem;color:#aaa;">
                    <div style="width:20px;height:20px;border-radius:4px;background:#f5c518;"></div>Đang chọn
                </div>
                <div style="display:flex;align-items:center;gap:6px;font-size:.85rem;color:#aaa;">
                    <div style="width:20px;height:20px;border-radius:4px;background:#555;"></div>Đã đặt
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="booking-panel">
                <h5 class="fw-bold mb-3">🎟 Thông tin đặt vé</h5>
                <div class="mb-2 text-muted small">${showtime.film.title}</div>
                <div class="mb-2 small">
                    ${showtime.startTime.hour}:<c:choose><c:when test="${showtime.startTime.minute < 10}">0${showtime.startTime.minute}</c:when><c:otherwise>${showtime.startTime.minute}</c:otherwise></c:choose>
                    - ${showtime.startTime.dayOfMonth}/${showtime.startTime.monthValue}/${showtime.startTime.year}
                </div>
                <div class="mb-3 small">Phòng: ${showtime.room.name}</div>
                <hr style="border-color:#444">
                <div class="mb-2">Ghế đã chọn: <span id="selectedSeatsDisplay" class="text-warning fw-bold">Chưa chọn</span></div>
                <div class="mb-3">Số ghế: <span id="seatCount" class="text-warning fw-bold">0</span></div>
                <div class="mb-3">Đơn giá: <span id="unitPrice">${showtime.price}</span> VNĐ/ghế</div>
                <div class="fw-bold fs-5 mb-4">Tổng tiền: <span id="totalPrice" class="text-warning">0</span> VNĐ</div>

                <form id="bookingForm" action="/booking/confirm" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <input type="hidden" name="showtimeId" value="${showtime.id}"/>
                    <div id="seatInputs"></div>
                    <button type="submit" class="btn-confirm" id="confirmBtn" disabled>Xác nhận đặt vé</button>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../layout/footer.jsp"/>
<script>
    (function(){
        const price = parseFloat(document.getElementById('unitPrice').textContent.replace(/[^0-9.]/g,'')) || 0;
        let selected = [];
        function toggleSeat(el) {
            const seat = el.dataset.seat;
            if (el.classList.contains('selected')) {
                el.classList.remove('selected'); el.classList.add('available');
                selected = selected.filter(s => s !== seat);
            } else {
                el.classList.remove('available'); el.classList.add('selected');
                selected.push(seat);
            }
            updatePanel();
        }
        function updatePanel() {
            document.getElementById('selectedSeatsDisplay').textContent = selected.length > 0 ? selected.join(', ') : 'Chưa chọn';
            document.getElementById('seatCount').textContent = selected.length;
            document.getElementById('totalPrice').textContent = (price * selected.length).toLocaleString('vi-VN');
            document.getElementById('confirmBtn').disabled = selected.length === 0;
            const c = document.getElementById('seatInputs'); c.innerHTML = '';
            selected.forEach(s => { const i = document.createElement('input'); i.type='hidden'; i.name='seats'; i.value=s; c.appendChild(i); });
        }
        window.toggleSeat = toggleSeat;
    })();
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
