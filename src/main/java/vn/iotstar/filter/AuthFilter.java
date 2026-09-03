package vn.iotstar.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet Filter kiem tra xac thuc.
 * Chay TRUOC moi request den cac URL duoc cau hinh trong web.xml.
 * 
 * Neu user chua dang nhap (khong co session) -> redirect ve trang login.
 * Neu da dang nhap -> cho request di tiep (chain.doFilter).
 */
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Khong can cau hinh gi
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        // Lay session hien tai (khong tao moi)
        HttpSession session = request.getSession(false);

        // Kiem tra: co session va co attribute "user" hay khong
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);

        if (isLoggedIn) {
            // Da dang nhap -> cho di tiep
            chain.doFilter(request, response);
        } else {
            // Chua dang nhap -> redirect ve login
            response.sendRedirect(request.getContextPath() + "/login-session");
        }
    }

    @Override
    public void destroy() {
        // Khong can don dep gi
    }
}
