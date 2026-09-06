package vn.iotstar.controller;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import vn.iotstar.configs.constants;
import vn.iotstar.entity.Category;
import vn.iotstar.service.CategoryServiceImpl;
import vn.iotstar.service.ICategoryService;
import vn.iotstar.utils.ValidationUtil;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 2 * 1024 * 1024,
    maxRequestSize = 5 * 1024 * 1024
)
@WebServlet(urlPatterns = { "/admin/categories", "/admin/category/add", "/admin/category/insert",
		"/admin/category/edit", "/admin/category/update", "/admin/category/delete" })
public class CategoryController extends HttpServlet {

	private static final long serialVersionUID = 1L;
	public ICategoryService cateService = new CategoryServiceImpl();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		resp.setCharacterEncoding("UTF-8");

		String url = req.getRequestURI();

		if (url.contains("/admin/categories")) {
			List<Category> list = cateService.findAll();
			req.setAttribute("listcate", list);
			req.getRequestDispatcher("/views/admin/category-list.jsp").forward(req, resp);

		} else if (url.contains("/admin/category/add")) {
			req.getRequestDispatcher("/views/admin/category-add.jsp").forward(req, resp);

		} else if (url.contains("/admin/category/edit")) {
			int id = ValidationUtil.parseIntSafe(req.getParameter("id"), 0);
			Category category = cateService.findById(id);
			if (category == null) {
				req.getSession().setAttribute("errorMessage", "Không tìm thấy danh mục cần sửa!");
				resp.sendRedirect(req.getContextPath() + "/admin/categories");
				return;
			}
			req.setAttribute("cate", category);
			req.getRequestDispatcher("/views/admin/category-edit.jsp").forward(req, resp);

		} else {
			// delete
			int id = ValidationUtil.parseIntSafe(req.getParameter("id"), 0);
			try {
				cateService.delete(id);
				req.getSession().setAttribute("successMessage", "Xóa danh mục thành công!");
			} catch (Exception e) {
				e.printStackTrace();
				req.getSession().setAttribute("errorMessage", "Không thể xóa danh mục này do có ràng buộc dữ liệu!");
			}
			resp.sendRedirect(req.getContextPath() + "/admin/categories");
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		resp.setCharacterEncoding("UTF-8");

		String url = req.getRequestURI();

		if (url.contains("/admin/category/insert")) {
			String categoryname = req.getParameter("categoryname");
			String statusStr = req.getParameter("status");
			int status = ValidationUtil.parseIntSafe(statusStr, 1);
			String images = req.getParameter("images");

			// Server-side Validation
			if (!ValidationUtil.isNotBlank(categoryname)) {
				req.setAttribute("error", "Tên danh mục không được để trống!");
				repopulateCategoryAdd(req, categoryname, status, images);
				req.getRequestDispatcher("/views/admin/category-add.jsp").forward(req, resp);
				return;
			}
			if (categoryname.trim().length() < 2 || categoryname.trim().length() > 50) {
				req.setAttribute("error", "Tên danh mục phải có độ dài từ 2 đến 50 ký tự!");
				repopulateCategoryAdd(req, categoryname, status, images);
				req.getRequestDispatcher("/views/admin/category-add.jsp").forward(req, resp);
				return;
			}

			// Validate file upload (nếu có)
			Part part = null;
			try {
				part = req.getPart("images1");
			} catch (Exception e) {
				// bỏ qua
			}

			if (part != null && part.getSize() > 0) {
				String filename = Paths.get(part.getSubmittedFileName()).getFileName().toString();
				if (!ValidationUtil.isValidImageExtension(filename)) {
					req.setAttribute("error", "Định dạng file ảnh không hợp lệ! (Chỉ chấp nhận JPG, JPEG, PNG, WEBP)");
					repopulateCategoryAdd(req, categoryname, status, images);
					req.getRequestDispatcher("/views/admin/category-add.jsp").forward(req, resp);
					return;
				}
				if (part.getSize() > ValidationUtil.MAX_IMAGE_FILE_SIZE) {
					req.setAttribute("error", "Kích thước ảnh vượt quá giới hạn cho phép (tối đa 2MB)!");
					repopulateCategoryAdd(req, categoryname, status, images);
					req.getRequestDispatcher("/views/admin/category-add.jsp").forward(req, resp);
					return;
				}
			}

			// Đưa dữ liệu vào model
			Category category = new Category();
			category.setCategoryname(categoryname.trim());
			category.setStatus(status);

			String fname = "";
			String uploadPath = constants.DIR;
			File uploadDir = new File(uploadPath);
			if (!uploadDir.exists())
				uploadDir.mkdirs();

			try {
				if (part != null && part.getSize() > 0) {
					String filename = Paths.get(part.getSubmittedFileName()).getFileName().toString();
					int index = filename.lastIndexOf(".");
					String ext = filename.substring(index + 1);
					fname = System.currentTimeMillis() + "." + ext;

					part.write(uploadPath + "/" + fname);
					category.setImages(fname);

				} else if (ValidationUtil.isNotBlank(images)) {
					category.setImages(images.trim());
				} else {
					category.setImages("avatar.png");
				}
			} catch (FileNotFoundException fne) {
				fne.printStackTrace();
			}

			cateService.insert(category);
			req.getSession().setAttribute("successMessage", "Thêm danh mục mới thành công!");
			resp.sendRedirect(req.getContextPath() + "/admin/categories");
		}

		if (url.contains("/admin/category/update")) {
			int categoryid = ValidationUtil.parseIntSafe(req.getParameter("categoryid"), 0);
			String categoryname = req.getParameter("categoryname");
			int status = ValidationUtil.parseIntSafe(req.getParameter("status"), 1);
			String images = req.getParameter("images");

			Category category = cateService.findById(categoryid);
			if (category == null) {
				req.getSession().setAttribute("errorMessage", "Không tìm thấy danh mục để cập nhật!");
				resp.sendRedirect(req.getContextPath() + "/admin/categories");
				return;
			}

			// Server-side Validation
			if (!ValidationUtil.isNotBlank(categoryname)) {
				req.setAttribute("error", "Tên danh mục không được để trống!");
				category.setCategoryname(categoryname);
				category.setStatus(status);
				category.setImages(images);
				req.setAttribute("cate", category);
				req.getRequestDispatcher("/views/admin/category-edit.jsp").forward(req, resp);
				return;
			}
			if (categoryname.trim().length() < 2 || categoryname.trim().length() > 50) {
				req.setAttribute("error", "Tên danh mục phải có độ dài từ 2 đến 50 ký tự!");
				category.setCategoryname(categoryname);
				category.setStatus(status);
				category.setImages(images);
				req.setAttribute("cate", category);
				req.getRequestDispatcher("/views/admin/category-edit.jsp").forward(req, resp);
				return;
			}

			Part part = null;
			try {
				part = req.getPart("images1");
			} catch (Exception e) {
				// bỏ qua
			}

			if (part != null && part.getSize() > 0) {
				String filename = Paths.get(part.getSubmittedFileName()).getFileName().toString();
				if (!ValidationUtil.isValidImageExtension(filename)) {
					req.setAttribute("error", "Định dạng file ảnh không hợp lệ! (Chỉ chấp nhận JPG, JPEG, PNG, WEBP)");
					category.setCategoryname(categoryname);
					category.setStatus(status);
					category.setImages(images);
					req.setAttribute("cate", category);
					req.getRequestDispatcher("/views/admin/category-edit.jsp").forward(req, resp);
					return;
				}
				if (part.getSize() > ValidationUtil.MAX_IMAGE_FILE_SIZE) {
					req.setAttribute("error", "Kích thước ảnh vượt quá giới hạn cho phép (tối đa 2MB)!");
					category.setCategoryname(categoryname);
					category.setStatus(status);
					category.setImages(images);
					req.setAttribute("cate", category);
					req.getRequestDispatcher("/views/admin/category-edit.jsp").forward(req, resp);
					return;
				}
			}

			String fileold = category.getImages();
			category.setCategoryname(categoryname.trim());
			category.setStatus(status);

			String fname = "";
			String uploadPath = constants.DIR;
			File uploadDir = new File(uploadPath);
			if (!uploadDir.exists())
				uploadDir.mkdirs();

			try {
				if (part != null && part.getSize() > 0) {
					if (fileold != null && fileold.length() >= 5
							&& !fileold.substring(0, 5).equals("https")) {
						deleteFile(uploadPath + "\\" + fileold);
					}

					String filename = Paths.get(part.getSubmittedFileName()).getFileName().toString();
					int index = filename.lastIndexOf(".");
					String ext = filename.substring(index + 1);
					fname = System.currentTimeMillis() + "." + ext;

					part.write(uploadPath + "/" + fname);
					category.setImages(fname);

				} else if (ValidationUtil.isNotBlank(images)) {
					category.setImages(images.trim());
				} else {
					category.setImages(fileold);
				}
			} catch (FileNotFoundException fne) {
				fne.printStackTrace();
			}

			cateService.update(category);
			req.getSession().setAttribute("successMessage", "Cập nhật danh mục thành công!");
			resp.sendRedirect(req.getContextPath() + "/admin/categories");
		}
	}

	private void repopulateCategoryAdd(HttpServletRequest req, String categoryname, int status, String images) {
		Category c = new Category();
		c.setCategoryname(categoryname);
		c.setStatus(status);
		c.setImages(images);
		req.setAttribute("category", c);
	}

	public static void deleteFile(String filePath) throws IOException {
		Path path = Paths.get(filePath);
		if (Files.exists(path)) {
			Files.delete(path);
		}
	}
}
