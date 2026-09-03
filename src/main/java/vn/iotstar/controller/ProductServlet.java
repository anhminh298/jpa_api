package vn.iotstar.controller;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.iotstar.configs.constants;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.Product;
import vn.iotstar.service.*;

/**
 * Servlet CRUD san pham (Admin) - su dung JPA.
 * URL: /admin/products
 */
@MultipartConfig()
@WebServlet(urlPatterns = { "/admin/products", "/admin/product/add", "/admin/product/insert",
		"/admin/product/edit", "/admin/product/update", "/admin/product/delete" })
public class ProductServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private IProductService productService = new ProductServiceImpl();
	private ICategoryService cateService = new CategoryServiceImpl();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		resp.setCharacterEncoding("UTF-8");

		String url = req.getRequestURI();

		if (url.contains("/admin/products")) {
			// Danh sach san pham
			List<Product> list = productService.findAll();
			req.setAttribute("listProduct", list);
			req.getRequestDispatcher("/views/admin/product-list.jsp").forward(req, resp);

		} else if (url.contains("/admin/product/add")) {
			// Form them moi
			List<Category> categories = cateService.findAll();
			req.setAttribute("categories", categories);
			req.getRequestDispatcher("/views/admin/product-add.jsp").forward(req, resp);

		} else if (url.contains("/admin/product/edit")) {
			// Form cap nhat
			int id = Integer.parseInt(req.getParameter("id"));
			Product product = productService.findById(id);
			List<Category> categories = cateService.findAll();
			req.setAttribute("product", product);
			req.setAttribute("categories", categories);
			req.getRequestDispatcher("/views/admin/product-edit.jsp").forward(req, resp);

		} else if (url.contains("/admin/product/delete")) {
			// Xoa
			int id = Integer.parseInt(req.getParameter("id"));
			try {
				productService.delete(id);
			} catch (Exception e) {
				e.printStackTrace();
			}
			resp.sendRedirect(req.getContextPath() + "/admin/products");
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		resp.setCharacterEncoding("UTF-8");

		String url = req.getRequestURI();

		if (url.contains("/admin/product/insert")) {
			String name = req.getParameter("name");
			double price = Double.parseDouble(req.getParameter("price"));
			int quantity = Integer.parseInt(req.getParameter("quantity"));
			String description = req.getParameter("description");
			int categoryId = Integer.parseInt(req.getParameter("categoryId"));

			Product product = new Product();
			product.setName(name);
			product.setPrice(price);
			product.setQuantity(quantity);
			product.setDescription(description);

			// Set category
			Category category = cateService.findById(categoryId);
			product.setCategory(category);

			// Upload anh
			String imageName = handleUpload(req, null);
			product.setImage(imageName);

			productService.insert(product);
			resp.sendRedirect(req.getContextPath() + "/admin/products");

		} else if (url.contains("/admin/product/update")) {
			int id = Integer.parseInt(req.getParameter("id"));
			String name = req.getParameter("name");
			double price = Double.parseDouble(req.getParameter("price"));
			int quantity = Integer.parseInt(req.getParameter("quantity"));
			String description = req.getParameter("description");
			int categoryId = Integer.parseInt(req.getParameter("categoryId"));

			Product product = productService.findById(id);
			String oldImage = product.getImage();
			product.setName(name);
			product.setPrice(price);
			product.setQuantity(quantity);
			product.setDescription(description);

			Category category = cateService.findById(categoryId);
			product.setCategory(category);

			// Upload anh moi (neu co)
			String imageName = handleUpload(req, oldImage);
			product.setImage(imageName);

			productService.update(product);
			resp.sendRedirect(req.getContextPath() + "/admin/products");
		}
	}

	/**
	 * Xu ly upload anh san pham.
	 * @return ten file anh da luu, hoac oldImage neu khong upload moi
	 */
	private String handleUpload(HttpServletRequest req, String oldImage) {
		String uploadPath = constants.DIR;
		File uploadDir = new File(uploadPath);
		if (!uploadDir.exists()) uploadDir.mkdir();

		try {
			Part part = req.getPart("imageFile");
			if (part != null && part.getSize() > 0) {
				String filename = Paths.get(part.getSubmittedFileName()).getFileName().toString();
				int index = filename.lastIndexOf(".");
				String ext = filename.substring(index + 1);
				String fname = System.currentTimeMillis() + "." + ext;

				part.write(uploadPath + "/" + fname);

				// Xoa anh cu neu co
				if (oldImage != null && !oldImage.isEmpty() && !oldImage.startsWith("http")) {
					CategoryController.deleteFile(uploadPath + "/" + oldImage);
				}

				return fname;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		// Khong upload file moi, giu anh cu hoac URL
		String imageUrl = null;
		try {
			imageUrl = req.getParameter("imageUrl");
		} catch (Exception e) {}
		if (imageUrl != null && !imageUrl.isEmpty()) {
			return imageUrl;
		}

		return oldImage != null ? oldImage : "no-image.png";
	}
}
