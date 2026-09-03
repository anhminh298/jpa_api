package vn.iotstar.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.iotstar.entity.Product;
import vn.iotstar.service.IProductService;
import vn.iotstar.service.ProductServiceImpl;

/**
 * Servlet trang chu - hien thi 10 san pham moi nhat.
 */
@WebServlet(urlPatterns = {"/home", "/"})
public class HomeServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private IProductService productService = new ProductServiceImpl();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// Lay 10 san pham moi nhat
		List<Product> newestProducts = productService.findNewest(10);
		req.setAttribute("newestProducts", newestProducts);
		req.getRequestDispatcher("/index.jsp").forward(req, resp);
	}
}
