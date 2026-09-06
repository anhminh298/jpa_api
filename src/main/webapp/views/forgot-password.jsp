<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quên mật khẩu</title>
</head>
<body>
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card shadow border-0 rounded-4">
                    <div class="card-body p-4 p-md-5">
                        <div class="text-center mb-4">
                            <div class="d-inline-flex align-items-center justify-content-center bg-danger-subtle text-danger rounded-circle mb-3" style="width: 60px; height: 60px;">
                                <i class="bi bi-key-fill fs-3"></i>
                            </div>
                            <h3 class="fw-bold text-dark">Quên mật khẩu</h3>
                            <p class="text-muted small">Nhập email đã đăng ký để nhận mã OTP khôi phục mật khẩu</p>
                        </div>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show small" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/forgot-password" method="post" 
                              class="needs-validation" novalidate>
                            
                            <div class="mb-3">
                                <label for="email" class="form-label fw-semibold">Địa chỉ Email <span class="text-danger">*</span></label>
                                <div class="input-group has-validation">
                                    <span class="input-group-text bg-light"><i class="bi bi-envelope text-muted"></i></span>
                                    <input type="email" class="form-control" id="email" name="email" 
                                           value="${email}" placeholder="vd: your-email@domain.com" required>
                                    <div class="invalid-feedback">
                                        Vui lòng nhập một địa chỉ email hợp lệ.
                                    </div>
                                </div>
                            </div>

                            <div class="d-grid mb-3 mt-4">
                                <button type="submit" class="btn btn-danger btn-lg fw-semibold shadow-sm">
                                    <i class="bi bi-send me-1"></i>Gửi mã xác thực OTP
                                </button>
                            </div>

                            <div class="text-center">
                                <a href="${pageContext.request.contextPath}/login-session" class="text-decoration-none small">
                                    <i class="bi bi-arrow-left me-1"></i>Quay lại trang Đăng nhập
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
