<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Danh mục</title>
</head>
<body>
    <div class="container">
        <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <h2 class="fw-bold mb-0 text-dark">
                    <i class="bi bi-tags-fill me-2 text-primary"></i>Quản lý Danh mục (Category)
                </h2>
                <p class="text-muted mb-0 small">Quản lý các ngành hàng và danh mục sản phẩm</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/category/add" class="btn btn-primary shadow-sm">
                <i class="bi bi-plus-circle me-1"></i>Thêm Danh mục Mới
            </a>
        </div>

        <div class="card shadow-sm border-0 rounded-3">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover table-striped align-middle mb-0">
                        <thead class="table-dark">
                            <tr>
                                <th class="text-center" style="width: 70px;">STT</th>
                                <th style="width: 120px;">Hình ảnh</th>
                                <th>Tên danh mục</th>
                                <th class="text-center" style="width: 150px;">Trạng thái</th>
                                <th class="text-end pe-4" style="width: 180px;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty listcate}">
                                    <c:forEach items="${listcate}" var="cate" varStatus="STT">
                                        <tr>
                                            <td class="text-center fw-semibold text-muted">${STT.index + 1}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${cate.images != null && cate.images.startsWith('http')}">
                                                        <c:set var="imgUrl" value="${cate.images}" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:url value="/image?fname=${cate.images}" var="imgUrl" />
                                                    </c:otherwise>
                                                </c:choose>
                                                <img src="${imgUrl}" alt="${cate.categoryname}" 
                                                     class="rounded border" 
                                                     style="width: 70px; height: 55px; object-fit: cover;"
                                                     onerror="this.onerror=null; this.src='https://via.placeholder.com/70x55?text=Img';">
                                            </td>
                                            <td class="fw-semibold text-dark">${cate.categoryname}</td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${cate.status == 1}">
                                                        <span class="badge bg-success-subtle text-success border border-success-subtle px-3 py-2">
                                                            <i class="bi bi-check-circle me-1"></i>Hoạt động
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle px-3 py-2">
                                                            <i class="bi bi-dash-circle me-1"></i>Khóa
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-end pe-4">
                                                <a href="${pageContext.request.contextPath}/admin/category/edit?id=${cate.categoryid}" 
                                                   class="btn btn-sm btn-outline-warning me-1" title="Chỉnh sửa">
                                                    <i class="bi bi-pencil-square me-1"></i>Sửa
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/category/delete?id=${cate.categoryid}" 
                                                   class="btn btn-sm btn-outline-danger" title="Xóa"
                                                   onclick="return confirm('Bạn có chắc chắn muốn xóa danh mục \"${cate.categoryname}\"?')">
                                                    <i class="bi bi-trash me-1"></i>Xóa
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="5" class="text-center py-4 text-muted">
                                            <i class="bi bi-inbox fs-2 d-block mb-2 text-secondary"></i>
                                            Chưa có danh mục nào. Hãy bấm <strong>Thêm Danh mục Mới</strong> để tạo!
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
