package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.iotstar.entity.User;

import java.io.IOException;

/**
 * Servlet Lich su don hang danh cho Khach hang.
 * URL: /orders
 */
@WebServlet("/orders")
public class OrderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login-session");
            return;
        }

        request.getRequestDispatcher("/views/orders.jsp").forward(request, response);
    }
}
