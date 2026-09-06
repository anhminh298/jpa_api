<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login-session");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách sản phẩm</title>
</head>
<body>
    <div class="container py-2">
        <!-- Page Title & Header -->
        <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <h2 class="fw-bold mb-0 text-dark">
                    <i class="bi bi-shop me-2 text-primary"></i>Danh sách Sản phẩm
                </h2>
                <p class="text-muted mb-0 small">Khám phá toàn bộ sản phẩm chất lượng cao với giá ưu đãi</p>
            </div>
            <c:if test="${sessionScope.user.admin}">
                <a href="${pageContext.request.contextPath}/admin/product/add" class="btn btn-primary shadow-sm">
                    <i class="bi bi-plus-circle me-1"></i>Thêm sản phẩm
                </a>
            </c:if>
        </div>

        <!-- Product Grid -->
        <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4 mb-5">
            <c:forEach var="product" items="${products}">
                <div class="col">
                    <div class="card h-100 shadow-sm border-0 rounded-3 overflow-hidden d-flex flex-column justify-content-between">
                        <div>
                            <!-- Product Image -->
                            <div class="position-relative bg-light text-center p-2" style="height: 200px;">
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
                                     onerror="this.onerror=null; this.src='https://via.placeholder.com/200x200?text=SP';">
                                <span class="position-absolute top-0 start-0 m-2 badge bg-primary-subtle text-primary border border-primary-subtle">
                                    ${product.category != null ? product.category.categoryname : 'Mặt hàng'}
                                </span>
                            </div>

                            <!-- Card Body -->
                            <div class="card-body p-3">
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

                        <!-- Card Footer Action Buttons -->
                        <div class="card-footer bg-white border-top-0 p-3 pt-0">
                            <div class="d-grid gap-2">
                                <a href="${pageContext.request.contextPath}/product?id=${product.id}" class="btn btn-outline-primary btn-sm">
                                    <i class="bi bi-eye me-1"></i>Xem chi tiết
                                </a>
                                <c:if test="${sessionScope.user.admin}">
                                    <a href="${pageContext.request.contextPath}/admin/product/edit?id=${product.id}" class="btn btn-outline-warning btn-sm text-dark">
                                        <i class="bi bi-pencil me-1"></i>Sửa (Admin)
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <nav aria-label="Page navigation">
                <ul class="pagination justify-content-center">
                    <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/products?page=${currentPage - 1}" tabindex="-1">
                            <i class="bi bi-chevron-left"></i> Trước
                        </a>
                    </li>
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/products?page=${i}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/products?page=${currentPage + 1}">
                            Sau <i class="bi bi-chevron-right"></i>
                        </a>
                    </li>
                </ul>
            </nav>
        </c:if>
    </div>
</body>
</html>
