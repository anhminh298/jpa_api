package vn.iotstar.controller;

import vn.iotstar.entity.User;
import vn.iotstar.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet xu ly dang nhap bang COOKIE.
 * 
 * COOKIE la gi?
 * - Cookie la mot doan du lieu nho duoc server gui ve va luu tren TRINH DUYET (client).
 * - Moi lan request, trinh duyet tu dong gui cookie len server.
 * - Cookie co thoi gian song (maxAge), van ton tai khi dong trinh duyet.
 * 
 * Luong hoat dong:
 * 1. User nhap username/password + tick "Remember Me"
 * 2. Server xac thuc thanh cong -> tao Cookie luu username
 * 3. Set maxAge = 7 ngay (Cookie ton tai 7 ngay)
 * 4. Lan sau mo trinh duyet, Cookie tu dong gui len -> tu dong dien username
 */
@WebServlet("/login-cookie")
public class LoginCookieServlet extends HttpServlet {

    private UserService userService = new UserService();

    /**
     * GET: Hien thi form dang nhap.
     * Kiem tra neu co Cookie "username" thi tu dong dien vao form.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Doc Cookie tu request
        String savedUsername = "";
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("username".equals(cookie.getName())) {
                    savedUsername = cookie.getValue();
                }
            }
        }

        request.setAttribute("savedUsername", savedUsername);
        request.getRequestDispatcher("/views/login-cookie.jsp").forward(request, response);
    }

    /**
     * POST: Xu ly dang nhap.
     * Neu thanh cong va co "Remember Me" -> tao Cookie.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember"); // checkbox

        // Goi Service de xac thuc
        User user = userService.login(username, password);

        if (user != null) {
            // Kiem tra tai khoan da kich hoat chua
            if (!user.isActive()) {
                request.setAttribute("error", "Tai khoan chua duoc kich hoat! Vui long kiem tra email.");
                request.setAttribute("savedUsername", username);
                request.getRequestDispatcher("/views/login-cookie.jsp").forward(request, response);
                return;
            }
            // === DANG NHAP THANH CONG ===

            // Luu user vao Session (de biet user da dang nhap)
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            // Neu tick "Remember Me" -> tao Cookie
            if ("on".equals(remember)) {
                Cookie usernameCookie = new Cookie("username", username);
                usernameCookie.setMaxAge(7 * 24 * 60 * 60); // 7 ngay (tinh bang giay)
                response.addCookie(usernameCookie);
            }

            // Redirect den trang dashboard
            response.sendRedirect(request.getContextPath() + "/dashboard");

        } else {
            // === DANG NHAP THAT BAI ===
            request.setAttribute("error", "Sai username hoac password!");
            request.setAttribute("savedUsername", username);
            request.getRequestDispatcher("/views/login-cookie.jsp").forward(request, response);
        }
    }
}
