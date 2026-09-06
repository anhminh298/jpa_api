<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login-session");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết sản phẩm - ${product.name}</title>
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
        .container { max-width: 1000px; margin: 2rem auto; padding: 2rem; background: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.08); }
        .product-detail { display: flex; gap: 2.5rem; flex-wrap: wrap; }
        .product-image { flex: 1; min-width: 300px; text-align: center; }
        .product-image img { max-width: 100%; border-radius: 8px; border: 1px solid #eee; }
        .product-info { flex: 1.2; min-width: 300px; }
        .product-name { font-size: 1.8rem; margin-top: 0; color: #2c3e50; font-weight: 600; }
        .product-price { color: #e74c3c; font-weight: bold; font-size: 1.8rem; margin: 0.8rem 0; }
        .category-name { font-size: 1rem; color: #7f8c8d; margin-bottom: 0.8rem; }
        .product-quantity { font-size: 1rem; color: #34495e; margin-bottom: 1rem; }
        .product-desc { line-height: 1.7; color: #555; background: #fdfdfd; padding: 1rem; border-radius: 6px; border: 1px solid #f0f0f0; margin-bottom: 1.5rem; }
        .btn-group { display: flex; gap: 1rem; align-items: center; }
        .btn-back { display: inline-block; padding: 0.6rem 1.4rem; background-color: #95a5a6; color: white; text-decoration: none; border-radius: 4px; font-weight: 500; }
        .btn-back:hover { background-color: #7f8c8d; }
        .btn-edit { display: inline-block; padding: 0.6rem 1.4rem; background-color: #f39c12; color: white; text-decoration: none; border-radius: 4px; font-weight: 500; }
        .btn-edit:hover { background-color: #d68910; }
        footer { background-color: #2c3e50; color: white; text-align: center; padding: 1.2rem; margin-top: 3rem; }
    </style>
</head>
<body>
    <header>
        <h1>JPA API - Chi tiết sản phẩm</h1>
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
        <c:if test="${sessionScope.user.admin}">
            <a href="${pageContext.request.contextPath}/admin/products" class="admin-link">⚙️ Quản lý Product</a>
            <a href="${pageContext.request.contextPath}/admin/categories" class="admin-link">📁 Quản lý Category</a>
        </c:if>
        <a href="${pageContext.request.contextPath}/logout">🚪 Đăng xuất</a>
    </nav>
    
    <div class="container">
        <div class="product-detail">
            <div class="product-image">
                <c:choose>
                    <c:when test="${product.image != null && product.image.startsWith('http')}">
                        <img src="${product.image}" alt="${product.name}">
                    </c:when>
                    <c:otherwise>
                        <img src="${pageContext.request.contextPath}/image?fname=${product.image}" alt="${product.name}">
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="product-info">
                <h2 class="product-name">${product.name}</h2>
                <p class="product-price">
                    <fmt:formatNumber value="${product.price}" type="number" pattern="#,###"/> đ
                </p>
                <p class="category-name">📁 Danh mục: <strong>${product.category.categoryname}</strong></p>
                <p class="product-quantity">Số lượng tồn kho: <strong>${product.quantity}</strong></p>
                <div class="product-desc">
                    <strong>Mô tả sản phẩm:</strong><br>
                    ${product.description != null && !product.description.isEmpty() ? product.description : "Đang cập nhật mô tả..."}
                </div>
                <div class="btn-group">
                    <a href="${pageContext.request.contextPath}/product" class="btn-back">⬅️ Quay lại danh sách</a>
                    <%-- Chỉ Admin mới được hiển thị nút Sửa sản phẩm --%>
                    <c:if test="${sessionScope.user.admin}">
                        <a href="${pageContext.request.contextPath}/admin/product/edit?id=${product.id}" class="btn-edit">✏️ Sửa sản phẩm này</a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
    
    <footer>
        <p>&copy; 2026 JPA API E-Commerce - Dự án Lập trình Web</p>
    </footer>
</body>
</html>
