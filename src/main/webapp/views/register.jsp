<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng ký tài khoản</title>
</head>
<body>
    <div class="container py-4">
        <div class="row justify-content-center">
            <div class="col-md-7 col-lg-5">
                <div class="card shadow border-0 rounded-4">
                    <div class="card-body p-4 p-md-5">
                        <div class="text-center mb-4">
                            <div class="d-inline-flex align-items-center justify-content-center bg-primary-subtle text-primary rounded-circle mb-3" style="width: 60px; height: 60px;">
                                <i class="bi bi-person-plus-fill fs-3"></i>
                            </div>
                            <h3 class="fw-bold text-dark">Tạo tài khoản mới</h3>
                            <p class="text-muted small">Điền các thông tin bên dưới để đăng ký tài khoản</p>
                        </div>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show small" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/register" method="post" 
                              class="needs-validation" novalidate>
                            
                            <!-- Username -->
                            <div class="mb-3">
                                <label for="username" class="form-label fw-semibold">Tên đăng nhập <span class="text-danger">*</span></label>
                                <div class="input-group has-validation">
                                    <span class="input-group-text bg-light"><i class="bi bi-person text-muted"></i></span>
                                    <input type="text" class="form-control ${not empty fieldErrors['username'] ? 'is-invalid' : ''}" 
                                           id="username" name="username" 
                                           value="${username}" 
                                           placeholder="vd: nguyenvana" 
                                           required minlength="3" maxlength="30" pattern="^[a-zA-Z0-9_]+$">
                                    <div class="invalid-feedback">
                                        <c:out value="${fieldErrors['username'] != null ? fieldErrors['username'] : 'Tên đăng nhập từ 3-30 ký tự (chỉ gồm chữ cái, số, gạch dưới).'}" />
                                    </div>
                                </div>
                            </div>

                            <!-- Fullname -->
                            <div class="mb-3">
                                <label for="fullname" class="form-label fw-semibold">Họ và tên <span class="text-danger">*</span></label>
                                <div class="input-group has-validation">
                                    <span class="input-group-text bg-light"><i class="bi bi-card-text text-muted"></i></span>
                                    <input type="text" class="form-control ${not empty fieldErrors['fullname'] ? 'is-invalid' : ''}" 
                                           id="fullname" name="fullname" 
                                           value="${fullname}" 
                                           placeholder="vd: Nguyễn Văn A" 
                                           required minlength="2" maxlength="100">
                                    <div class="invalid-feedback">
                                        <c:out value="${fieldErrors['fullname'] != null ? fieldErrors['fullname'] : 'Vui lòng nhập họ và tên của bạn.'}" />
                                    </div>
                                </div>
                            </div>

                            <!-- Email -->
                            <div class="mb-3">
                                <label for="email" class="form-label fw-semibold">Địa chỉ Email <span class="text-danger">*</span></label>
                                <div class="input-group has-validation">
                                    <span class="input-group-text bg-light"><i class="bi bi-envelope text-muted"></i></span>
                                    <input type="email" class="form-control ${not empty fieldErrors['email'] ? 'is-invalid' : ''}" 
                                           id="email" name="email" 
                                           value="${email}" 
                                           placeholder="vd: email@example.com" 
                                           required>
                                    <div class="invalid-feedback">
                                        <c:out value="${fieldErrors['email'] != null ? fieldErrors['email'] : 'Vui lòng nhập địa chỉ email hợp lệ.'}" />
                                    </div>
                                </div>
                            </div>

                            <!-- Password -->
                            <div class="mb-3">
                                <label for="password" class="form-label fw-semibold">Mật khẩu <span class="text-danger">*</span></label>
                                <div class="input-group has-validation">
                                    <span class="input-group-text bg-light"><i class="bi bi-lock text-muted"></i></span>
                                    <input type="password" class="form-control ${not empty fieldErrors['password'] ? 'is-invalid' : ''}" 
                                           id="password" name="password" 
                                           placeholder="Tối thiểu 6 ký tự" 
                                           required minlength="6">
                                    <div class="invalid-feedback">
                                        <c:out value="${fieldErrors['password'] != null ? fieldErrors['password'] : 'Mật khẩu phải có ít nhất 6 ký tự.'}" />
                                    </div>
                                </div>
                            </div>

                            <!-- Confirm Password -->
                            <div class="mb-4">
                                <label for="confirmPassword" class="form-label fw-semibold">Xác nhận mật khẩu <span class="text-danger">*</span></label>
                                <div class="input-group has-validation">
                                    <span class="input-group-text bg-light"><i class="bi bi-shield-check text-muted"></i></span>
                                    <input type="password" class="form-control ${not empty fieldErrors['confirmPassword'] ? 'is-invalid' : ''}" 
                                           id="confirmPassword" name="confirmPassword" 
                                           placeholder="Nhập lại mật khẩu phía trên" 
                                           required minlength="6">
                                    <div class="invalid-feedback">
                                        <c:out value="${fieldErrors['confirmPassword'] != null ? fieldErrors['confirmPassword'] : 'Vui lòng xác nhận lại mật khẩu.'}" />
                                    </div>
                                </div>
                            </div>

                            <!-- Submit Button -->
                            <div class="d-grid mb-3">
                                <button type="submit" class="btn btn-primary btn-lg fw-semibold shadow-sm">
                                    <i class="bi bi-check2-circle me-1"></i>Đăng ký ngay
                                </button>
                            </div>

                            <div class="text-center">
                                <span class="text-muted small">Đã có tài khoản?</span>
                                <a href="${pageContext.request.contextPath}/login-session" class="text-decoration-none fw-semibold small ms-1">
                                    Đăng nhập
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
