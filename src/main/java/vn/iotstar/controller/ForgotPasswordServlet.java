package vn.iotstar.controller;

import vn.iotstar.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet xu ly quen mat khau - gui OTP qua email.
 */
@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Vui long nhap email!");
            request.getRequestDispatcher("/views/forgot-password.jsp").forward(request, response);
            return;
        }

        String error = userService.sendForgotPasswordOtp(email.trim());

        if (error != null) {
            request.setAttribute("error", error);
            request.getRequestDispatcher("/views/forgot-password.jsp").forward(request, response);
        } else {
            request.getSession().setAttribute("resetEmail", email.trim());
            response.sendRedirect(request.getContextPath() + "/reset-password");
        }
    }
}
