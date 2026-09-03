<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Đổi mật khẩu</title>
<style>
    body { font-family: Arial, sans-serif; background-color: #f4f4f9; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
    .container { background-color: white; padding: 20px 30px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); width: 100%; max-width: 450px; }
    h2 { text-align: center; color: #333; }
    .info { text-align: center; color: #555; margin-bottom: 15px; }
    .form-group { margin-bottom: 15px; }
    label { display: block; margin-bottom: 5px; color: #666; }
    input[type="text"], input[type="password"] { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
    input[name="otp"] { font-size: 20px; letter-spacing: 3px; text-align: center; }
    button { width: 100%; padding: 10px; background-color: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
    button:hover { background-color: #0056b3; }
    .error { color: red; text-align: center; margin-bottom: 10px; }
</style>
</head>
<body>
    <div class="container">
        <h2>Đổi mật khẩu mới</h2>
        <div class="info">
            Đặt lại mật khẩu cho tài khoản: <b>${sessionScope.resetEmail}</b>
        </div>
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        <form action="${pageContext.request.contextPath}/reset-password" method="post">
            <div class="form-group">
                <label for="otp">Mã OTP (gửi qua email)</label>
                <input type="text" id="otp" name="otp" maxlength="6" required>
            </div>
            <div class="form-group">
                <label for="newPassword">Mật khẩu mới</label>
                <input type="password" id="newPassword" name="newPassword" required>
            </div>
            <div class="form-group">
                <label for="confirmPassword">Xác nhận mật khẩu mới</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required>
            </div>
            <button type="submit">Đổi mật khẩu</button>
        </form>
    </div>
</body>
</html>
