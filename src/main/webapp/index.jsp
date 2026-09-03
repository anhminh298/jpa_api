<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>JPA API - Trang chu</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f4f4f4; }
        header { background-color: #333; color: white; padding: 1rem; text-align: center; }
        nav { background-color: #444; display: flex; justify-content: center; padding: 0.5rem; }
        nav a { color: white; text-decoration: none; padding: 0.5rem 1rem; margin: 0 0.5rem; }
        nav a:hover { background-color: #555; }
        .container { max-width: 1200px; margin: 2rem auto; padding: 0 1rem; }
        .product-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1.5rem; }
        .product-card { background: white; border: 1px solid #ddd; border-radius: 8px; padding: 1rem; text-align: center; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .product-card img { max-width: 100%; height: 200px; object-fit: cover; border-radius: 4px; }
        .product-price { color: #d9534f; font-weight: bold; font-size: 1.2rem; margin: 0.5rem 0; }
        .product-name { font-size: 1.1rem; color: #333; text-decoration: none; }
        .btn-detail { display: inline-block; margin-top: 1rem; padding: 0.5rem 1rem; background-color: #0275d8; color: white; text-decoration: none; border-radius: 4px; }
        .btn-detail:hover { background-color: #025aa5; }
        footer { background-color: #333; color: white; text-align: center; padding: 1rem; margin-top: 2rem; }
    </style>
</head>
<body>
    <header>
        <h1>JPA API - Trang chu</h1>
    </header>
    
    <nav>
        <a href="${pageContext.request.contextPath}/home">Trang chu</a>
        <a href="${pageContext.request.contextPath}/product">San pham</a>
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
                <a href="${pageContext.request.contextPath}/admin/categories">Quan ly Category</a>
                <a href="${pageContext.request.contextPath}/admin/products">Quan ly Product</a>
                <a href="${pageContext.request.contextPath}/logout">Dang xuat</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login-session">Dang nhap</a>
                <a href="${pageContext.request.contextPath}/register">Dang ky</a>
            </c:otherwise>
        </c:choose>
    </nav>
    
    <div class="container">
        <h2>San pham moi nhat</h2>
        <c:choose>
            <c:when test="${empty newestProducts}">
                <p>Chua co san pham nao</p>
            </c:when>
            <c:otherwise>
                <div class="product-grid">
                    <c:forEach var="product" items="${newestProducts}">
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
                            <a href="${pageContext.request.contextPath}/product/detail?id=${product.id}" class="product-name">${product.name}</a>
                            <p class="product-price">
                                <fmt:formatNumber value="${product.price}" type="number" pattern="#,###"/> đ
                            </p>
                            <a href="${pageContext.request.contextPath}/product/detail?id=${product.id}" class="btn-detail">Chi tiet</a>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <footer>
        <p>&copy; 2026 JPA API E-Commerce</p>
    </footer>
</body>
</html>
