<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="vn.iotstar.entity.User" %>
<html>
<head>
    <title>Dashboard</title>
</head>
<body>
    <h2>Dashboard</h2>

    <%
        // Lay User tu Session
        User user = (User) session.getAttribute("user");
        if (user != null) {
    %>
        <p>Xin chao, <strong><%= user.getFullname() %></strong>!</p>
        <p>Username: <%= user.getUsername() %></p>
        <p>Email: <%= user.getEmail() %></p>

        <!-- Hien thi thong tin Session -->
        <h3>Thong tin Session:</h3>
        <p>Session ID: <%= session.getId() %></p>
        <p>Thoi gian tao: <%= new java.util.Date(session.getCreationTime()) %></p>
        <p>Timeout: <%= session.getMaxInactiveInterval() / 60 %> phut</p>

        <!-- Hien thi thong tin Cookie -->
        <h3>Cookies hien co:</h3>
        <ul>
        <%
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie c : cookies) {
        %>
                <li><strong><%= c.getName() %></strong> = <%= c.getValue() %></li>
        <%
                }
            }
        %>
        </ul>

    <% } %>

    <hr>
    <p>
        <a href="<%= request.getContextPath() %>/home">Trang chu</a> |
        <a href="<%= request.getContextPath() %>/admin/products">Quan ly san pham (CRUD)</a> |
        <a href="<%= request.getContextPath() %>/admin/categories">Quan ly Category (JPA)</a> |
        <a href="<%= request.getContextPath() %>/logout">Dang xuat</a>
    </p>
</body>
</html>
