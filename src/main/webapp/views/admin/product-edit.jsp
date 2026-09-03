<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sua san pham</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f4f4f4; }
        header { background-color: #333; color: white; padding: 1rem; text-align: center; }
        .container { max-width: 600px; margin: 2rem auto; padding: 2rem; background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .form-group { margin-bottom: 1rem; }
        .form-group label { display: block; margin-bottom: 0.5rem; font-weight: bold; }
        .form-control { width: 100%; padding: 0.5rem; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        textarea.form-control { height: 100px; resize: vertical; }
        .btn { padding: 0.5rem 1.5rem; text-decoration: none; color: white; border-radius: 4px; display: inline-block; border: none; cursor: pointer; }
        .btn-primary { background-color: #0275d8; }
        .btn-primary:hover { background-color: #025aa5; }
        .btn-secondary { background-color: #6c757d; }
        .btn-secondary:hover { background-color: #5a6268; }
        .actions { margin-top: 1.5rem; display: flex; gap: 1rem; }
        .current-img { max-width: 150px; margin-top: 0.5rem; border-radius: 4px; display: block; }
    </style>
</head>
<body>
    <header>
        <h1>Admin - Sua san pham</h1>
    </header>
    
    <div class="container">
        <form action="${pageContext.request.contextPath}/admin/product/update" method="POST" enctype="multipart/form-data">
            <input type="hidden" name="id" value="${product.id}">
            
            <div class="form-group">
                <label for="name">Ten san pham:</label>
                <input type="text" id="name" name="name" value="${product.name}" class="form-control" required>
            </div>
            
            <div class="form-group">
                <label for="price">Gia:</label>
                <input type="number" id="price" name="price" value="${product.price}" class="form-control" required>
            </div>
            
            <div class="form-group">
                <label for="quantity">So luong:</label>
                <input type="number" id="quantity" name="quantity" value="${product.quantity}" class="form-control" required>
            </div>
            
            <div class="form-group">
                <label for="description">Mo ta:</label>
                <textarea id="description" name="description" class="form-control">${product.description}</textarea>
            </div>
            
            <div class="form-group">
                <label for="categoryId">Danh muc:</label>
                <select id="categoryId" name="categoryId" class="form-control" required>
                    <c:forEach var="category" items="${categories}">
                        <option value="${category.categoryid}" ${category.categoryid == product.category.categoryid ? 'selected' : ''}>${category.categoryname}</option>
                    </c:forEach>
                </select>
            </div>
            
            <div class="form-group">
                <label>Anh hien tai:</label>
                <c:choose>
                    <c:when test="${product.image != null && product.image.startsWith('http')}">
                        <img src="${product.image}" alt="${product.name}" class="current-img">
                    </c:when>
                    <c:when test="${product.image != null && product.image != ''}">
                        <img src="${pageContext.request.contextPath}/image?fname=${product.image}" alt="${product.name}" class="current-img">
                    </c:when>
                    <c:otherwise>
                        <p>Chua co anh</p>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="form-group">
                <label for="imageUrl">URL Anh moi (Optional):</label>
                <input type="text" id="imageUrl" name="imageUrl" class="form-control">
            </div>
            
            <div class="form-group">
                <label for="imageFile">Hoac Upload Anh moi:</label>
                <input type="file" id="imageFile" name="imageFile" class="form-control">
            </div>
            
            <div class="actions">
                <button type="submit" class="btn btn-primary">Cap nhat san pham</button>
                <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-secondary">Quay lai</a>
            </div>
        </form>
    </div>
</body>
</html>
