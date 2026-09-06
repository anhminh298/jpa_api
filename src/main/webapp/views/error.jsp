<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đã xảy ra lỗi</title>
</head>
<body>
    <div class="container py-5 text-center">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow border-0 rounded-4 p-4 p-md-5">
                    <div class="d-inline-flex align-items-center justify-content-center bg-danger-subtle text-danger rounded-circle mx-auto mb-4" style="width: 80px; height: 80px;">
                        <i class="bi bi-exclamation-triangle-fill fs-1"></i>
                    </div>
                    <h3 class="fw-bold text-dark mb-2">Đã xảy ra sự cố!</h3>
                    <p class="text-muted mb-4">
                        Trang bạn yêu cầu hiện không khả dụng hoặc có lỗi xảy ra trong quá trình xử lý yêu cầu.
                    </p>
                    <div class="d-flex justify-content-center gap-2">
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-primary px-4">
                            <i class="bi bi-house-door me-1"></i>Về Trang chủ
                        </a>
                        <a href="${pageContext.request.contextPath}/login-session" class="btn btn-outline-secondary px-4">
                            <i class="bi bi-box-arrow-in-right me-1"></i>Đăng nhập
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
