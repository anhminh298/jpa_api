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
 * Servlet xử lý đăng nhập bằng SESSION có Validation form.
 */
@WebServlet("/login-session")
public class LoginSessionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println(">>> [DEBUG] LoginSessionServlet.doGet called! <<<");
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        System.out.println(">>> [DEBUG] Forwarding to /views/login-session.jsp <<<");
        request.getRequestDispatcher("/views/login-session.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Validation bằng DTO
        LoginDTO dto = new LoginDTO(username, password);
        Map<String, String> errors = ValidationUtil.validate(dto);

        if (!errors.isEmpty()) {
            request.setAttribute("error", errors.values().iterator().next());
            request.setAttribute("username", username);
            request.getRequestDispatcher("/views/login-session.jsp").forward(request, response);
            return;
        }

        User user = userService.login(username.trim(), password);

        if (user != null) {
            if (!user.isActive()) {
                request.setAttribute("error", "Tài khoản chưa được kích hoạt! Vui lòng kiểm tra email để xác thực OTP.");
                request.setAttribute("username", username);
                request.getRequestDispatcher("/views/login-session.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(30 * 60); // 30 phút

            session.setAttribute("successMessage", "Đăng nhập thành công! Chào mừng " + (user.getFullname() != null ? user.getFullname() : user.getUsername()));
            response.sendRedirect(request.getContextPath() + "/home");

        } else {
            request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không chính xác!");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/views/login-session.jsp").forward(request, response);
        }
    }
}
