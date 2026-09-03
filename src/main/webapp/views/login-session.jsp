<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Login voi Session</title>
</head>
<body>
    <h2>Dang nhap (Session)</h2>

    <% if (request.getAttribute("error") != null) { %>
        <p style="color:red"><%= request.getAttribute("error") %></p>
    <% } %>
    
    <c:if test="${not empty sessionScope.successMessage}">
        <p style="color:green">${sessionScope.successMessage}</p>
        <c:remove var="successMessage" scope="session"/>
    </c:if>

    <form method="post" action="login-session">
        <p>
            Username:
            <input type="text" name="username">
        </p>
        <p>
            Password:
            <input type="password" name="password">
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
    <p><a href="login-cookie">Chuyen sang Login voi Cookie</a></p>
    <p><small>Tai khoan mau: admin / admin123</small></p>
</body>
</html>
