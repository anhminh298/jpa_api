package vn.iotstar.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.iotstar.configs.constants;
import vn.iotstar.dto.ProductDTO;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.Product;
import vn.iotstar.service.*;
import vn.iotstar.utils.ValidationUtil;

/**
 * Servlet CRUD sản phẩm (Admin) - hỗ trợ Validation toàn diện và SiteMesh.
 * URL: /admin/products
 */
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 2 * 1024 * 1024,
    maxRequestSize = 5 * 1024 * 1024
)
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
			List<Product> list = productService.findAll();
			req.setAttribute("listProduct", list);
			req.getRequestDispatcher("/views/admin/product-list.jsp").forward(req, resp);

		} else if (url.contains("/admin/product/add")) {
			List<Category> categories = cateService.findAll();
			req.setAttribute("categories", categories);
			req.getRequestDispatcher("/views/admin/product-add.jsp").forward(req, resp);

		} else if (url.contains("/admin/product/edit")) {
			int id = ValidationUtil.parseIntSafe(req.getParameter("id"), 0);
			Product product = productService.findById(id);
			if (product == null) {
				req.getSession().setAttribute("errorMessage", "Không tìm thấy sản phẩm cần sửa!");
				resp.sendRedirect(req.getContextPath() + "/admin/products");
				return;
			}
			List<Category> categories = cateService.findAll();
			req.setAttribute("product", product);
			req.setAttribute("categories", categories);
			req.getRequestDispatcher("/views/admin/product-edit.jsp").forward(req, resp);

		} else if (url.contains("/admin/product/delete")) {
			int id = ValidationUtil.parseIntSafe(req.getParameter("id"), 0);
			try {
				productService.delete(id);
				req.getSession().setAttribute("successMessage", "Xóa sản phẩm thành công!");
			} catch (Exception e) {
				e.printStackTrace();
				req.getSession().setAttribute("errorMessage", "Lỗi khi xóa sản phẩm!");
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
			String priceStr = req.getParameter("price");
			String quantityStr = req.getParameter("quantity");
			String description = req.getParameter("description");
			String categoryIdStr = req.getParameter("categoryId");

			double price = ValidationUtil.parseDoubleSafe(priceStr, -1.0);
			int quantity = ValidationUtil.parseIntSafe(quantityStr, -1);
			int categoryId = ValidationUtil.parseIntSafe(categoryIdStr, 0);

			ProductDTO dto = new ProductDTO(name, price, quantity, description, categoryId);
			Map<String, String> errors = ValidationUtil.validate(dto);

			// Kiểm tra parse số thủ công bổ sung nếu cần
			if (price < 0) {
				errors.put("price", "Giá sản phẩm không hợp lệ! Vui lòng nhập số dương.");
			}
			if (quantity < 0) {
				errors.put("quantity", "Số lượng sản phẩm không hợp lệ! Vui lòng nhập số nguyên không âm.");
			}

			// Validate category tồn tại
			Category category = null;
			if (categoryId > 0) {
				category = cateService.findById(categoryId);
				if (category == null) {
					errors.put("categoryId", "Danh mục đã chọn không tồn tại!");
				}
			} else {
				errors.put("categoryId", "Vui lòng chọn danh mục hợp lệ!");
			}

			// Validate file upload (nếu có)
			Part part = null;
			try {
				part = req.getPart("imageFile");
			} catch (Exception e) {
				// bỏ qua
			}

			if (part != null && part.getSize() > 0) {
				String filename = Paths.get(part.getSubmittedFileName()).getFileName().toString();
				if (!ValidationUtil.isValidImageExtension(filename)) {
					errors.put("imageFile", "File tải lên không phải là ảnh hợp lệ (chỉ nhận JPG, JPEG, PNG, WEBP)!");
				}
				if (part.getSize() > ValidationUtil.MAX_IMAGE_FILE_SIZE) {
					errors.put("imageFile", "Dung lượng ảnh vượt quá giới hạn 2MB!");
				}
			}

			// Nếu có lỗi -> forward lại form kèm thông báo và dữ liệu đã nhập
			if (!errors.isEmpty()) {
				req.setAttribute("error", errors.values().iterator().next());
				req.setAttribute("fieldErrors", errors);

				Product formProduct = new Product();
				formProduct.setName(name);
				formProduct.setPrice(price > 0 ? price : 0);
				formProduct.setQuantity(quantity >= 0 ? quantity : 0);
				formProduct.setDescription(description);
				formProduct.setCategory(category);
				req.setAttribute("product", formProduct);

				List<Category> categories = cateService.findAll();
				req.setAttribute("categories", categories);
				req.getRequestDispatcher("/views/admin/product-add.jsp").forward(req, resp);
				return;
			}

			// Tạo mới Product
			Product product = new Product();
			product.setName(name.trim());
			product.setPrice(price);
			product.setQuantity(quantity);
			product.setDescription(description != null ? description.trim() : "");
			product.setCategory(category);

			String imageName = handleUpload(req, null);
			product.setImage(imageName);

			productService.insert(product);
			req.getSession().setAttribute("successMessage", "Thêm sản phẩm mới thành công!");
			resp.sendRedirect(req.getContextPath() + "/admin/products");

		} else if (url.contains("/admin/product/update")) {
			int id = ValidationUtil.parseIntSafe(req.getParameter("id"), 0);
			String name = req.getParameter("name");
			String priceStr = req.getParameter("price");
			String quantityStr = req.getParameter("quantity");
			String description = req.getParameter("description");
			String categoryIdStr = req.getParameter("categoryId");

			Product product = productService.findById(id);
			if (product == null) {
				req.getSession().setAttribute("errorMessage", "Không tìm thấy sản phẩm để cập nhật!");
				resp.sendRedirect(req.getContextPath() + "/admin/products");
				return;
			}

			double price = ValidationUtil.parseDoubleSafe(priceStr, -1.0);
			int quantity = ValidationUtil.parseIntSafe(quantityStr, -1);
			int categoryId = ValidationUtil.parseIntSafe(categoryIdStr, 0);

			ProductDTO dto = new ProductDTO(name, price, quantity, description, categoryId);
			Map<String, String> errors = ValidationUtil.validate(dto);

			if (price < 0) {
				errors.put("price", "Giá sản phẩm không hợp lệ! Vui lòng nhập số dương.");
			}
			if (quantity < 0) {
				errors.put("quantity", "Số lượng sản phẩm không hợp lệ! Vui lòng nhập số nguyên không âm.");
			}

			Category category = null;
			if (categoryId > 0) {
				category = cateService.findById(categoryId);
				if (category == null) {
					errors.put("categoryId", "Danh mục đã chọn không tồn tại!");
				}
			} else {
				errors.put("categoryId", "Vui lòng chọn danh mục hợp lệ!");
			}

			Part part = null;
			try {
				part = req.getPart("imageFile");
			} catch (Exception e) {
				// bỏ qua
			}

			if (part != null && part.getSize() > 0) {
				String filename = Paths.get(part.getSubmittedFileName()).getFileName().toString();
				if (!ValidationUtil.isValidImageExtension(filename)) {
					errors.put("imageFile", "File tải lên không phải là ảnh hợp lệ (chỉ nhận JPG, JPEG, PNG, WEBP)!");
				}
				if (part.getSize() > ValidationUtil.MAX_IMAGE_FILE_SIZE) {
					errors.put("imageFile", "Dung lượng ảnh vượt quá giới hạn 2MB!");
				}
			}

			if (!errors.isEmpty()) {
				req.setAttribute("error", errors.values().iterator().next());
				req.setAttribute("fieldErrors", errors);

				product.setName(name);
				product.setPrice(price > 0 ? price : 0);
				product.setQuantity(quantity >= 0 ? quantity : 0);
				product.setDescription(description);
				product.setCategory(category);
				req.setAttribute("product", product);

				List<Category> categories = cateService.findAll();
				req.setAttribute("categories", categories);
				req.getRequestDispatcher("/views/admin/product-edit.jsp").forward(req, resp);
				return;
			}

			String oldImage = product.getImage();
			product.setName(name.trim());
			product.setPrice(price);
			product.setQuantity(quantity);
			product.setDescription(description != null ? description.trim() : "");
			product.setCategory(category);

			String imageName = handleUpload(req, oldImage);
			product.setImage(imageName);

			productService.update(product);
			req.getSession().setAttribute("successMessage", "Cập nhật sản phẩm thành công!");
			resp.sendRedirect(req.getContextPath() + "/admin/products");
		}
	}

	/**
	 * Xử lý upload ảnh sản phẩm an toàn.
	 */
	private String handleUpload(HttpServletRequest req, String oldImage) {
		String uploadPath = constants.DIR;
		File uploadDir = new File(uploadPath);
		if (!uploadDir.exists()) uploadDir.mkdirs();

		try {
			Part part = req.getPart("imageFile");
			if (part != null && part.getSize() > 0) {
				String filename = Paths.get(part.getSubmittedFileName()).getFileName().toString();
				int index = filename.lastIndexOf(".");
				String ext = filename.substring(index + 1);
				String fname = System.currentTimeMillis() + "." + ext;

				part.write(uploadPath + "/" + fname);

				// Xóa ảnh cũ nếu có
				if (oldImage != null && !oldImage.isEmpty() && !oldImage.startsWith("http")) {
					CategoryController.deleteFile(uploadPath + "/" + oldImage);
				}

				return fname;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		String imageUrl = null;
		try {
			imageUrl = req.getParameter("imageUrl");
		} catch (Exception e) {}
		if (ValidationUtil.isNotBlank(imageUrl)) {
			return imageUrl.trim();
		}

		return oldImage != null ? oldImage : "no-image.png";
	}
}
