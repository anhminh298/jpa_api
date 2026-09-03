package vn.iotstar.controller;

import vn.iotstar.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet xu ly dat lai mat khau voi OTP.
 */
@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {

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

        String email = (String) request.getSession().getAttribute("resetEmail");
        String otp = request.getParameter("otp");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (email == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        // Validate
        if (otp == null || otp.trim().isEmpty() ||
            newPassword == null || newPassword.trim().isEmpty()) {
            request.setAttribute("error", "Vui long dien day du thong tin!");
            request.getRequestDispatcher("/views/reset-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mat khau xac nhan khong khop!");
            request.getRequestDispatcher("/views/reset-password.jsp").forward(request, response);
            return;
        }

        boolean success = userService.resetPassword(email, otp.trim(), newPassword);

        if (success) {
            request.getSession().removeAttribute("resetEmail");
            request.getSession().setAttribute("successMessage", "Doi mat khau thanh cong! Vui long dang nhap.");
            response.sendRedirect(request.getContextPath() + "/login-session");
        } else {
            request.setAttribute("error", "Ma OTP khong dung hoac da het han!");
            request.getRequestDispatcher("/views/reset-password.jsp").forward(request, response);
        }
    }
}
