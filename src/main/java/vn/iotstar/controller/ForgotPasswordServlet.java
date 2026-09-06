package vn.iotstar.controller;

import vn.iotstar.service.UserService;
import vn.iotstar.utils.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet xử lý quên mật khẩu - gửi OTP qua email có Validation.
 */
@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");

        // Server-side Validation
        if (!ValidationUtil.isNotBlank(email)) {
            request.setAttribute("error", "Vui lòng nhập địa chỉ email!");
            request.getRequestDispatcher("/views/forgot-password.jsp").forward(request, response);
            return;
        }

        if (!ValidationUtil.isValidEmail(email)) {
            request.setAttribute("error", "Địa chỉ email không đúng định dạng!");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/views/forgot-password.jsp").forward(request, response);
            return;
        }

        String error = userService.sendForgotPasswordOtp(email.trim());

        if (error != null) {
            request.setAttribute("error", error);
            request.setAttribute("email", email);
            request.getRequestDispatcher("/views/forgot-password.jsp").forward(request, response);
        } else {
            request.getSession().setAttribute("resetEmail", email.trim());
            request.getSession().setAttribute("successMessage", "Đã gửi mã OTP xác nhận đến email: " + email.trim());
            response.sendRedirect(request.getContextPath() + "/reset-password");
        }
    }
}
