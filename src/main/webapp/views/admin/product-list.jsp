<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quan ly san pham</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f4f4f4; }
        header { background-color: #333; color: white; padding: 1rem; text-align: center; }
        .container { max-width: 1200px; margin: 2rem auto; padding: 1rem; background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        table { width: 100%; border-collapse: collapse; margin-top: 1rem; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: center; }
        th { background-color: #f2f2f2; }
        td img { max-width: 60px; border-radius: 4px; }
        .btn { padding: 0.5rem 1rem; text-decoration: none; color: white; border-radius: 4px; display: inline-block; }
        .btn-primary { background-color: #0275d8; }
        .btn-primary:hover { background-color: #025aa5; }
        .btn-warning { background-color: #f0ad4e; }
        .btn-warning:hover { background-color: #ec971f; }
        .btn-danger { background-color: #d9534f; }
        .btn-danger:hover { background-color: #c9302c; }
        .btn-secondary { background-color: #6c757d; }
        .header-actions { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; }
    </style>
</head>
<body>
    <header>
        <h1>Admin - Quan ly san pham</h1>
    </header>
    
    <div class="container">
        <div class="header-actions">
            <h2>Danh sach san pham</h2>
            <div>
                <a href="${pageContext.request.contextPath}/admin/product/add" class="btn btn-primary">Them san pham moi</a>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">Trang chu</a>
            </div>
        </div>
        
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Anh</th>
                    <th>Ten SP</th>
                    <th>Gia</th>
                    <th>So luong</th>
                    <th>Danh muc</th>
                    <th>Ngay tao</th>
                    <th>Hanh dong</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="product" items="${listProduct}">
                    <tr>
                        <td>${product.id}</td>
                        <td>
                            <c:choose>
                                <c:when test="${product.image != null && product.image.startsWith('http')}">
                                    <img src="${product.image}" alt="${product.name}">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/image?fname=${product.image}" alt="${product.name}">
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${product.name}</td>
                        <td><fmt:formatNumber value="${product.price}" type="number" pattern="#,###"/> đ</td>
                        <td>${product.quantity}</td>
                        <td>${product.category.categoryname}</td>
                        <td>${product.createdDate}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/product/edit?id=${product.id}" class="btn btn-warning">Sua</a>
                            <a href="${pageContext.request.contextPath}/admin/product/delete?id=${product.id}" class="btn btn-danger" onclick="return confirm('Ban co chac muon xoa san pham nay?');">Xoa</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</body>
</html>
