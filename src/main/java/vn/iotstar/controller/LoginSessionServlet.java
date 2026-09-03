package vn.iotstar.controller;

import vn.iotstar.entity.User;
import vn.iotstar.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet xu ly dang nhap bang SESSION.
 * 
 * SESSION la gi?
 * - Session la vung nho tren SERVER dung de luu thong tin cua 1 phien lam viec.
 * - Moi user co 1 session rieng, duoc dinh danh boi JSESSIONID (luu trong cookie).
 * - Session mat khi: dong trinh duyet, goi invalidate(), hoac het timeout.
 * 
 * SO SANH VOI COOKIE:
 * - Cookie: luu o CLIENT, ton tai lau (maxAge), ai cung doc duoc -> kem bao mat
 * - Session: luu o SERVER, mat khi dong trinh duyet, chi server doc duoc -> bao mat hon
 */
@WebServlet("/login-session")
public class LoginSessionServlet extends HttpServlet {

    private UserService userService = new UserService();

    /**
     * GET: Hien thi form dang nhap.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/login-session.jsp").forward(request, response);
    }

    /**
     * POST: Xu ly dang nhap va luu vao Session.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = userService.login(username, password);

        if (user != null) {
            // Kiem tra tai khoan da kich hoat chua
            if (!user.isActive()) {
                request.setAttribute("error", "Tai khoan chua duoc kich hoat! Vui long kiem tra email.");
                request.getRequestDispatcher("/views/login-session.jsp").forward(request, response);
                return;
            }
            // === DANG NHAP THANH CONG ===

            // Tao session moi (hoac lay session hien tai)
            HttpSession session = request.getSession();

            // Luu doi tuong User vao session
            session.setAttribute("user", user);

            // Set thoi gian timeout: 30 phut (tinh bang giay)
            session.setMaxInactiveInterval(30 * 60);

            // Redirect den dashboard
            response.sendRedirect(request.getContextPath() + "/dashboard");

        } else {
            // === DANG NHAP THAT BAI ===
            request.setAttribute("error", "Sai username hoac password!");
            request.getRequestDispatcher("/views/login-session.jsp").forward(request, response);
        }
    }
}
