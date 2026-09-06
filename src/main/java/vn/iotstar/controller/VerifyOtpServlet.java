package vn.iotstar.controller;

import vn.iotstar.service.UserService;
import vn.iotstar.utils.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet xử lý xác thực OTP sau khi đăng ký có Validation.
 */
@WebServlet("/verify-otp")
public class VerifyOtpServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = (String) request.getSession().getAttribute("otpEmail");
        if (email == null) {
            response.sendRedirect(request.getContextPath() + "/register");
            return;
        }
        request.getRequestDispatcher("/views/verify-otp.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String email = (String) request.getSession().getAttribute("otpEmail");
        String otp = request.getParameter("otp");
        String action = request.getParameter("action");

        if (email == null) {
            response.sendRedirect(request.getContextPath() + "/register");
            return;
        }

        // Gửi lại OTP
        if ("resend".equals(action)) {
            String error = userService.resendOtp(email);
            if (error != null) {
                request.setAttribute("error", error);
            } else {
                request.setAttribute("message", "Đã gửi lại mã OTP mới! Vui lòng kiểm tra hộp thư email.");
            }
            request.getRequestDispatcher("/views/verify-otp.jsp").forward(request, response);
            return;
        }

        // Server-side Validation mã OTP
        if (!ValidationUtil.isNotBlank(otp)) {
            request.setAttribute("error", "Vui lòng nhập mã OTP!");
            request.getRequestDispatcher("/views/verify-otp.jsp").forward(request, response);
            return;
        }

        String cleanOtp = otp.trim();
        if (!cleanOtp.matches("^[0-9]{6}$")) {
            request.setAttribute("error", "Mã OTP phải là một dãy gồm đúng 6 chữ số!");
            request.setAttribute("otp", otp);
            request.getRequestDispatcher("/views/verify-otp.jsp").forward(request, response);
            return;
        }

        boolean success = userService.verifyOtp(email, cleanOtp);

        if (success) {
            request.getSession().removeAttribute("otpEmail");
            request.getSession().setAttribute("successMessage", "Kích hoạt tài khoản thành công! Vui lòng đăng nhập.");
            response.sendRedirect(request.getContextPath() + "/login-session");
        } else {
            request.setAttribute("error", "Mã OTP không chính xác hoặc đã hết hạn!");
            request.setAttribute("otp", otp);
            request.getRequestDispatcher("/views/verify-otp.jsp").forward(request, response);
        }
    }
}
