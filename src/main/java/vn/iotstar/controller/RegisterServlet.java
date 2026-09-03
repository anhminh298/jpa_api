package vn.iotstar.controller;

import vn.iotstar.entity.User;
import vn.iotstar.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet xu ly dang ky tai khoan moi.
 * Sau khi dang ky, gui OTP qua email de kich hoat.
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");

        // Validate
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Vui long dien day du thong tin!");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mat khau xac nhan khong khop!");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }

        // Tao user
        User user = new User();
        user.setUsername(username.trim());
        user.setPassword(password);
        user.setFullname(fullname != null ? fullname.trim() : "");
        user.setEmail(email.trim());

        // Dang ky
        String error = userService.register(user);

        if (error != null) {
            request.setAttribute("error", error);
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
        } else {
            // Chuyen sang trang nhap OTP
            request.getSession().setAttribute("otpEmail", email.trim());
            request.setAttribute("message", "Dang ky thanh cong! Vui long kiem tra email de lay ma OTP.");
            response.sendRedirect(request.getContextPath() + "/verify-otp");
        }
    }
}
