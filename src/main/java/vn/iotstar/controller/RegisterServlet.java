package vn.iotstar.controller;

import vn.iotstar.dto.RegisterDTO;
import vn.iotstar.entity.User;
import vn.iotstar.service.UserService;
import vn.iotstar.utils.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;

/**
 * Servlet xử lý đăng ký tài khoản mới với Validation toàn diện.
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");

        // DTO Validation
        RegisterDTO dto = new RegisterDTO(username, password, confirmPassword, fullname, email);
        Map<String, String> errors = ValidationUtil.validate(dto);

        // Kiểm tra khớp mật khẩu
        if (password != null && !password.equals(confirmPassword)) {
            errors.put("confirmPassword", "Mật khẩu xác nhận không khớp!");
        }

        if (!errors.isEmpty()) {
            request.setAttribute("error", errors.values().iterator().next());
            request.setAttribute("fieldErrors", errors);
            repopulateRegisterForm(request, username, fullname, email);
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }

        // Tạo User
        User user = new User();
        user.setUsername(username.trim());
        user.setPassword(password);
        user.setFullname(fullname.trim());
        user.setEmail(email.trim());

        // Gọi Service đăng ký (Service kiểm tra trùng lặp email/username và gửi OTP)
        String error = userService.register(user);

        if (error != null) {
            request.setAttribute("error", error);
            repopulateRegisterForm(request, username, fullname, email);
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
        } else {
            // Chuyển sang trang nhập OTP
            request.getSession().setAttribute("otpEmail", email.trim());
            request.getSession().setAttribute("successMessage", "Đăng ký thành công! Vui lòng kiểm tra email để lấy mã kích hoạt OTP.");
            response.sendRedirect(request.getContextPath() + "/verify-otp");
        }
    }

    private void repopulateRegisterForm(HttpServletRequest request, String username, String fullname, String email) {
        request.setAttribute("username", username);
        request.setAttribute("fullname", fullname);
        request.setAttribute("email", email);
    }
}
