<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="vn.iotstar.entity.User" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    User profileUser = (User) request.getAttribute("profileUser");
    if (profileUser == null) {
        response.sendRedirect(request.getContextPath() + "/login-session");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hồ sơ cá nhân - <%= profileUser.getFullname() != null ? profileUser.getFullname() : profileUser.getUsername() %></title>
</head>
<body>
    <div class="container py-4">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <!-- Navigation Breadcrumb -->
                <nav aria-label="breadcrumb" class="mb-3">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home" class="text-decoration-none">Trang chủ</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Hồ sơ cá nhân</li>
                    </ol>
                </nav>

                <div class="card shadow border-0 rounded-4 overflow-hidden">
                    <!-- Profile Card Header with Gradient -->
                    <div class="card-header bg-gradient bg-primary text-white p-4 text-center">
                        <div class="position-relative d-inline-block mb-3">
                            <c:choose>
                                <c:when test="${not empty profileUser.image}">
                                    <img src="${pageContext.request.contextPath}/image?fname=users/${profileUser.image}" 
                                         alt="Avatar" class="rounded-circle shadow border border-3 border-white" 
                                         style="width: 120px; height: 120px; object-fit: cover;"
                                         onerror="this.onerror=null; this.src='https://ui-avatars.com/api/?name=${profileUser.fullname}&size=120&background=random';">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://ui-avatars.com/api/?name=${profileUser.fullname}&size=120&background=0D6EFD&color=fff" 
                                         alt="Avatar" class="rounded-circle shadow border border-3 border-white" 
                                         style="width: 120px; height: 120px; object-fit: cover;">
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <h4 class="fw-bold mb-1"><%= profileUser.getFullname() %></h4>
                        <p class="mb-0 text-white-50 small">@<%= profileUser.getUsername() %>
                            <c:if test="${profileUser.admin}">
                                <span class="badge bg-danger ms-1">Quản trị viên</span>
                            </c:if>
                        </p>
                    </div>

                    <div class="card-body p-4 p-md-5">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show small" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <h5 class="fw-bold text-dark border-bottom pb-2 mb-4">
                            <i class="bi bi-person-lines-fill me-2 text-primary"></i>Thông tin tài khoản
                        </h5>

                        <form action="${pageContext.request.contextPath}/profile" method="post" 
                              enctype="multipart/form-data" class="needs-validation" novalidate>
                            
                            <div class="row g-3 mb-3">
                                <!-- Username (Readonly) -->
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Tên đăng nhập</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light"><i class="bi bi-person text-muted"></i></span>
                                        <input type="text" class="form-control bg-light" value="${profileUser.username}" readonly>
                                    </div>
                                    <div class="form-text text-muted small">Tên đăng nhập không thể thay đổi.</div>
                                </div>

                                <!-- Email (Readonly) -->
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Địa chỉ Email</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light"><i class="bi bi-envelope text-muted"></i></span>
                                        <input type="email" class="form-control bg-light" value="${profileUser.email}" readonly>
                                    </div>
                                    <div class="form-text text-muted small">Email định danh tài khoản.</div>
                                </div>
                            </div>

                            <!-- Fullname (Editable) -->
                            <div class="mb-3">
                                <label for="fullname" class="form-label fw-semibold">
                                    Họ và tên <span class="text-danger">*</span>
                                </label>
                                <div class="input-group has-validation">
                                    <span class="input-group-text bg-light"><i class="bi bi-card-text text-muted"></i></span>
                                    <input type="text" class="form-control ${not empty fieldErrors['fullname'] ? 'is-invalid' : ''}" 
                                           id="fullname" name="fullname" 
                                           value="${profileUser.fullname}" 
                                           placeholder="Nhập họ và tên" 
                                           required minlength="2" maxlength="100">
                                    <div class="invalid-feedback">
                                        <c:out value="${fieldErrors['fullname'] != null ? fieldErrors['fullname'] : 'Vui lòng nhập họ và tên (từ 2 đến 100 ký tự).'}" />
                                    </div>
                                </div>
                            </div>

                            <!-- Phone (Editable) -->
                            <div class="mb-3">
                                <label for="phone" class="form-label fw-semibold">Số điện thoại</label>
                                <div class="input-group has-validation">
                                    <span class="input-group-text bg-light"><i class="bi bi-telephone text-muted"></i></span>
                                    <input type="tel" class="form-control ${not empty fieldErrors['phone'] ? 'is-invalid' : ''}" 
                                           id="phone" name="phone" 
                                           value="${profileUser.phone}" 
                                           placeholder="vd: 0912345678" 
                                           pattern="^(0|\+84)(3[2-9]|5[25689]|7[06-9]|8[1-9]|9[0-9])[0-9]{7}$">
                                    <div class="invalid-feedback">
                                        <c:out value="${fieldErrors['phone'] != null ? fieldErrors['phone'] : 'Số điện thoại không hợp lệ (gồm 10 số di động VN).'}" />
                                    </div>
                                </div>
                                <div class="form-text text-muted small">Định dạng 10 chữ số (vd: 0987654321 hoặc 0345678901).</div>
                            </div>

                            <!-- Avatar Upload -->
                            <div class="mb-4">
                                <label for="image" class="form-label fw-semibold">Thay đổi ảnh đại diện (Avatar)</label>
                                <input type="file" class="form-control ${not empty fieldErrors['image'] ? 'is-invalid' : ''}" 
                                       id="image" name="image" 
                                       accept="image/png, image/jpeg, image/webp, image/gif">
                                <div class="form-text text-muted small">
                                    Định dạng hỗ trợ: JPG, JPEG, PNG, WEBP. Kích thước tối đa: 2MB.
                                </div>
                                <div class="invalid-feedback">
                                    <c:out value="${fieldErrors['image'] != null ? fieldErrors['image'] : 'File ảnh không hợp lệ.'}" />
                                </div>
                            </div>

                            <!-- Submit button -->
                            <div class="d-flex justify-content-between align-items-center pt-3 border-top">
                                <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-left me-1"></i>Về trang chủ
                                </a>
                                <button type="submit" class="btn btn-primary px-4 fw-semibold">
                                    <i class="bi bi-save me-1"></i>Lưu thay đổi
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
