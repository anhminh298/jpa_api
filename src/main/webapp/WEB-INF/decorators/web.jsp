<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property="title"/> - IoTStar Shop</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Segoe+UI:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            background-color: #f8f9fa;
        }
        .navbar-brand {
            font-weight: 700;
            letter-spacing: 0.5px;
        }
        .main-content {
            flex: 1 0 auto;
        }
        footer {
            flex-shrink: 0;
            background-color: #212529;
            color: #adb5bd;
        }
        .nav-link.active {
            font-weight: 600;
        }
        .user-avatar-nav {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #fff;
        }
        .card-custom {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            transition: transform 0.2s ease-in-out;
        }
    </style>

    <!-- Custom Head from Child Pages -->
    <sitemesh:write property="head"/>
</head>
<body>
    <!-- Top Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow-sm">
        <div class="container">
            <a class="navbar-brand text-primary fw-bold" href="${pageContext.request.contextPath}/home">
                <i class="bi bi-shop me-2 text-warning"></i>IoTStar Shop
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" 
                    aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <!-- Main Nav Links -->
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/home">
                            <i class="bi bi-house-door me-1"></i>Trang chủ
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/products">
                            <i class="bi bi-box-seam me-1"></i>Sản phẩm
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/cart">
                            <i class="bi bi-cart3 me-1"></i>Giỏ hàng
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/orders">
                            <i class="bi bi-receipt me-1"></i>Đơn hàng
                        </a>
                    </li>

                    <!-- Admin Menu Dropdown (chỉ hiển thị với Admin) -->
                    <c:if test="${not empty sessionScope.user && sessionScope.user.admin}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle text-warning fw-semibold" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="bi bi-shield-lock me-1"></i>Quản trị (Admin)
                            </a>
                            <ul class="dropdown-menu dropdown-menu-dark shadow">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/dashboard"><i class="bi bi-speedometer2 me-2"></i>Dashboard</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><h6 class="dropdown-header text-uppercase text-info">Quản lý Sản phẩm</h6></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/products"><i class="bi bi-list-ul me-2"></i>Danh sách Sản phẩm</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/product/add"><i class="bi bi-plus-circle me-2"></i>Thêm Sản phẩm mới</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><h6 class="dropdown-header text-uppercase text-info">Quản lý Danh mục</h6></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/categories"><i class="bi bi-tags me-2"></i>Danh sách Category</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/category/add"><i class="bi bi-folder-plus me-2"></i>Thêm Category mới</a></li>
                            </ul>
                        </li>
                    </c:if>
                </ul>

                <!-- User Account Actions -->
                <ul class="navbar-nav ms-auto align-items-center">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle d-flex align-items-center text-white" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.user.image}">
                                            <img src="${pageContext.request.contextPath}/image?fname=users/${sessionScope.user.image}" 
                                                 alt="Avatar" class="user-avatar-nav me-2"
                                                 onerror="this.onerror=null; this.src='https://ui-avatars.com/api/?name=${sessionScope.user.fullname}&background=random';">
                                        </c:when>
                                        <c:otherwise>
                                            <i class="bi bi-person-circle fs-5 me-2 text-info"></i>
                                        </c:otherwise>
                                    </c:choose>
                                    <span>
                                        <c:out value="${not empty sessionScope.user.fullname ? sessionScope.user.fullname : sessionScope.user.username}"/>
                                    </span>
                                    <c:if test="${sessionScope.user.admin}">
                                        <span class="badge bg-danger ms-2">Admin</span>
                                    </c:if>
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end shadow">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile"><i class="bi bi-person-gear me-2"></i>Hồ sơ cá nhân</a></li>
                                    <c:if test="${sessionScope.user.admin}">
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/dashboard"><i class="bi bi-speedometer2 me-2"></i>Trang quản trị</a></li>
                                    </c:if>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i>Đăng xuất</a></li>
                                </ul>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="btn btn-outline-light btn-sm me-2" href="${pageContext.request.contextPath}/login-session">
                                    <i class="bi bi-box-arrow-in-right me-1"></i>Đăng nhập
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/register">
                                    <i class="bi bi-person-plus me-1"></i>Đăng ký
                                </a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Global Alert Notifications (Success / Error Messages) -->
    <div class="container mt-3">
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>${sessionScope.successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${sessionScope.errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>

        <c:if test="${not empty requestScope.message}">
            <div class="alert alert-info alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-info-circle-fill me-2"></i>${requestScope.message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <c:if test="${not empty requestScope.error}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-exclamation-circle-fill me-2"></i>${requestScope.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
    </div>

    <!-- Main Content Area Decorated by SiteMesh -->
    <main class="main-content py-4">
        <sitemesh:write property="body"/>
    </main>

    <!-- Footer -->
    <footer class="mt-auto py-4 border-top">
        <div class="container">
            <div class="row gy-4">
                <div class="col-lg-4 col-md-6">
                    <h5 class="text-white fw-bold"><i class="bi bi-shop me-2 text-warning"></i>IoTStar Web Application</h5>
                    <p class="small text-muted mb-2">
                        Ứng dụng Web Java Servlet, JSP, SiteMesh Decorator 3 kết hợp kiến trúc MVC 3-layer & JPA Hibernate.
                    </p>
                    <p class="small text-muted mb-0">
                        &copy; 2026 IoTStar. Môn học Lập trình Web. All rights reserved.
                    </p>
                </div>
                <div class="col-lg-2 col-md-6">
                    <h6 class="text-uppercase text-white fw-semibold mb-3">Liên kết nhanh</h6>
                    <ul class="list-unstyled small">
                        <li class="mb-2"><a href="${pageContext.request.contextPath}/home" class="text-muted text-decoration-none hover-white">Trang chủ</a></li>
                        <li class="mb-2"><a href="${pageContext.request.contextPath}/products" class="text-muted text-decoration-none hover-white">Sản phẩm</a></li>
                        <li class="mb-2"><a href="${pageContext.request.contextPath}/cart" class="text-muted text-decoration-none hover-white">Giỏ hàng</a></li>
                        <li><a href="${pageContext.request.contextPath}/orders" class="text-muted text-decoration-none hover-white">Đơn hàng</a></li>
                    </ul>
                </div>
                <div class="col-lg-3 col-md-6">
                    <h6 class="text-uppercase text-white fw-semibold mb-3">Quản trị viên</h6>
                    <ul class="list-unstyled small">
                        <li class="mb-2"><a href="${pageContext.request.contextPath}/dashboard" class="text-muted text-decoration-none hover-white">Bảng điều khiển</a></li>
                        <li class="mb-2"><a href="${pageContext.request.contextPath}/admin/categories" class="text-muted text-decoration-none hover-white">Quản lý Danh mục</a></li>
                        <li class="mb-2"><a href="${pageContext.request.contextPath}/admin/products" class="text-muted text-decoration-none hover-white">Quản lý Sản phẩm</a></li>
                        <li><a href="${pageContext.request.contextPath}/profile" class="text-muted text-decoration-none hover-white">Hồ sơ cá nhân</a></li>
                    </ul>
                </div>
                <div class="col-lg-3 col-md-6">
                    <h6 class="text-uppercase text-white fw-semibold mb-3">Hỗ trợ kỹ thuật</h6>
                    <p class="small text-muted mb-2"><i class="bi bi-envelope me-2"></i>support@iotstar.vn</p>
                    <p class="small text-muted mb-2"><i class="bi bi-telephone me-2"></i>(028) 3896 8641</p>
                    <p class="small text-muted"><i class="bi bi-geo-alt me-2"></i>Số 1 Võ Văn Ngân, Thủ Đức, TP.HCM</p>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap 5 Bundle JS (Popper included) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>

    <!-- Universal Bootstrap Form Validation Script -->
    <script>
        (() => {
            'use strict';
            // Lấy tất cả các form có class .needs-validation
            const forms = document.querySelectorAll('.needs-validation');
            Array.from(forms).forEach(form => {
                form.addEventListener('submit', event => {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        })();
    </script>
</body>
</html>
