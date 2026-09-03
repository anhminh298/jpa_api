package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet trang chinh sau dang nhap.
 * Hien thi thong tin user da dang nhap (lay tu Session).
 */
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // User da duoc kiem tra boi AuthFilter
        // Chi can forward den trang dashboard.jsp
        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }
}
