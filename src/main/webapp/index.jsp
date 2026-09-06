<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login-session");
        return;
    }
    if (request.getAttribute("newestProducts") == null) {
        response.sendRedirect(request.getContextPath() + "/home");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Trang chủ - Cửa hàng trực tuyến</title>
</head>
<body>
    <div class="container py-2">
        <!-- Hero Banner with Bootstrap 5 Jumbotron/Card -->
        <div class="p-5 mb-4 bg-primary bg-gradient text-white rounded-4 shadow-sm">
            <div class="row align-items-center">
                <div class="col-lg-8">
                    <h1 class="display-5 fw-bold mb-3">Chào mừng bạn đến với IoTStar Shop!</h1>
                    <p class="col-md-10 fs-5 text-white-50">
                        Nền tảng mua sắm trực tuyến hàng đầu tích hợp kiến trúc Servlet, JSP, SiteMesh Decorator 3 và JPA Hibernate hiện đại.
                    </p>
                    <div class="d-flex gap-2 mt-4">
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-warning btn-lg fw-semibold shadow-sm text-dark">
                            <i class="bi bi-box-seam me-1"></i>Xem tất cả sản phẩm
                        </a>
                        <c:if test="${sessionScope.user.admin}">
                            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-light btn-lg fw-semibold">
                                <i class="bi bi-speedometer2 me-1"></i>Trang quản trị
                            </a>
                        </c:if>
                    </div>
                </div>
                <div class="col-lg-4 text-center d-none d-lg-block">
                    <i class="bi bi-shop-window text-white-50" style="font-size: 140px;"></i>
                </div>
            </div>
        </div>

        <!-- Section Newest Products -->
        <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <h3 class="fw-bold mb-0 text-dark">
                    <i class="bi bi-stars me-2 text-warning"></i>Sản phẩm Mới Nhất
                </h3>
                <p class="text-muted mb-0 small">Các sản phẩm vừa được cập nhật vào hệ thống</p>
            </div>
            <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-primary btn-sm">
                Xem tất cả <i class="bi bi-arrow-right ms-1"></i>
            </a>
        </div>

        <!-- Product Cards Grid -->
        <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4 mb-5">
            <c:forEach var="product" items="${newestProducts}">
                <div class="col">
                    <div class="card h-100 shadow-sm border-0 rounded-3 overflow-hidden d-flex flex-column justify-content-between">
                        <div>
                            <div class="position-relative bg-light text-center p-2" style="height: 190px;">
                                <c:choose>
                                    <c:when test="${product.image != null && product.image.startsWith('http')}">
                                        <c:set var="imgUrl" value="${product.image}" />
                                    </c:when>
                                    <c:otherwise>
                                        <c:url value="/image?fname=${product.image}" var="imgUrl" />
                                    </c:otherwise>
                                </c:choose>
                                <img src="${imgUrl}" alt="${product.name}" 
                                     class="w-100 h-100 object-fit-contain"
                                     onerror="this.onerror=null; this.src='https://via.placeholder.com/190x190?text=SP';">
                                <span class="position-absolute top-0 start-0 m-2 badge bg-danger">Mới</span>
                            </div>

                            <div class="card-body p-3">
                                <span class="badge bg-primary-subtle text-primary border border-primary-subtle mb-1">
                                    ${product.category != null ? product.category.categoryname : 'Mặt hàng'}
                                </span>
                                <h6 class="card-title fw-bold text-truncate mb-1" title="${product.name}">
                                    <a href="${pageContext.request.contextPath}/product?id=${product.id}" class="text-decoration-none text-dark">
                                        ${product.name}
                                    </a>
                                </h6>
                                <p class="card-text text-muted small text-truncate mb-2">${product.description}</p>
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="fs-5 fw-bold text-danger">
                                        <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true"/> đ
                                    </span>
                                    <small class="text-muted">Kho: ${product.quantity}</small>
                                </div>
                            </div>
                        </div>

                        <div class="card-footer bg-white border-top-0 p-3 pt-0">
                            <div class="d-grid gap-2">
                                <a href="${pageContext.request.contextPath}/product?id=${product.id}" class="btn btn-outline-primary btn-sm">
                                    <i class="bi bi-eye me-1"></i>Chi tiết
                                </a>
                                <c:if test="${sessionScope.user.admin}">
                                    <a href="${pageContext.request.contextPath}/admin/product/edit?id=${product.id}" class="btn btn-outline-warning btn-sm text-dark">
                                        <i class="bi bi-pencil me-1"></i>Sửa
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</body>
</html>
