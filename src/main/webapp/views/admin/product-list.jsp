<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Sản phẩm</title>
</head>
<body>
    <div class="container">
        <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <h2 class="fw-bold mb-0 text-dark">
                    <i class="bi bi-box-seam-fill me-2 text-primary"></i>Quản lý Sản phẩm (Products)
                </h2>
                <p class="text-muted mb-0 small">Danh sách và thông tin chi tiết tất cả mặt hàng trong kho</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/product/add" class="btn btn-primary shadow-sm">
                <i class="bi bi-plus-circle me-1"></i>Thêm Sản phẩm Mới
            </a>
        </div>

        <div class="card shadow-sm border-0 rounded-3">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover table-striped align-middle mb-0">
                        <thead class="table-dark">
                            <tr>
                                <th class="text-center" style="width: 60px;">ID</th>
                                <th style="width: 100px;">Hình ảnh</th>
                                <th>Tên sản phẩm</th>
                                <th style="width: 140px;">Đơn giá</th>
                                <th class="text-center" style="width: 110px;">Tồn kho</th>
                                <th>Danh mục</th>
                                <th class="text-end pe-4" style="width: 180px;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty listProduct}">
                                    <c:forEach var="product" items="${listProduct}">
                                        <tr>
                                            <td class="text-center fw-semibold text-muted">#${product.id}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${product.image != null && product.image.startsWith('http')}">
                                                        <c:set var="imgUrl" value="${product.image}" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:url value="/image?fname=${product.image}" var="imgUrl" />
                                                    </c:otherwise>
                                                </c:choose>
                                                <img src="${imgUrl}" alt="${product.name}" 
                                                     class="rounded border" 
                                                     style="width: 65px; height: 65px; object-fit: cover;"
                                                     onerror="this.onerror=null; this.src='https://via.placeholder.com/65?text=SP';">
                                            </td>
                                            <td>
                                                <div class="fw-semibold text-dark">${product.name}</div>
                                                <small class="text-muted text-truncate d-inline-block" style="max-width: 280px;">
                                                    ${product.description}
                                                </small>
                                            </td>
                                            <td class="fw-bold text-danger">
                                                <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true"/> đ
                                            </td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${product.quantity > 10}">
                                                        <span class="badge bg-success-subtle text-success border border-success-subtle px-2 py-1">
                                                            ${product.quantity} cái
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${product.quantity > 0}">
                                                        <span class="badge bg-warning-subtle text-warning border border-warning-subtle px-2 py-1">
                                                            ${product.quantity} cái (Sắp hết)
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-2 py-1">
                                                            Hết hàng
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="badge bg-info-subtle text-info border border-info-subtle px-2 py-1">
                                                    <i class="bi bi-tag me-1"></i>${product.category != null ? product.category.categoryname : 'Chưa phân loại'}
                                                </span>
                                            </td>
                                            <td class="text-end pe-4">
                                                <a href="${pageContext.request.contextPath}/admin/product/edit?id=${product.id}" 
                                                   class="btn btn-sm btn-outline-warning me-1" title="Chỉnh sửa">
                                                    <i class="bi bi-pencil-square me-1"></i>Sửa
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/product/delete?id=${product.id}" 
                                                   class="btn btn-sm btn-outline-danger" title="Xóa"
                                                   onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm \"${product.name}\"?')">
                                                    <i class="bi bi-trash me-1"></i>Xóa
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" class="text-center py-4 text-muted">
                                            <i class="bi bi-inbox fs-2 d-block mb-2 text-secondary"></i>
                                            Chưa có sản phẩm nào. Hãy bấm <strong>Thêm Sản phẩm Mới</strong> để tạo!
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
