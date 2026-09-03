<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiet san pham - ${product.name}</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f4f4f4; }
        header { background-color: #333; color: white; padding: 1rem; text-align: center; }
        nav { background-color: #444; display: flex; justify-content: center; padding: 0.5rem; }
        nav a { color: white; text-decoration: none; padding: 0.5rem 1rem; margin: 0 0.5rem; }
        nav a:hover { background-color: #555; }
        .container { max-width: 1000px; margin: 2rem auto; padding: 2rem; background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .product-detail { display: flex; gap: 2rem; }
        .product-image { flex: 1; text-align: center; }
        .product-image img { max-width: 100%; border-radius: 8px; }
        .product-info { flex: 1; }
        .product-name { font-size: 2rem; margin-top: 0; color: #333; }
        .product-price { color: #d9534f; font-weight: bold; font-size: 2rem; margin: 1rem 0; }
        .category-name { font-size: 1.1rem; color: #777; margin-bottom: 1rem; }
        .product-quantity { font-size: 1.1rem; margin-bottom: 1rem; }
        .product-desc { line-height: 1.6; color: #555; }
        .btn-back { display: inline-block; margin-top: 2rem; padding: 0.5rem 1.5rem; background-color: #6c757d; color: white; text-decoration: none; border-radius: 4px; }
        .btn-back:hover { background-color: #5a6268; }
        footer { background-color: #333; color: white; text-align: center; padding: 1rem; margin-top: 2rem; }
    </style>
</head>
<body>
    <header>
        <h1>JPA API - E-commerce</h1>
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
                <p class="category-name">Danh muc: ${product.category.categoryname}</p>
                <p class="product-quantity">So luong: ${product.quantity}</p>
                <div class="product-desc">
                    <strong>Mo ta:</strong><br>
                    ${product.description}
                </div>
                <a href="${pageContext.request.contextPath}/product" class="btn-back">Quay lai</a>
            </div>
        </div>
    </div>
    
    <footer>
        <p>&copy; 2026 JPA API E-Commerce</p>
    </footer>
</body>
</html>
