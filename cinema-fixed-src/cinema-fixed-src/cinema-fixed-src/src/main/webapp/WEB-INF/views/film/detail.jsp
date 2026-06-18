<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${film.title} - CinemaHub</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { background: #141414; color: #fff; }
        .showtime-card { background: #1f1f1f; border: 1px solid #333; border-radius: 8px; padding: 16px; transition: all .2s; }
        .showtime-card:hover { border-color: #f5c518; background: #2a2a2a; }
        .btn-book { background: #f5c518; color: #000; font-weight: bold; border: none; }
        .btn-book:hover { background: #e6b800; }
        .section-title { color: #f5c518; font-weight: bold; border-left: 4px solid #f5c518; padding-left: 12px; }
    </style>
</head>
<body>
<jsp:include page="../layout/header.jsp"/>

<div class="container mt-4">
    <a href="/films" class="text-warning text-decoration-none">← Quay lại danh sách phim</a>

    <div class="row mt-4 g-4">
        <div class="col-md-3 text-center">
            <img src="${not empty film.poster ? film.poster : 'https://via.placeholder.com/300x440?text=No+Image'}"
                 style="border-radius:12px;width:100%;max-width:300px;box-shadow:0 20px 40px rgba(0,0,0,.6);"
                 alt="${film.title}">
        </div>

        <div class="col-md-9">
            <h2 class="fw-bold">${film.title}</h2>
            <div class="mb-3">
                <span class="badge" style="background:#f5c518;color:#000;">${film.genre}</span>
                <span class="badge bg-secondary ms-1">${film.status}</span>
            </div>
            <div class="text-muted mb-1">⏱ Thời lượng: <span class="text-white">${film.duration} phút</span></div>
            <div class="text-muted mb-1">🎬 Đạo diễn: <span class="text-white">${film.director}</span></div>
            <div class="text-muted mb-1">📅 Ngày ra mắt: <span class="text-white">${film.releaseDate}</span></div>
            <p class="text-muted mt-3">${film.description}</p>

            <h5 class="section-title mt-4 mb-3">Suất chiếu</h5>
            <c:if test="${empty showtimes}">
                <p class="text-muted">Hiện chưa có suất chiếu nào.</p>
            </c:if>
            <div class="row g-3">
                <c:forEach var="st" items="${showtimes}">
                    <div class="col-md-4">
                        <div class="showtime-card">
                            <div class="fw-bold text-warning">${st.startTime.hour}:<c:choose><c:when test="${st.startTime.minute < 10}">0${st.startTime.minute}</c:when><c:otherwise>${st.startTime.minute}</c:otherwise></c:choose></div>
                            <div class="text-muted small">${st.startTime.dayOfMonth}/${st.startTime.monthValue}/${st.startTime.year}</div>
                            <div class="small mt-1">🏛 ${st.room.name} (${st.room.roomType})</div>
                            <div class="fw-bold mt-2 text-warning">${st.price} VNĐ</div>
                            <a href="/booking/${st.id}" class="btn btn-book w-100 mt-2 btn-sm">Chọn ghế</a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../layout/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
