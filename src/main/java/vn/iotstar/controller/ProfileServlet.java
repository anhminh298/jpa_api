package vn.iotstar.controller;

import vn.iotstar.constant.AppConstant;
import vn.iotstar.dto.UpdateProfileDTO;
import vn.iotstar.entity.User;
import vn.iotstar.service.UserService;
import vn.iotstar.utils.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Map;
import java.util.UUID;

/**
 * Servlet xử lý Profile user có Validation toàn diện.
 * GET /profile  -> Hiển thị trang profile
 * POST /profile -> Cập nhật profile (fullname, phone, avatar)
 */
@WebServlet("/profile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1 MB
    maxFileSize = 2 * 1024 * 1024,         // 2 MB
    maxRequestSize = 5 * 1024 * 1024       // 5 MB
)
public class ProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User sessionUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login-session");
            return;
        }

        User user = userService.getProfile(sessionUser.getId());
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login-session");
            return;
        }

        request.setAttribute("profileUser", user);
        request.getRequestDispatcher("/views/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User sessionUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login-session");
            return;
        }

        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");

        // Server-side Validation
        UpdateProfileDTO dto = new UpdateProfileDTO(fullname, phone);
        Map<String, String> errors = ValidationUtil.validate(dto);

        if (!ValidationUtil.isNotBlank(fullname)) {
            errors.put("fullname", "Họ và tên không được để trống!");
        }

        if (ValidationUtil.isNotBlank(phone) && !ValidationUtil.isValidPhone(phone)) {
            errors.put("phone", "Số điện thoại không hợp lệ! (Phải là 10 chữ số di động VN)");
        }

        // Upload ảnh
        String newImageFilename = null;
        String oldImageFilename = null;
        Part imagePart = null;

        try {
            imagePart = request.getPart("image");
        } catch (Exception e) {
            // bỏ qua
        }

        if (imagePart != null && imagePart.getSize() > 0) {
            String originalFilename = getSubmittedFileName(imagePart);

            if (originalFilename != null && !originalFilename.isEmpty()) {
                if (!ValidationUtil.isValidImageExtension(originalFilename)) {
                    errors.put("image", "Chỉ chấp nhận các định dạng file ảnh: JPG, JPEG, PNG, WEBP!");
                }
                if (imagePart.getSize() > ValidationUtil.MAX_IMAGE_FILE_SIZE) {
                    errors.put("image", "Dung lượng file ảnh không được vượt quá 2MB!");
                }

                User currentUser = userService.getProfile(sessionUser.getId());
                if (currentUser != null) {
                    oldImageFilename = currentUser.getImage();
                }

                if (errors.isEmpty()) {
                    int dotIdx = originalFilename.lastIndexOf('.');
                    String extension = (dotIdx >= 0) ? originalFilename.substring(dotIdx + 1).toLowerCase() : "jpg";
                    String uuid = UUID.randomUUID().toString().substring(0, 8);
                    newImageFilename = "user_" + sessionUser.getId() + "_" + uuid + "." + extension;

                    String uploadDir = AppConstant.UPLOAD_DIR + "/users";
                    Path uploadPath = Paths.get(uploadDir);

                    if (!Files.exists(uploadPath)) {
                        Files.createDirectories(uploadPath);
                    }

                    Path filePath = uploadPath.resolve(newImageFilename);
                    try (InputStream input = imagePart.getInputStream()) {
                        Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
                    }
                }
            }
        }

        if (!errors.isEmpty()) {
            request.setAttribute("error", errors.values().iterator().next());
            request.setAttribute("fieldErrors", errors);
            User currentUser = userService.getProfile(sessionUser.getId());
            if (currentUser != null) {
                currentUser.setFullname(fullname);
                currentUser.setPhone(phone);
                request.setAttribute("profileUser", currentUser);
            }
            request.getRequestDispatcher("/views/profile.jsp").forward(request, response);
            return;
        }

        // Cập nhật Profile
        try {
            User updatedUser = userService.updateProfile(sessionUser.getId(), dto, newImageFilename);

            if (updatedUser != null) {
                session.setAttribute("user", updatedUser);

                if (newImageFilename != null && oldImageFilename != null && !oldImageFilename.isEmpty()) {
                    deleteOldImage(oldImageFilename);
                }

                session.setAttribute("successMessage", "Cập nhật thông tin cá nhân thành công!");
                response.sendRedirect(request.getContextPath() + "/profile");
            } else {
                request.setAttribute("error", "Không tìm thấy thông tin tài khoản!");
                request.setAttribute("profileUser", userService.getProfile(sessionUser.getId()));
                request.getRequestDispatcher("/views/profile.jsp").forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("profileUser", userService.getProfile(sessionUser.getId()));
            request.getRequestDispatcher("/views/profile.jsp").forward(request, response);
        }
    }

    private String getSubmittedFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp != null) {
            for (String token : contentDisp.split(";")) {
                if (token.trim().startsWith("filename")) {
                    String filename = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                    int idx = filename.lastIndexOf('/');
                    if (idx >= 0) filename = filename.substring(idx + 1);
                    idx = filename.lastIndexOf('\\');
                    if (idx >= 0) filename = filename.substring(idx + 1);
                    return filename;
                }
            }
        }
        return null;
    }

    private void deleteOldImage(String oldFilename) {
        try {
            Path oldPath = Paths.get(AppConstant.UPLOAD_DIR, "users", oldFilename);
            Files.deleteIfExists(oldPath);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
