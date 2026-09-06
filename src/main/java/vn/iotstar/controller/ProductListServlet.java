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
 * Servlet hien thi tat ca san pham voi phan trang (6 SP/trang).
 * URL: /products (va /product)
 */
@WebServlet(urlPatterns = { "/products", "/product" })
public class ProductListServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private IProductService productService = new ProductServiceImpl();
	private static final int PAGE_SIZE = 6;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// Lay so trang tu request (mac dinh trang 1)
		int page = 1;
		try {
			String pageStr = req.getParameter("page");
			if (pageStr != null) {
				page = Integer.parseInt(pageStr);
				if (page < 1) page = 1;
			}
		} catch (NumberFormatException e) {
			page = 1;
		}

		// Lay danh sach san pham theo trang
		List<Product> products = productService.findAll(page, PAGE_SIZE);
		int totalProducts = productService.count();
		int totalPages = (int) Math.ceil((double) totalProducts / PAGE_SIZE);

		req.setAttribute("products", products);
		req.setAttribute("currentPage", page);
		req.setAttribute("totalPages", totalPages);
		req.setAttribute("totalProducts", totalProducts);

		req.getRequestDispatcher("/views/product-page.jsp").forward(req, resp);
	}
}
