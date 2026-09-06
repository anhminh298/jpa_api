package vn.iotstar.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.iotstar.entity.User;
import java.io.IOException;

/**
 * Servlet Filter kiem tra xac thuc va phan quyen.
 * - Chua dang nhap: redirect ve /login-session
 * - Vao /admin/* ma khong phai Admin: redirect ve /home?error=unauthorized
 * - Hop le: cho request di tiep
 */
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        // Lay session hien tai (khong tao moi)
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        boolean isLoggedIn = (user != null);

        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();

        if (!isLoggedIn) {
            // Chua dang nhap -> redirect ve login
            response.sendRedirect(contextPath + "/login-session");
            return;
        }

        // Kiem tra phan quyen cho cac duong dan quan tri /admin/*
        if (uri.startsWith(contextPath + "/admin/")) {
            if (!user.isAdmin()) {
                // User thuong khong co quyen -> redirect ve /home kem thong bao
                response.sendRedirect(contextPath + "/home?error=unauthorized");
                return;
            }
        }

        // Da dang nhap va co du quyen -> cho di tiep
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Khong can don dep gi
    }
}
