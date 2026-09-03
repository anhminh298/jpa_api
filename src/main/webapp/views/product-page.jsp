<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tat ca san pham</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f4f4f4; }
        header { background-color: #333; color: white; padding: 1rem; text-align: center; }
        nav { background-color: #444; display: flex; justify-content: center; padding: 0.5rem; }
        nav a { color: white; text-decoration: none; padding: 0.5rem 1rem; margin: 0 0.5rem; }
        nav a:hover { background-color: #555; }
        .container { max-width: 1200px; margin: 2rem auto; padding: 0 1rem; }
        .product-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.5rem; }
        .product-card { background: white; border: 1px solid #ddd; border-radius: 8px; padding: 1rem; text-align: center; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .product-card img { max-width: 100%; height: 250px; object-fit: cover; border-radius: 4px; }
        .product-price { color: #d9534f; font-weight: bold; font-size: 1.2rem; margin: 0.5rem 0; }
        .product-name { font-size: 1.1rem; color: #333; text-decoration: none; }
        .category-name { font-size: 0.9rem; color: #777; margin-bottom: 0.5rem; }
        .btn-detail { display: inline-block; margin-top: 1rem; padding: 0.5rem 1rem; background-color: #0275d8; color: white; text-decoration: none; border-radius: 4px; }
        .btn-detail:hover { background-color: #025aa5; }
        .pagination { display: flex; justify-content: center; margin-top: 2rem; }
        .pagination a { color: #333; padding: 0.5rem 1rem; text-decoration: none; border: 1px solid #ddd; margin: 0 0.25rem; }
        .pagination a.active { background-color: #0275d8; color: white; border-color: #0275d8; }
        .pagination a.disabled { color: #999; pointer-events: none; border-color: #eee; }
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
                    <a href="${pageContext.request.contextPath}/product/detail?id=${product.id}" class="btn-detail">Chi tiet</a>
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
