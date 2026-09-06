<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="vn.iotstar.entity.User" %>
<%
    // Lay user tu request attribute (duoc set boi ProfileServlet)
    User profileUser = (User) request.getAttribute("profileUser");
    if (profileUser == null) {
        response.sendRedirect(request.getContextPath() + "/login-session");
        return;
    }
    
    String error = (String) request.getAttribute("error");
    String success = request.getParameter("success");
%>
<html>
<head>
    <title>Profile - <%= profileUser.getFullname() %></title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5;
            color: #333;
        }
        .container {
            max-width: 700px;
            margin: 40px auto;
            padding: 0 20px;
        }
        .profile-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.1);
            padding: 40px;
        }
        .profile-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .profile-header h2 {
            font-size: 24px;
            color: #2c3e50;
            margin-bottom: 5px;
        }
        .profile-header p {
            color: #7f8c8d;
            font-size: 14px;
        }
        .avatar-section {
            text-align: center;
            margin-bottom: 30px;
        }
        .avatar-img {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #e0e0e0;
            background-color: #f0f0f0;
        }
        .avatar-placeholder {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background-color: #3498db;
            color: #fff;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 48px;
            font-weight: bold;
            border: 4px solid #e0e0e0;
        }
        .alert {
            padding: 12px 16px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
            color: #2c3e50;
            font-size: 14px;
        }
        .form-group input[type="text"],
        .form-group input[type="email"],
        .form-group input[type="tel"] {
            width: 100%;
            padding: 10px 14px;
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            font-size: 15px;
            transition: border-color 0.2s;
        }
        .form-group input:focus {
            outline: none;
            border-color: #3498db;
        }
        .form-group input[readonly] {
            background-color: #f8f9fa;
            color: #6c757d;
            cursor: not-allowed;
        }
        .form-group input[type="file"] {
            padding: 8px;
            font-size: 14px;
        }
        .form-group .hint {
            font-size: 12px;
            color: #95a5a6;
            margin-top: 4px;
        }
        .btn {
            display: inline-block;
            padding: 10px 24px;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.2s;
            text-decoration: none;
        }
        .btn-primary {
            background-color: #3498db;
            color: #fff;
        }
        .btn-primary:hover {
            background-color: #2980b9;
        }
        .btn-secondary {
            background-color: #95a5a6;
            color: #fff;
        }
        .btn-secondary:hover {
            background-color: #7f8c8d;
        }
        .btn-group {
            display: flex;
            gap: 12px;
            margin-top: 10px;
        }
        .nav-links {
            text-align: center;
            margin-top: 20px;
        }
        .nav-links a {
            color: #3498db;
            text-decoration: none;
            margin: 0 10px;
            font-size: 14px;
        }
        .nav-links a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="profile-card">

        <div class="profile-header">
            <h2>Thong tin ca nhan</h2>
            <p>Cap nhat thong tin profile cua ban</p>
        </div>

        <!-- Avatar hien thi -->
        <div class="avatar-section">
            <% if (profileUser.getImage() != null && !profileUser.getImage().isEmpty()) { %>
                <img src="<%= request.getContextPath() %>/image?fname=users/<%= profileUser.getImage() %>"
                     alt="Avatar" class="avatar-img" />
            <% } else { %>
                <div class="avatar-placeholder">
                    <%= profileUser.getFullname() != null && !profileUser.getFullname().isEmpty()
                        ? profileUser.getFullname().substring(0, 1).toUpperCase() : "?" %>
                </div>
            <% } %>
        </div>

        <!-- Thong bao -->
        <% if ("1".equals(success)) { %>
            <div class="alert alert-success">
                Cap nhat profile thanh cong!
            </div>
        <% } %>

        <% if (error != null && !error.isEmpty()) { %>
            <div class="alert alert-error">
                <%= error %>
            </div>
        <% } %>

        <!-- Form cap nhat profile -->
        <form method="post" 
              action="<%= request.getContextPath() %>/profile"
              enctype="multipart/form-data">

            <!-- Email (readonly - khong cho sua) -->
            <div class="form-group">
                <label>Email</label>
                <input type="email" value="<%= profileUser.getEmail() != null ? profileUser.getEmail() : "" %>" 
                       readonly />
                <p class="hint">Email khong the thay doi.</p>
            </div>

            <!-- Fullname -->
            <div class="form-group">
                <label>Ho va ten *</label>
                <input type="text" name="fullname" 
                       value="<%= profileUser.getFullname() != null ? profileUser.getFullname() : "" %>" 
                       required />
            </div>

            <!-- Phone -->
            <div class="form-group">
                <label>So dien thoai</label>
                <input type="tel" name="phone" 
                       value="<%= profileUser.getPhone() != null ? profileUser.getPhone() : "" %>"
                       placeholder="VD: 0901234567" />
                <p class="hint">9-15 chu so, co the bat dau bang +</p>
            </div>

            <!-- Avatar upload -->
            <div class="form-group">
                <label>Anh dai dien</label>
                <input type="file" name="image" accept=".jpg,.jpeg,.png,.webp" />
                <p class="hint">Chap nhan: JPG, JPEG, PNG, WEBP. Toi da 2MB.</p>
            </div>

            <!-- Buttons -->
            <div class="btn-group">
                <button type="submit" class="btn btn-primary">Cap nhat</button>
                <a href="<%= request.getContextPath() %>/home" class="btn btn-secondary">Quay lại Trang chủ</a>
            </div>

        </form>

    </div>

    <!-- Navigation links -->
    <div class="nav-links">
        <a href="<%= request.getContextPath() %>/home">🏠 Trang chủ</a> |
        <a href="<%= request.getContextPath() %>/product">📦 Sản phẩm</a> |
        <a href="<%= request.getContextPath() %>/dashboard">📊 Dashboard</a> |
        <a href="<%= request.getContextPath() %>/logout">🚪 Đăng xuất</a>
    </div>

</div>

</body>
</html>
