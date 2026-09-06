<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập (Cookie - Remember Me)</title>
</head>
<body>
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-4">
                <div class="card shadow border-0 rounded-4">
                    <div class="card-body p-4 p-md-5">
                        <div class="text-center mb-4">
                            <div class="d-inline-flex align-items-center justify-content-center bg-info-subtle text-info rounded-circle mb-3" style="width: 60px; height: 60px;">
                                <i class="bi bi-cookie fs-3"></i>
                            </div>
                            <h3 class="fw-bold text-dark">Đăng nhập</h3>
                            <p class="text-muted small">Lưu thông tin với Cookie (Remember Me)</p>
                        </div>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show small" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/login-cookie" method="post" 
                              class="needs-validation" novalidate>
                            
                            <div class="mb-3">
                                <label for="username" class="form-label fw-semibold">Tên đăng nhập <span class="text-danger">*</span></label>
                                <div class="input-group has-validation">
                                    <span class="input-group-text bg-light"><i class="bi bi-person text-muted"></i></span>
                                    <input type="text" class="form-control" id="username" name="username" 
                                           value="${not empty savedUsername ? savedUsername : username}" 
                                           placeholder="Nhập tên đăng nhập" required>
                                    <div class="invalid-feedback">
                                        Vui lòng nhập tên đăng nhập.
                                    </div>
                                </div>
                            </div>

                            <div class="mb-3">
                                <div class="d-flex justify-content-between align-items-center">
                                    <label for="password" class="form-label fw-semibold mb-0">Mật khẩu <span class="text-danger">*</span></label>
                                    <a href="${pageContext.request.contextPath}/forgot-password" class="text-decoration-none small">Quên mật khẩu?</a>
                                </div>
                                <div class="input-group has-validation mt-2">
                                    <span class="input-group-text bg-light"><i class="bi bi-lock text-muted"></i></span>
                                    <input type="password" class="form-control" id="password" name="password" 
                                           placeholder="Nhập mật khẩu" required>
                                    <div class="invalid-feedback">
                                        Vui lòng nhập mật khẩu.
                                    </div>
                                </div>
                            </div>

                            <div class="mb-3 form-check">
                                <input type="checkbox" class="form-check-input" id="remember" name="remember" 
                                       ${not empty savedUsername ? 'checked' : ''}>
                                <label class="form-check-label text-muted small" for="remember">
                                    Ghi nhớ tên đăng nhập (Cookie 7 ngày)
                                </label>
                            </div>

                            <div class="d-grid mb-3 mt-4">
                                <button type="submit" class="btn btn-primary btn-lg fw-semibold shadow-sm">
                                    <i class="bi bi-box-arrow-in-right me-1"></i>Đăng nhập
                                </button>
                            </div>

                            <div class="text-center">
                                <span class="text-muted small">Chưa có tài khoản?</span>
                                <a href="${pageContext.request.contextPath}/register" class="text-decoration-none fw-semibold small ms-1">
                                    Đăng ký ngay
                                </a>
                            </div>

                            <hr class="my-4">
                            <div class="text-center">
                                <a href="${pageContext.request.contextPath}/login-session" class="btn btn-outline-secondary btn-sm">
                                    <i class="bi bi-person-badge me-1"></i>Chuyển sang đăng nhập với Session
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
