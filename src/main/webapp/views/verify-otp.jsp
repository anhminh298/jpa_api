<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Xác nhận mã OTP</title>
</head>
<body>
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card shadow border-0 rounded-4 text-center">
                    <div class="card-body p-4 p-md-5">
                        <div class="d-inline-flex align-items-center justify-content-center bg-success-subtle text-success rounded-circle mb-3" style="width: 60px; height: 60px;">
                            <i class="bi bi-shield-check fs-2"></i>
                        </div>
                        <h3 class="fw-bold text-dark mb-2">Xác thực mã OTP</h3>
                        <p class="text-muted small mb-4">
                            Mã xác nhận 6 số đã được gửi tới email:<br>
                            <strong class="text-primary">${sessionScope.otpEmail}</strong>
                        </p>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show small" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/verify-otp" method="post" 
                              class="needs-validation mb-3" novalidate>
                            
                            <div class="mb-4">
                                <label for="otp" class="form-label fw-semibold">Mã OTP (6 chữ số)</label>
                                <input type="text" class="form-control form-control-lg text-center fw-bold fs-3" 
                                       id="otp" name="otp" value="${otp}" 
                                       placeholder="------" maxlength="6" pattern="^[0-9]{6}$" 
                                       style="letter-spacing: 8px;" required autofocus>
                                <div class="invalid-feedback">
                                    Vui lòng nhập đúng mã OTP gồm 6 chữ số.
                                </div>
                            </div>

                            <div class="d-grid mb-3">
                                <button type="submit" class="btn btn-success btn-lg fw-semibold shadow-sm">
                                    <i class="bi bi-check-circle me-1"></i>Xác nhận kích hoạt
                                </button>
                            </div>
                        </form>

                        <form action="${pageContext.request.contextPath}/verify-otp" method="post" class="d-inline-block">
                            <input type="hidden" name="action" value="resend">
                            <button type="submit" class="btn btn-link text-decoration-none text-muted small">
                                <i class="bi bi-arrow-clockwise me-1"></i>Chưa nhận được mã? Gửi lại OTP
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
