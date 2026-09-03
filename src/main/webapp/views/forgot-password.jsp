<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quên mật khẩu</title>
<style>
    body { font-family: Arial, sans-serif; background-color: #f4f4f9; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
    .container { background-color: white; padding: 20px 30px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); width: 100%; max-width: 400px; }
    h2 { text-align: center; color: #333; }
    .form-group { margin-bottom: 15px; }
    label { display: block; margin-bottom: 5px; color: #666; }
    input[type="email"] { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
    button { width: 100%; padding: 10px; background-color: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
    button:hover { background-color: #0056b3; }
    .error { color: red; text-align: center; margin-bottom: 10px; }
    .links { text-align: center; margin-top: 15px; }
    .links a { color: #007bff; text-decoration: none; }
    .links a:hover { text-decoration: underline; }
</style>
</head>
<body>
    <div class="container">
        <h2>Quên mật khẩu</h2>
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        <form action="${pageContext.request.contextPath}/forgot-password" method="post">
            <div class="form-group">
                <label for="email">Nhập email của bạn</label>
                <input type="email" id="email" name="email" required>
            </div>
            <button type="submit">Gửi mã OTP</button>
        </form>
        <div class="links">
            <a href="${pageContext.request.contextPath}/login-session">Quay lại đăng nhập</a>
        </div>
    </div>
</body>
</html>
