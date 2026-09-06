package vn.iotstar.controller;

import vn.iotstar.dto.LoginDTO;
import vn.iotstar.entity.User;
import vn.iotstar.service.UserService;
import vn.iotstar.utils.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;

/**
 * Servlet xử lý đăng nhập bằng COOKIE có Validation form.
 */
@WebServlet("/login-cookie")
public class LoginCookieServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession currentSession = request.getSession(false);
        if (currentSession != null && currentSession.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // Đọc Cookie từ request
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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");

        // Validation
        LoginDTO dto = new LoginDTO(username, password);
        Map<String, String> errors = ValidationUtil.validate(dto);

        if (!errors.isEmpty()) {
            request.setAttribute("error", errors.values().iterator().next());
            request.setAttribute("savedUsername", username);
            request.getRequestDispatcher("/views/login-cookie.jsp").forward(request, response);
            return;
        }

        User user = userService.login(username.trim(), password);

        if (user != null) {
            if (!user.isActive()) {
                request.setAttribute("error", "Tài khoản chưa được kích hoạt! Vui lòng kiểm tra email.");
                request.setAttribute("savedUsername", username);
                request.getRequestDispatcher("/views/login-cookie.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            if ("on".equals(remember)) {
                Cookie usernameCookie = new Cookie("username", username.trim());
                usernameCookie.setMaxAge(7 * 24 * 60 * 60); // 7 ngày
                response.addCookie(usernameCookie);
            } else {
                // Xóa cookie nếu không tick remember
                Cookie usernameCookie = new Cookie("username", "");
                usernameCookie.setMaxAge(0);
                response.addCookie(usernameCookie);
            }

            session.setAttribute("successMessage", "Đăng nhập thành công!");
            response.sendRedirect(request.getContextPath() + "/home");

        } else {
            request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không chính xác!");
            request.setAttribute("savedUsername", username);
            request.getRequestDispatcher("/views/login-cookie.jsp").forward(request, response);
        }
    }
}
