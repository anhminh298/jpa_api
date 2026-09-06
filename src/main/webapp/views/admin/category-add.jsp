<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thêm Category mới</title>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <!-- Navigation Breadcrumb -->
                <nav aria-label="breadcrumb" class="mb-3">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/categories" class="text-decoration-none">Category</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Thêm mới</li>
                    </ol>
                </nav>

                <div class="card shadow-sm border-0 rounded-3">
                    <div class="card-header bg-primary text-white py-3">
                        <h5 class="card-title mb-0 fw-bold">
                            <i class="bi bi-folder-plus me-2"></i>Thêm Danh mục Mới (Category)
                        </h5>
                    </div>
                    <div class="card-body p-4">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/admin/category/insert" 
                              method="post" enctype="multipart/form-data" 
                              class="needs-validation" novalidate>
                            
                            <!-- Category Name -->
                            <div class="mb-3">
                                <label for="categoryname" class="form-label fw-semibold">
                                    Tên danh mục <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control form-control-lg ${not empty error ? 'is-invalid' : ''}" 
                                       id="categoryname" name="categoryname" 
                                       value="${category.categoryname}" 
                                       placeholder="Nhập tên danh mục (vd: Điện thoại, Laptop...)" 
                                       required minlength="2" maxlength="50">
                                <div class="invalid-feedback">
                                    Vui lòng nhập tên danh mục hợp lệ (từ 2 đến 50 ký tự).
                                </div>
                            </div>

                            <!-- Link Image (Optional) -->
                            <div class="mb-3">
                                <label for="images" class="form-label fw-semibold">Link ảnh Online (URL)</label>
                                <input type="text" class="form-control" id="images" name="images" 
                                       value="${category.images}" 
                                       placeholder="https://example.com/image.jpg (tuỳ chọn)">
                                <div class="form-text text-muted">Nếu bạn có link ảnh trực tiếp từ internet, dán vào đây.</div>
                            </div>

                            <!-- Upload Image -->
                            <div class="mb-3">
                                <label for="images1" class="form-label fw-semibold">Tải lên file ảnh từ máy tính</label>
                                <input type="file" class="form-control" id="images1" name="images1" 
                                       accept="image/png, image/jpeg, image/webp, image/gif">
                                <div class="form-text text-muted">Chấp nhận JPG, PNG, WEBP, GIF. Tối đa 2MB.</div>
                            </div>

                            <!-- Status -->
                            <div class="mb-4">
                                <label class="form-label fw-semibold d-block">Trạng thái hoạt động</label>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="status" id="statusActive" value="1" 
                                           ${empty category || category.status == 1 ? 'checked' : ''}>
                                    <label class="form-check-label text-success fw-medium" for="statusActive">
                                        <i class="bi bi-check-circle me-1"></i>Hoạt động
                                    </label>
                                </div>
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="radio" name="status" id="statusInactive" value="0" 
                                           ${category.status == 0 ? 'checked' : ''}>
                                    <label class="form-check-label text-secondary fw-medium" for="statusInactive">
                                        <i class="bi bi-slash-circle me-1"></i>Khóa
                                    </label>
                                </div>
                            </div>

                            <!-- Form Actions -->
                            <div class="d-flex justify-content-between align-items-center pt-3 border-top">
                                <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-left me-1"></i>Quay lại danh sách
                                </a>
                                <button type="submit" class="btn btn-primary px-4">
                                    <i class="bi bi-save me-1"></i>Lưu danh mục
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
