<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="vn.iotstar.entity.User" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login-session");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bảng điều khiển - Dashboard</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f6f9; margin: 0; padding: 0; }
        header { background-color: #2c3e50; color: white; padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center; }
        header h1 { margin: 0; font-size: 1.4rem; }
        nav a { color: #ecf0f1; text-decoration: none; margin-left: 1.2rem; font-size: 0.95rem; font-weight: 500; }
        nav a:hover { color: #3498db; }
        .container { max-width: 800px; margin: 2.5rem auto; padding: 0 1rem; }
        .card { background: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.08); padding: 2rem; }
        .welcome-title { color: #2c3e50; margin-top: 0; }
        .badge { display: inline-block; padding: 0.25rem 0.6rem; border-radius: 4px; font-size: 0.85rem; font-weight: bold; }
        .badge-admin { background-color: #e74c3c; color: white; }
        .badge-user { background-color: #3498db; color: white; }
        .info-group { margin: 1.5rem 0; line-height: 1.8; }
        .actions-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; margin-top: 1.5rem; }
        .action-btn { display: block; text-align: center; padding: 1rem; background-color: #f8f9fa; border: 1px solid #dee2e6; border-radius: 6px; color: #2c3e50; text-decoration: none; font-weight: 600; transition: all 0.2s; }
        .action-btn:hover { background-color: #3498db; color: white; border-color: #3498db; }
        .action-btn.admin-action { border-color: #f5c6cb; background-color: #fff8f8; color: #c0392b; }
        .action-btn.admin-action:hover { background-color: #e74c3c; color: white; border-color: #e74c3c; }
    </style>
</head>
<body>
    <header>
        <h1>JPA API - Dashboard</h1>
        <nav>
            <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
            <a href="${pageContext.request.contextPath}/product">Sản phẩm</a>
            <a href="${pageContext.request.contextPath}/profile">Profile</a>
            <c:if test="${sessionScope.user.admin}">
                <a href="${pageContext.request.contextPath}/admin/products">Quản lý SP</a>
                <a href="${pageContext.request.contextPath}/admin/categories">Quản lý Danh mục</a>
            </c:if>
            <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
        </nav>
    </header>

    <div class="container">
        <div class="card">
            <h2 class="welcome-title">Xin chào, <%= user.getFullname() %>!</h2>
            
            <p>
                Vai trò: 
                <% if (user.isAdmin()) { %>
                    <span class="badge badge-admin">Quản trị viên (Admin)</span>
                <% } else { %>
                    <span class="badge badge-user">Người dùng (Khách hàng)</span>
                <% } %>
            </p>

            <div class="info-group">
                <p><strong>Tên đăng nhập:</strong> <%= user.getUsername() %></p>
                <p><strong>Email:</strong> <%= user.getEmail() %></p>
                <% if (user.getPhone() != null && !user.getPhone().isEmpty()) { %>
                    <p><strong>Số điện thoại:</strong> <%= user.getPhone() %></p>
                <% } %>
            </div>

            <hr style="border: 0; border-top: 1px solid #eee; margin: 1.5rem 0;">

            <h3>Lựa chọn chức năng:</h3>
            <div class="actions-grid">
                <a href="${pageContext.request.contextPath}/home" class="action-btn">🏠 Trang chủ mua sắm</a>
                <a href="${pageContext.request.contextPath}/product" class="action-btn">📦 Danh sách sản phẩm</a>
                <a href="${pageContext.request.contextPath}/profile" class="action-btn">👤 Quản lý thông tin cá nhân</a>
                
                <c:if test="${sessionScope.user.admin}">
                    <a href="${pageContext.request.contextPath}/admin/products" class="action-btn admin-action">⚙️ Quản lý sản phẩm (CRUD)</a>
                    <a href="${pageContext.request.contextPath}/admin/categories" class="action-btn admin-action">📁 Quản lý danh mục</a>
                </c:if>
            </div>
        </div>
    </div>
</body>
</html>
