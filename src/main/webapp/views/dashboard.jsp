<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="vn.iotstar.entity.User" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/home?error=unauthorized");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
</head>
<body>
    <div class="container py-2">
        <!-- Header Banner -->
        <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <h2 class="fw-bold mb-0 text-dark">
                    <i class="bi bi-speedometer2 me-2 text-primary"></i>Bảng điều khiển Quản trị (Dashboard)
                </h2>
                <p class="text-muted mb-0 small">Tổng hợp dữ liệu thống kê và lối tắt quản trị hệ thống</p>
            </div>
            <div>
                <span class="badge bg-danger fs-6 px-3 py-2">
                    <i class="bi bi-shield-check me-1"></i>Admin: <%= user.getFullname() %>
                </span>
            </div>
        </div>

        <!-- KPI Cards -->
        <div class="row g-4 mb-4">
            <div class="col-md-4">
                <div class="card shadow-sm border-0 border-start border-primary border-4 rounded-3 h-100">
                    <div class="card-body p-4">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="text-muted fw-semibold small text-uppercase">Tổng Sản Phẩm</span>
                                <h2 class="fw-bold text-dark my-2">${totalProducts != null ? totalProducts : 0}</h2>
                                <span class="text-success small fw-medium"><i class="bi bi-arrow-up me-1"></i>Đang lưu hành</span>
                            </div>
                            <div class="bg-primary-subtle text-primary p-3 rounded-circle">
                                <i class="bi bi-box-seam fs-3"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card shadow-sm border-0 border-start border-success border-4 rounded-3 h-100">
                    <div class="card-body p-4">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="text-muted fw-semibold small text-uppercase">Tổng Danh Mục</span>
                                <h2 class="fw-bold text-dark my-2">${totalCategories != null ? totalCategories : 0}</h2>
                                <span class="text-success small fw-medium"><i class="bi bi-check-circle me-1"></i>Ngành hàng</span>
                            </div>
                            <div class="bg-success-subtle text-success p-3 rounded-circle">
                                <i class="bi bi-tags fs-3"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card shadow-sm border-0 border-start border-warning border-4 rounded-3 h-100">
                    <div class="card-body p-4">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="text-muted fw-semibold small text-uppercase">Hệ Thống</span>
                                <h2 class="fw-bold text-dark my-2">JPA / Hibernate</h2>
                                <span class="text-info small fw-medium"><i class="bi bi-cpu me-1"></i>Jakarta EE 10</span>
                            </div>
                            <div class="bg-warning-subtle text-warning p-3 rounded-circle">
                                <i class="bi bi-hdd-network fs-3"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions Card -->
        <div class="card shadow-sm border-0 rounded-3 mb-4">
            <div class="card-header bg-white py-3 border-bottom">
                <h5 class="card-title mb-0 fw-bold text-dark">
                    <i class="bi bi-lightning-charge-fill me-2 text-warning"></i>Thao tác Nhanh
                </h5>
            </div>
            <div class="card-body p-4">
                <div class="row g-3">
                    <div class="col-md-3">
                        <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-outline-primary w-100 py-3 d-flex flex-column align-items-center shadow-sm">
                            <i class="bi bi-box-seam fs-3 mb-1"></i>
                            <span class="fw-semibold">Quản lý Sản phẩm</span>
                        </a>
                    </div>
                    <div class="col-md-3">
                        <a href="${pageContext.request.contextPath}/admin/product/add" class="btn btn-outline-success w-100 py-3 d-flex flex-column align-items-center shadow-sm">
                            <i class="bi bi-plus-circle fs-3 mb-1"></i>
                            <span class="fw-semibold">Thêm Sản phẩm</span>
                        </a>
                    </div>
                    <div class="col-md-3">
                        <a href="${pageContext.request.contextPath}/admin/categories" class="btn btn-outline-info w-100 py-3 d-flex flex-column align-items-center shadow-sm">
                            <i class="bi bi-tags fs-3 mb-1"></i>
                            <span class="fw-semibold">Quản lý Category</span>
                        </a>
                    </div>
                    <div class="col-md-3">
                        <a href="${pageContext.request.contextPath}/admin/category/add" class="btn btn-outline-warning w-100 py-3 d-flex flex-column align-items-center shadow-sm text-dark">
                            <i class="bi bi-folder-plus fs-3 mb-1"></i>
                            <span class="fw-semibold">Thêm Category</span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
