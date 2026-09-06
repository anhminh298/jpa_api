package vn.iotstar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.iotstar.entity.User;
import vn.iotstar.service.CategoryServiceImpl;
import vn.iotstar.service.ICategoryService;
import vn.iotstar.service.IProductService;
import vn.iotstar.service.ProductServiceImpl;

import java.io.IOException;

/**
 * Servlet Dashboard quan tri - chi danh cho Admin.
 */
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private IProductService productService = new ProductServiceImpl();
    private ICategoryService cateService = new CategoryServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // Neu khong phai admin -> chuyen huong ve /home
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/home?error=unauthorized");
            return;
        }

        // Lay so lieu thong ke cho Admin
        int totalProducts = productService.count();
        int totalCategories = cateService.findAll().size();

        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalCategories", totalCategories);

        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }
}
