package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet xu ly dang xuat.
 * - Xoa Cookie username (set maxAge = 0)
 * - Huy Session (invalidate)
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Xoa Cookie "username" (dat maxAge = 0 de trinh duyet xoa)
        Cookie usernameCookie = new Cookie("username", "");
        usernameCookie.setMaxAge(0); // Xoa ngay lap tuc
        response.addCookie(usernameCookie);

        // 2. Huy Session
        HttpSession session = request.getSession(false); // false = khong tao moi
        if (session != null) {
            session.invalidate(); // Xoa toan bo du lieu trong session
        }

        // 3. Redirect ve trang login
        response.sendRedirect(request.getContextPath() + "/login-session");
    }
}
