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
    <title>Chi tiết: ${product.name}</title>
</head>
<body>
    <div class="container py-3">
        <!-- Navigation Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home" class="text-decoration-none">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/products" class="text-decoration-none">Sản phẩm</a></li>
                <li class="breadcrumb-item active" aria-current="page">${product.name}</li>
            </ol>
        </nav>

        <div class="card shadow-sm border-0 rounded-4 overflow-hidden mb-4">
            <div class="card-body p-4 p-md-5">
                <div class="row g-5">
                    <!-- Ảnh sản phẩm -->
                    <div class="col-md-5 text-center">
                        <c:choose>
                            <c:when test="${product.image != null && product.image.startsWith('http')}">
                                <c:set var="imgUrl" value="${product.image}" />
                            </c:when>
                            <c:otherwise>
                                <c:url value="/image?fname=${product.image}" var="imgUrl" />
                            </c:otherwise>
                        </c:choose>
                        <div class="p-3 bg-light rounded-3 border text-center">
                            <img src="${imgUrl}" alt="${product.name}" 
                                 class="img-fluid rounded" style="max-height: 380px; object-fit: contain;"
                                 onerror="this.onerror=null; this.src='https://via.placeholder.com/350x350?text=No+Image';">
                        </div>
                    </div>

                    <!-- Thông tin sản phẩm -->
                    <div class="col-md-7 d-flex flex-column justify-content-between">
                        <div>
                            <span class="badge bg-primary-subtle text-primary border border-primary-subtle px-3 py-2 mb-2">
                                <i class="bi bi-tag me-1"></i>${product.category != null ? product.category.categoryname : 'Mặt hàng'}
                            </span>
                            <h2 class="fw-bold text-dark mb-3">${product.name}</h2>
                            <h3 class="fw-bold text-danger mb-3">
                                <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true"/> đ
                            </h3>

                            <div class="mb-3">
                                <span class="text-muted fw-semibold">Tình trạng kho:</span>
                                <c:choose>
                                    <c:when test="${product.quantity > 0}">
                                        <span class="badge bg-success-subtle text-success ms-2 px-2 py-1">
                                            Còn hàng (${product.quantity} sản phẩm)
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-danger-subtle text-danger ms-2 px-2 py-1">Hết hàng</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="card bg-light border-0 rounded-3 p-3 mb-4">
                                <h6 class="fw-bold text-dark mb-2"><i class="bi bi-info-circle me-1"></i>Mô tả sản phẩm:</h6>
                                <p class="text-muted mb-0 small" style="white-space: pre-line;">
                                    ${not empty product.description ? product.description : 'Đang cập nhật thông tin mô tả chi tiết cho sản phẩm này.'}
                                </p>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="d-flex gap-2 pt-3 border-top">
                            <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary">
                                <i class="bi bi-arrow-left me-1"></i>Quay lại danh sách
                            </a>
                            <c:if test="${sessionScope.user.admin}">
                                <a href="${pageContext.request.contextPath}/admin/product/edit?id=${product.id}" class="btn btn-warning fw-semibold text-dark">
                                    <i class="bi bi-pencil-square me-1"></i>Chỉnh sửa (Admin)
                                </a>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
