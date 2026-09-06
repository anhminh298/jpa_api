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
    <title>Danh sách sản phẩm - JPA API</title>
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
        .product-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 1.5rem; }
        .product-card { background: white; border: 1px solid #e2e8f0; border-radius: 8px; padding: 1.2rem; text-align: center; box-shadow: 0 2px 8px rgba(0,0,0,0.06); display: flex; flex-direction: column; justify-content: space-between; }
        .product-card img { width: 100%; height: 200px; object-fit: cover; border-radius: 6px; }
        .product-price { color: #e74c3c; font-weight: bold; font-size: 1.25rem; margin: 0.4rem 0; }
        .product-name { font-size: 1.1rem; color: #2c3e50; text-decoration: none; font-weight: 600; margin: 0.8rem 0 0.3rem; }
        .category-name { font-size: 0.85rem; color: #7f8c8d; margin-bottom: 0.5rem; }
        .btn-group { display: flex; justify-content: center; gap: 0.5rem; margin-top: 0.8rem; }
        .btn-detail { display: inline-block; padding: 0.5rem 1rem; background-color: #3498db; color: white; text-decoration: none; border-radius: 4px; font-weight: 500; font-size: 0.9rem; }
        .btn-detail:hover { background-color: #2980b9; }
        .btn-edit { display: inline-block; padding: 0.5rem 0.8rem; background-color: #f39c12; color: white; text-decoration: none; border-radius: 4px; font-weight: 500; font-size: 0.9rem; }
        .btn-edit:hover { background-color: #d68910; }
        .pagination { display: flex; justify-content: center; margin-top: 2.5rem; }
        .pagination a { color: #2c3e50; padding: 0.5rem 1rem; text-decoration: none; border: 1px solid #dee2e6; margin: 0 0.25rem; border-radius: 4px; font-weight: 500; }
        .pagination a.active { background-color: #3498db; color: white; border-color: #3498db; }
        .pagination a.disabled { color: #95a5a6; pointer-events: none; border-color: #eee; }
        footer { background-color: #2c3e50; color: white; text-align: center; padding: 1.2rem; margin-top: 3rem; }
    </style>
</head>
<body>
    <header>
        <h1>JPA API - Tất cả sản phẩm</h1>
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
        <h2>Tat ca san pham (${totalProducts} san pham)</h2>
        <div class="product-grid">
            <c:forEach var="product" items="${products}">
                <div class="product-card">
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
                    <p class="category-name">${product.category.categoryname}</p>
                    <a href="${pageContext.request.contextPath}/product/detail?id=${product.id}" class="product-name">${product.name}</a>
                    <p class="product-price">
                        <fmt:formatNumber value="${product.price}" type="number" pattern="#,###"/> đ
                    </p>
                    <div class="btn-group">
                        <a href="${pageContext.request.contextPath}/product/detail?id=${product.id}" class="btn-detail">Xem chi tiết</a>
                        <c:if test="${sessionScope.user.admin}">
                            <a href="${pageContext.request.contextPath}/admin/product/edit?id=${product.id}" class="btn-edit">✏️ Sửa</a>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>
        
        <div class="pagination">
            <a href="${pageContext.request.contextPath}/product?page=${currentPage - 1}" class="${currentPage == 1 ? 'disabled' : ''}">Previous</a>
            <c:forEach begin="1" end="${totalPages}" var="i">
                <a href="${pageContext.request.contextPath}/product?page=${i}" class="${currentPage == i ? 'active' : ''}">${i}</a>
            </c:forEach>
            <a href="${pageContext.request.contextPath}/product?page=${currentPage + 1}" class="${currentPage == totalPages ? 'disabled' : ''}">Next</a>
        </div>
    </div>
    
    <footer>
        <p>&copy; 2026 JPA API E-Commerce</p>
    </footer>
</body>
</html>
