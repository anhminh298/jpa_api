package vn.iotstar.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.iotstar.entity.Product;
import vn.iotstar.service.IProductService;
import vn.iotstar.service.ProductServiceImpl;

/**
 * Servlet hien thi chi tiet 1 san pham.
 * URL: /product/detail?id=...
 */
@WebServlet("/product/detail")
public class ProductDetailServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private IProductService productService = new ProductServiceImpl();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			int id = Integer.parseInt(req.getParameter("id"));
			Product product = productService.findById(id);

			if (product != null) {
				req.setAttribute("product", product);
				req.getRequestDispatcher("/views/product-detail.jsp").forward(req, resp);
			} else {
				resp.sendRedirect(req.getContextPath() + "/product");
			}
		} catch (Exception e) {
			resp.sendRedirect(req.getContextPath() + "/product");
		}
	}
}
