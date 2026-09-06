package vn.iotstar.controller;

import vn.iotstar.service.UserService;
import vn.iotstar.utils.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet xử lý đặt lại mật khẩu với OTP có Validation toàn diện.
 */
@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = (String) request.getSession().getAttribute("resetEmail");
        if (email == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }
        request.getRequestDispatcher("/views/reset-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String email = (String) request.getSession().getAttribute("resetEmail");
        String otp = request.getParameter("otp");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (email == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        // Server-side Validation
        if (!ValidationUtil.isNotBlank(otp)) {
            request.setAttribute("error", "Vui lòng nhập mã OTP!");
            request.getRequestDispatcher("/views/reset-password.jsp").forward(request, response);
            return;
        }

        String cleanOtp = otp.trim();
        if (!cleanOtp.matches("^[0-9]{6}$")) {
            request.setAttribute("error", "Mã OTP phải gồm 6 chữ số!");
            request.setAttribute("otp", otp);
            request.getRequestDispatcher("/views/reset-password.jsp").forward(request, response);
            return;
        }

        if (!ValidationUtil.isNotBlank(newPassword) || newPassword.length() < 6) {
            request.setAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự!");
            request.setAttribute("otp", otp);
            request.getRequestDispatcher("/views/reset-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.setAttribute("otp", otp);
            request.getRequestDispatcher("/views/reset-password.jsp").forward(request, response);
            return;
        }

        boolean success = userService.resetPassword(email, cleanOtp, newPassword);

        if (success) {
            request.getSession().removeAttribute("resetEmail");
            request.getSession().setAttribute("successMessage", "Đặt lại mật khẩu thành công! Vui lòng đăng nhập với mật khẩu mới.");
            response.sendRedirect(request.getContextPath() + "/login-session");
        } else {
            request.setAttribute("error", "Mã OTP không đúng hoặc đã hết hạn!");
            request.setAttribute("otp", otp);
            request.getRequestDispatcher("/views/reset-password.jsp").forward(request, response);
        }
    }
}
