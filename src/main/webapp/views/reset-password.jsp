<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đặt lại mật khẩu mới</title>
</head>
<body>
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card shadow border-0 rounded-4">
                    <div class="card-body p-4 p-md-5">
                        <div class="text-center mb-4">
                            <div class="d-inline-flex align-items-center justify-content-center bg-warning-subtle text-warning rounded-circle mb-3" style="width: 60px; height: 60px;">
                                <i class="bi bi-shield-lock-fill fs-3 text-dark"></i>
                            </div>
                            <h3 class="fw-bold text-dark">Đặt lại mật khẩu</h3>
                            <p class="text-muted small">
                                Cho tài khoản: <strong class="text-primary">${sessionScope.resetEmail}</strong>
                            </p>
                        </div>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show small" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/reset-password" method="post" 
                              class="needs-validation" novalidate>
                            
                            <!-- Mã OTP -->
                            <div class="mb-3">
                                <label for="otp" class="form-label fw-semibold">Mã OTP (6 chữ số) <span class="text-danger">*</span></label>
                                <div class="input-group has-validation">
                                    <span class="input-group-text bg-light"><i class="bi bi-123 text-muted"></i></span>
                                    <input type="text" class="form-control text-center fw-bold" id="otp" name="otp" 
                                           value="${otp}" maxlength="6" pattern="^[0-9]{6}$" 
                                           placeholder="------" style="letter-spacing: 5px;" required autofocus>
                                    <div class="invalid-feedback">
                                        Vui lòng nhập đúng mã OTP gồm 6 chữ số.
                                    </div>
                                </div>
                            </div>

                            <!-- Mật khẩu mới -->
                            <div class="mb-3">
                                <label for="newPassword" class="form-label fw-semibold">Mật khẩu mới <span class="text-danger">*</span></label>
                                <div class="input-group has-validation">
                                    <span class="input-group-text bg-light"><i class="bi bi-lock text-muted"></i></span>
                                    <input type="password" class="form-control" id="newPassword" name="newPassword" 
                                           placeholder="Tối thiểu 6 ký tự" required minlength="6">
                                    <div class="invalid-feedback">
                                        Mật khẩu mới phải có ít nhất 6 ký tự.
                                    </div>
                                </div>
                            </div>

                            <!-- Xác nhận mật khẩu mới -->
                            <div class="mb-4">
                                <label for="confirmPassword" class="form-label fw-semibold">Xác nhận mật khẩu mới <span class="text-danger">*</span></label>
                                <div class="input-group has-validation">
                                    <span class="input-group-text bg-light"><i class="bi bi-shield-check text-muted"></i></span>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                                           placeholder="Nhập lại mật khẩu mới" required minlength="6">
                                    <div class="invalid-feedback">
                                        Vui lòng xác nhận lại mật khẩu mới.
                                    </div>
                                </div>
                            </div>

                            <!-- Submit -->
                            <div class="d-grid mb-3">
                                <button type="submit" class="btn btn-warning btn-lg fw-semibold shadow-sm text-dark">
                                    <i class="bi bi-check2-circle me-1"></i>Đổi mật khẩu
                                </button>
                            </div>

                            <div class="text-center">
                                <a href="${pageContext.request.contextPath}/login-session" class="text-decoration-none small text-muted">
                                    <i class="bi bi-arrow-left me-1"></i>Hủy và quay lại Đăng nhập
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
