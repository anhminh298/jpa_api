<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    // Kiem tra bat buoc dang nhap
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login-session");
        return;
    }
    // Neu truy cap truc tiep index.jsp ma chua qua HomeServlet thi chuyen huong qua /home de load data
    if (request.getAttribute("newestProducts") == null) {
        response.sendRedirect(request.getContextPath() + "/home");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>JPA API - Trang chủ</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; padding: 0; background-color: #f4f6f9; }
        header { background-color: #2c3e50; color: white; padding: 1.2rem 2rem; display: flex; justify-content: space-between; align-items: center; }
        header h1 { margin: 0; font-size: 1.5rem; }
        .user-greeting { font-size: 0.95rem; color: #ecf0f1; }
        .user-badge { display: inline-block; padding: 0.2rem 0.5rem; border-radius: 4px; font-size: 0.8rem; font-weight: bold; margin-left: 0.5rem; }
        .badge-admin { background-color: #e74c3c; color: white; }
        .badge-user { background-color: #27ae60; color: white; }
        nav { background-color: #34495e; display: flex; justify-content: center; padding: 0.7rem; flex-wrap: wrap; }
        nav a { color: #ecf0f1; text-decoration: none; padding: 0.5rem 1rem; margin: 0 0.3rem; border-radius: 4px; font-weight: 500; font-size: 0.95rem; }
        nav a:hover { background-color: #1abc9c; color: white; }
        nav a.admin-link { background-color: #c0392b; }
        nav a.admin-link:hover { background-color: #e74c3c; }
        .container { max-width: 1200px; margin: 2rem auto; padding: 0 1rem; }
        .alert-error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; padding: 12px 16px; border-radius: 6px; margin-bottom: 1.5rem; font-weight: 500; }
        .section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; }
        .section-header h2 { margin: 0; color: #2c3e50; }
        .product-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 1.5rem; }
        .product-card { background: white; border: 1px solid #e2e8f0; border-radius: 8px; padding: 1.2rem; text-align: center; box-shadow: 0 2px 8px rgba(0,0,0,0.06); display: flex; flex-direction: column; justify-content: space-between; }
        .product-card img { width: 100%; height: 190px; object-fit: cover; border-radius: 6px; }
        .product-name { font-size: 1.1rem; color: #2c3e50; text-decoration: none; font-weight: 600; margin: 0.8rem 0 0.3rem; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
        .product-price { color: #e74c3c; font-weight: bold; font-size: 1.25rem; margin: 0.4rem 0; }
        .category-tag { font-size: 0.85rem; color: #7f8c8d; margin-bottom: 0.8rem; }
        .btn-group { display: flex; justify-content: center; gap: 0.5rem; margin-top: 0.8rem; }
        .btn-detail { display: inline-block; padding: 0.5rem 1rem; background-color: #3498db; color: white; text-decoration: none; border-radius: 4px; font-weight: 500; font-size: 0.9rem; }
        .btn-detail:hover { background-color: #2980b9; }
        .btn-edit { display: inline-block; padding: 0.5rem 0.8rem; background-color: #f39c12; color: white; text-decoration: none; border-radius: 4px; font-weight: 500; font-size: 0.9rem; }
        .btn-edit:hover { background-color: #d68910; }
        footer { background-color: #2c3e50; color: white; text-align: center; padding: 1.2rem; margin-top: 3rem; }
    </style>
</head>
<body>
    <header>
        <h1>JPA API - Cửa hàng trực tuyến</h1>
        <div class="user-greeting">
            Xin chào, <strong>${sessionScope.user.fullname}</strong>
            <c:choose>
                <c:when test="${sessionScope.user.admin}">
                    <span class="user-badge badge-admin">Admin</span>
                </c:when>
                <c:otherwise>
                    <span class="user-badge badge-user">Khách hàng</span>
                </c:otherwise>
            </c:choose>
        </div>
    </header>
    
    <nav>
        <a href="${pageContext.request.contextPath}/home">🏠 Trang chủ</a>
        <a href="${pageContext.request.contextPath}/product">📦 Tất cả sản phẩm</a>
        <a href="${pageContext.request.contextPath}/profile">👤 Thông tin cá nhân</a>
        <a href="${pageContext.request.contextPath}/dashboard">📊 Dashboard</a>
        
        <%-- Chỉ Admin mới được hiển thị các mục Quản lý --%>
        <c:if test="${sessionScope.user.admin}">
            <a href="${pageContext.request.contextPath}/admin/products" class="admin-link">⚙️ Quản lý Product</a>
            <a href="${pageContext.request.contextPath}/admin/categories" class="admin-link">📁 Quản lý Category</a>
        </c:if>
        
        <a href="${pageContext.request.contextPath}/logout">🚪 Đăng xuất</a>
    </nav>
    
    <div class="container">
        <%-- Cảnh báo nếu truy cập trang trái phép --%>
        <c:if test="${param.error == 'unauthorized'}">
            <div class="alert-error">
                ⚠️ <strong>Truy cập bị từ chối:</strong> Bạn không có quyền truy cập vào khu vực quản trị dành cho Admin!
            </div>
        </c:if>

        <div class="section-header">
            <h2>Sản phẩm mới nhất</h2>
            <c:if test="${sessionScope.user.admin}">
                <a href="${pageContext.request.contextPath}/admin/product/add" class="btn-detail" style="background-color: #27ae60;">+ Thêm sản phẩm mới</a>
            </c:if>
        </div>

        <c:choose>
            <c:when test="${empty newestProducts}">
                <p>Hiện chưa có sản phẩm nào trong hệ thống.</p>
            </c:when>
            <c:otherwise>
                <div class="product-grid">
                    <c:forEach var="product" items="${newestProducts}">
                        <div class="product-card">
                            <div>
                                <a href="${pageContext.request.contextPath}/product/detail?id=${product.id}">
                                    <c:choose>
                                        <c:when test="${product.image != null && product.image.startsWith('http')}">
                                            <img src="${product.image}" alt="${product.name}">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/image?fname=${product.image}" alt="${product.name}">
                                        </c:otherwise>
                                    </c:choose>
                                </a>
                                <div class="category-tag">${product.category.categoryname}</div>
                                <a href="${pageContext.request.contextPath}/product/detail?id=${product.id}" class="product-name">${product.name}</a>
                                <p class="product-price">
                                    <fmt:formatNumber value="${product.price}" type="number" pattern="#,###"/> đ
                                </p>
                            </div>
                            <div class="btn-group">
                                <a href="${pageContext.request.contextPath}/product/detail?id=${product.id}" class="btn-detail">Xem chi tiết</a>
                                <%-- Chỉ Admin mới có nút Sửa sản phẩm --%>
                                <c:if test="${sessionScope.user.admin}">
                                    <a href="${pageContext.request.contextPath}/admin/product/edit?id=${product.id}" class="btn-edit">✏️ Sửa</a>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <footer>
        <p>&copy; 2026 JPA API E-Commerce - Dự án Lập trình Web</p>
    </footer>
</body>
</html>
