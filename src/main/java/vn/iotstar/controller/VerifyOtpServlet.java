package vn.iotstar.controller;

import vn.iotstar.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet xu ly xac thuc OTP sau khi dang ky.
 */
@WebServlet("/verify-otp")
public class VerifyOtpServlet extends HttpServlet {

    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Kiem tra co email trong session khong
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

        String email = (String) request.getSession().getAttribute("otpEmail");
        String otp = request.getParameter("otp");
        String action = request.getParameter("action");

        if (email == null) {
            response.sendRedirect(request.getContextPath() + "/register");
            return;
        }

        // Gui lai OTP
        if ("resend".equals(action)) {
            String error = userService.resendOtp(email);
            if (error != null) {
                request.setAttribute("error", error);
            } else {
                request.setAttribute("message", "Da gui lai ma OTP moi! Vui long kiem tra email.");
            }
            request.getRequestDispatcher("/views/verify-otp.jsp").forward(request, response);
            return;
        }

        // Xac thuc OTP
        if (otp == null || otp.trim().isEmpty()) {
            request.setAttribute("error", "Vui long nhap ma OTP!");
            request.getRequestDispatcher("/views/verify-otp.jsp").forward(request, response);
            return;
        }

        boolean success = userService.verifyOtp(email, otp.trim());

        if (success) {
            request.getSession().removeAttribute("otpEmail");
            request.getSession().setAttribute("successMessage", "Kich hoat tai khoan thanh cong! Vui long dang nhap.");
            response.sendRedirect(request.getContextPath() + "/login-session");
        } else {
            request.setAttribute("error", "Ma OTP khong dung hoac da het han!");
            request.getRequestDispatcher("/views/verify-otp.jsp").forward(request, response);
        }
    }
}
