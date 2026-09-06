<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thêm sản phẩm mới</title>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <!-- Navigation Breadcrumb -->
                <nav aria-label="breadcrumb" class="mb-3">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/products" class="text-decoration-none">Sản phẩm</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Thêm mới</li>
                    </ol>
                </nav>

                <div class="card shadow-sm border-0 rounded-3">
                    <div class="card-header bg-primary text-white py-3">
                        <h5 class="card-title mb-0 fw-bold">
                            <i class="bi bi-box-seam me-2"></i>Thêm Sản phẩm Mới
                        </h5>
                    </div>
                    <div class="card-body p-4">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/admin/product/insert" 
                              method="POST" enctype="multipart/form-data" 
                              class="needs-validation" novalidate>
                            
                            <!-- Tên sản phẩm -->
                            <div class="mb-3">
                                <label for="name" class="form-label fw-semibold">
                                    Tên sản phẩm <span class="text-danger">*</span>
                                </label>
                                <input type="text" id="name" name="name" 
                                       class="form-control form-control-lg ${not empty fieldErrors['name'] ? 'is-invalid' : ''}" 
                                       value="${product.name}" 
                                       placeholder="Ví dụ: iPhone 15 Pro Max 256GB" 
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
                                               value="${product.price > 0 ? product.price : ''}" 
                                               placeholder="0" step="any" min="1" required>
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
                                           value="${product.quantity >= 0 ? product.quantity : '1'}" 
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
                                    <option value="" disabled ${empty product.category ? 'selected' : ''}>-- Chọn danh mục --</option>
                                    <c:forEach var="category" items="${categories}">
                                        <option value="${category.categoryid}" 
                                            ${product.category != null && product.category.categoryid == category.categoryid ? 'selected' : ''}>
                                            ${category.categoryname}
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="invalid-feedback">
                                    <c:out value="${fieldErrors['categoryId'] != null ? fieldErrors['categoryId'] : 'Vui lòng chọn một danh mục.'}" />
                                </div>
                            </div>

                            <!-- Mô tả sản phẩm -->
                            <div class="mb-3">
                                <label for="description" class="form-label fw-semibold">Mô tả sản phẩm</label>
                                <textarea id="description" name="description" class="form-control" rows="4" 
                                          placeholder="Nhập thông tin chi tiết hoặc thông số kỹ thuật...">${product.description}</textarea>
                            </div>

                            <!-- Link hình ảnh online -->
                            <div class="mb-3">
                                <label for="imageUrl" class="form-label fw-semibold">Link ảnh Online (URL)</label>
                                <input type="text" id="imageUrl" name="imageUrl" class="form-control" 
                                       placeholder="https://example.com/product.jpg (tuỳ chọn)">
                            </div>

                            <!-- Upload file ảnh -->
                            <div class="mb-4">
                                <label for="imageFile" class="form-label fw-semibold">Tải lên file ảnh từ máy tính</label>
                                <input type="file" id="imageFile" name="imageFile" 
                                       class="form-control ${not empty fieldErrors['imageFile'] ? 'is-invalid' : ''}" 
                                       accept="image/png, image/jpeg, image/webp, image/gif">
                                <div class="form-text text-muted">Chấp nhận JPG, PNG, WEBP, GIF (dung lượng tối đa 2MB).</div>
                                <div class="invalid-feedback">
                                    <c:out value="${fieldErrors['imageFile'] != null ? fieldErrors['imageFile'] : 'File ảnh không hợp lệ.'}" />
                                </div>
                            </div>

                            <!-- Buttons -->
                            <div class="d-flex justify-content-between align-items-center pt-3 border-top">
                                <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-left me-1"></i>Quay lại danh sách
                                </a>
                                <button type="submit" class="btn btn-primary px-4">
                                    <i class="bi bi-plus-circle me-1"></i>Thêm sản phẩm
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
