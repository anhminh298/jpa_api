<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login voi Cookie</title>
</head>
<body>
    <h2>Dang nhap (Cookie - Remember Me)</h2>

    <!-- Hien thi loi neu co -->
    <% if (request.getAttribute("error") != null) { %>
        <p style="color:red"><%= request.getAttribute("error") %></p>
    <% } %>

    <form method="post" action="login-cookie">
        <p>
            Username:
            <input type="text" name="username"
                   value="<%= request.getAttribute("savedUsername") != null ? request.getAttribute("savedUsername") : "" %>">
        </p>
        <p>
            Password:
            <input type="password" name="password">
        </p>
        <p>
            <input type="checkbox" name="remember"> Remember Me
            <br><small>(Tick vao de luu username bang Cookie, lan sau khong can nhap lai)</small>
        </p>
        <p>
            <input type="submit" value="Dang nhap">
        </p>
    </form>

    <p>
        <a href="${pageContext.request.contextPath}/register">Chua co tai khoan? Dang ky</a><br>
        <a href="${pageContext.request.contextPath}/forgot-password">Quen mat khau?</a>
    </p>

    <hr>
    <p><a href="login-session">Chuyen sang Login voi Session</a></p>
</body>
</html>
