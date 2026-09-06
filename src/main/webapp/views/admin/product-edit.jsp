<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sửa sản phẩm: ${product.name}</title>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <!-- Navigation Breadcrumb -->
                <nav aria-label="breadcrumb" class="mb-3">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/products" class="text-decoration-none">Sản phẩm</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Chỉnh sửa #${product.id}</li>
                    </ol>
                </nav>

                <div class="card shadow-sm border-0 rounded-3">
                    <div class="card-header bg-warning text-dark py-3">
                        <h5 class="card-title mb-0 fw-bold">
                            <i class="bi bi-pencil-square me-2"></i>Chỉnh sửa Sản phẩm #${product.id}
                        </h5>
                    </div>
                    <div class="card-body p-4">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/admin/product/update" 
                              method="POST" enctype="multipart/form-data" 
                              class="needs-validation" novalidate>
                            
                            <input type="hidden" name="id" value="${product.id}">

                            <!-- Tên sản phẩm -->
                            <div class="mb-3">
                                <label for="name" class="form-label fw-semibold">
                                    Tên sản phẩm <span class="text-danger">*</span>
                                </label>
                                <input type="text" id="name" name="name" 
                                       class="form-control form-control-lg ${not empty fieldErrors['name'] ? 'is-invalid' : ''}" 
                                       value="${product.name}" 
                                       required minlength="2" maxlength="255">
                                <div class="invalid-feedback">
                                    <c:out value="${fieldErrors['name'] != null ? fieldErrors['name'] : 'Vui lòng nhập tên sản phẩm (từ 2 đến 255 ký tự).'}" />
                                </div>
                            </div>

                            <div class="row">
                                <!-- Giá sản phẩm -->
                                <div class="col-md-6 mb-3">
                                    <label for="price" class="form-label fw-semibold">
                                        Giá sản phẩm <span class="text-danger">*</span>
                                    </label>
                                    <div class="input-group">
                                        <input type="number" id="price" name="price" 
                                               class="form-control ${not empty fieldErrors['price'] ? 'is-invalid' : ''}" 
                                               value="${product.price}" 
                                               step="any" min="1" required>
                                        <span class="input-group-text">VNĐ</span>
                                        <div class="invalid-feedback">
                                            <c:out value="${fieldErrors['price'] != null ? fieldErrors['price'] : 'Vui lòng nhập giá sản phẩm lớn hơn 0.'}" />
                                        </div>
                                    </div>
                                </div>

                                <!-- Số lượng tồn kho -->
                                <div class="col-md-6 mb-3">
                                    <label for="quantity" class="form-label fw-semibold">
                                        Số lượng tồn kho <span class="text-danger">*</span>
                                    </label>
                                    <input type="number" id="quantity" name="quantity" 
                                           class="form-control ${not empty fieldErrors['quantity'] ? 'is-invalid' : ''}" 
                                           value="${product.quantity}" 
                                           min="0" step="1" required>
                                    <div class="invalid-feedback">
                                        <c:out value="${fieldErrors['quantity'] != null ? fieldErrors['quantity'] : 'Vui lòng nhập số lượng không âm.'}" />
                                    </div>
                                </div>
                            </div>

                            <!-- Danh mục -->
                            <div class="mb-3">
                                <label for="categoryId" class="form-label fw-semibold">
                                    Danh mục sản phẩm <span class="text-danger">*</span>
                                </label>
                                <select id="categoryId" name="categoryId" 
                                        class="form-select ${not empty fieldErrors['categoryId'] ? 'is-invalid' : ''}" required>
                                    <c:forEach var="category" items="${categories}">
                                        <option value="${category.categoryid}" 
                                            ${product.category != null && product.category.categoryid == category.categoryid ? 'selected' : ''}>
                                            ${category.categoryname}
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="invalid-feedback">
                                    <c:out value="${fieldErrors['categoryId'] != null ? fieldErrors['categoryId'] : 'Vui lòng chọn danh mục hợp lệ.'}" />
                                </div>
                            </div>

                            <!-- Mô tả -->
                            <div class="mb-3">
                                <label for="description" class="form-label fw-semibold">Mô tả sản phẩm</label>
                                <textarea id="description" name="description" class="form-control" rows="4">${product.description}</textarea>
                            </div>

                            <!-- Ảnh hiện tại -->
                            <div class="mb-3">
                                <label class="form-label fw-semibold d-block">Ảnh hiện tại</label>
                                <c:choose>
                                    <c:when test="${product.image != null && product.image.startsWith('http')}">
                                        <c:set var="imgUrl" value="${product.image}" />
                                    </c:when>
                                    <c:otherwise>
                                        <c:url value="/image?fname=${product.image}" var="imgUrl" />
                                    </c:otherwise>
                                </c:choose>
                                <div class="p-2 border rounded d-inline-block bg-light">
                                    <img src="${imgUrl}" alt="${product.name}" 
                                         class="rounded" style="max-height: 120px; max-width: 200px; object-fit: contain;"
                                         onerror="this.onerror=null; this.src='https://via.placeholder.com/150?text=No+Image';">
                                </div>
                            </div>

                            <!-- Link ảnh mới (tuỳ chọn) -->
                            <div class="mb-3">
                                <label for="imageUrl" class="form-label fw-semibold">Thay đổi bằng Link ảnh Online (URL)</label>
                                <input type="text" id="imageUrl" name="imageUrl" class="form-control" 
                                       placeholder="Dán URL ảnh mới nếu có">
                            </div>

                            <!-- Upload ảnh mới -->
                            <div class="mb-4">
                                <label for="imageFile" class="form-label fw-semibold">Tải lên file ảnh mới (thay thế ảnh cũ)</label>
                                <input type="file" id="imageFile" name="imageFile" 
                                       class="form-control ${not empty fieldErrors['imageFile'] ? 'is-invalid' : ''}" 
                                       accept="image/png, image/jpeg, image/webp, image/gif">
                                <div class="form-text text-muted">Bỏ trống nếu muốn giữ nguyên ảnh hiện tại. Chấp nhận JPG, PNG, WEBP (tối đa 2MB).</div>
                                <div class="invalid-feedback">
                                    <c:out value="${fieldErrors['imageFile'] != null ? fieldErrors['imageFile'] : 'File ảnh không hợp lệ.'}" />
                                </div>
                            </div>

                            <!-- Buttons -->
                            <div class="d-flex justify-content-between align-items-center pt-3 border-top">
                                <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-left me-1"></i>Quay lại danh sách
                                </a>
                                <button type="submit" class="btn btn-warning px-4 fw-semibold">
                                    <i class="bi bi-check2-circle me-1"></i>Cập nhật sản phẩm
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
