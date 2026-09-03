<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Xác nhận OTP</title>
<style>
    body { font-family: Arial, sans-serif; background-color: #f4f4f9; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
    .container { background-color: white; padding: 20px 30px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); width: 100%; max-width: 400px; text-align: center; }
    h2 { color: #333; }
    .form-group { margin-bottom: 20px; }
    input[type="text"] { width: 100%; padding: 15px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; font-size: 24px; text-align: center; letter-spacing: 5px; }
    button { width: 100%; padding: 10px; background-color: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; margin-bottom: 10px;}
    button:hover { background-color: #218838; }
    .btn-resend { background-color: #6c757d; }
    .btn-resend:hover { background-color: #5a6268; }
    .error { color: red; margin-bottom: 10px; }
    .success { color: green; margin-bottom: 10px; }
    .info { color: #555; margin-bottom: 15px; }
</style>
</head>
<body>
    <div class="container">
        <h2>Xác nhận mã OTP</h2>
        <div class="info">
            Mã OTP đã được gửi đến email: <b>${sessionScope.otpEmail}</b>
        </div>
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        <c:if test="${not empty message}">
            <div class="success">${message}</div>
        </c:if>
        <form action="${pageContext.request.contextPath}/verify-otp" method="post">
            <div class="form-group">
                <input type="text" name="otp" maxlength="6" placeholder="Nhập mã OTP 6 số" required>
            </div>
            <button type="submit">Xác nhận</button>
        </form>
        <form action="${pageContext.request.contextPath}/verify-otp" method="post">
            <input type="hidden" name="action" value="resend">
            <button type="submit" class="btn-resend">Gửi lại OTP</button>
        </form>
    </div>
</body>
</html>
