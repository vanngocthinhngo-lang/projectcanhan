<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách phim - CinemaHub</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { background: #141414; color: #fff; }
        .hero { background: linear-gradient(135deg, #1a1a2e, #16213e); padding: 50px 0; }
        .film-card { background: #1f1f1f; border: none; border-radius: 10px; transition: transform .2s, box-shadow .2s; overflow: hidden; }
        .film-card:hover { transform: translateY(-6px); box-shadow: 0 12px 30px rgba(245,197,24,.2); }
        .film-card .card-img-top { height: 300px; object-fit: cover; }
        .btn-book { background: #f5c518; color: #000; font-weight: bold; border: none; }
        .btn-book:hover { background: #e6b800; }
        .form-control, .form-select { background: #2a2a2a; border-color: #444; color: #fff; }
        .form-control:focus, .form-select:focus { background: #2a2a2a; color: #fff; border-color: #f5c518; }
        .section-title { color: #f5c518; font-weight: bold; border-left: 4px solid #f5c518; padding-left: 12px; }
        .navbar-brand span { color: #f5c518; }
    </style>
</head>
<body>
<jsp:include page="../layout/header.jsp"/>

<div class="hero">
    <div class="container">
        <h1 class="fw-bold">🎬 Phim đang chiếu</h1>
        <p class="text-muted">Chọn phim và đặt vé ngay hôm nay</p>
        <form action="/films" method="get" class="row g-2 mt-2">
            <div class="col-md-6">
                <input type="text" name="keyword" class="form-control" placeholder="🔍 Tìm kiếm phim..." value="${keyword}">
            </div>
            <div class="col-md-3">
                <select name="genre" class="form-select">
                    <option value="">-- Thể loại --</option>
                    <c:forEach var="g" items="${genres}">
                        <option value="${g}" <c:if test="${g == selectedGenre}">selected</c:if>>${g}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-2">
                <button class="btn btn-book w-100">Tìm kiếm</button>
            </div>
            <div class="col-md-1">
                <a href="/films" class="btn btn-outline-secondary w-100">Xóa</a>
            </div>
        </form>
    </div>
</div>

<div class="container mt-4">
    <h4 class="section-title mb-4">
        Tất cả phim
        <small class="text-muted fw-normal fs-6 ms-2">(${films.size()} phim)</small>
    </h4>

    <c:if test="${empty films}">
        <div class="text-center py-5 text-muted">
            <h4>Không tìm thấy phim nào</h4>
            <a href="/films" class="btn btn-outline-warning mt-3">Xem tất cả</a>
        </div>
    </c:if>

    <div class="row g-4">
        <c:forEach var="film" items="${films}">
            <div class="col-6 col-md-4 col-lg-3">
                <div class="card film-card h-100">
                    <img src="${not empty film.poster ? film.poster : 'https://via.placeholder.com/300x400?text=No+Image'}" 
     class="card-img-top" alt="${film.title}">
                    <div class="card-body d-flex flex-column">
                        <h6 class="card-title text-white">${film.title}</h6>
                        <div class="mb-2">
                            <span class="badge" style="background:#f5c518;color:#000;">${film.genre}</span>
                            <span class="text-muted small ms-1">${film.duration} phút</span>
                        </div>
                        <p class="text-muted small flex-grow-1">
                            <c:choose>
                                <c:when test="${not empty film.description and film.description.length() > 80}">
                                    ${film.description.substring(0, 80)}...
                                </c:when>
                                <c:otherwise>${film.description}</c:otherwise>
                            </c:choose>
                        </p>
                        <a href="/films/${film.id}" class="btn btn-book w-100 mt-auto">Đặt vé</a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<jsp:include page="../layout/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
