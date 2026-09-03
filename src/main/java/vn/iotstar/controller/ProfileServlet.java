package vn.iotstar.controller;

import vn.iotstar.constant.AppConstant;
import vn.iotstar.dto.UpdateProfileDTO;
import vn.iotstar.entity.User;
import vn.iotstar.service.UserService;

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
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

/**
 * Servlet xu ly Profile user.
 * 
 * GET /profile  -> Hien thi trang profile
 * POST /profile -> Cap nhat profile (fullname, phone, avatar)
 * 
 * Su dung @MultipartConfig de ho tro upload file.
 * File avatar duoc luu vao thu muc uploads/users/ tren server.
 * Database chi luu ten file (khong luu file truc tiep).
 */
@WebServlet("/profile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1 MB - bat dau ghi ra disk
    maxFileSize = 2 * 1024 * 1024,         // 2 MB - gioi han 1 file
    maxRequestSize = 5 * 1024 * 1024       // 5 MB - tong request
)
public class ProfileServlet extends HttpServlet {

    private UserService userService = new UserService();

    // Cac dinh dang anh cho phep
    private static final List<String> ALLOWED_EXTENSIONS = Arrays.asList("jpg", "jpeg", "png", "webp");

    // Kich thuoc toi da (2MB)
    private static final long MAX_FILE_SIZE = 2 * 1024 * 1024;

    /**
     * GET /profile - Hien thi trang profile.
     * 
     * Workflow:
     * AuthFilter -> ProfileServlet -> UserService -> UserDAO -> JPA -> SQL Server
     *            -> profile.jsp -> SiteMesh -> Browser
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lay user tu session (da duoc AuthFilter kiem tra)
        HttpSession session = request.getSession(false);
        User sessionUser = (User) session.getAttribute("user");

        // Lay thong tin moi nhat tu DB
        User user = userService.getProfile(sessionUser.getId());
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login-session");
            return;
        }

        // Dat user vao request attribute de JSP hien thi
        request.setAttribute("profileUser", user);

        // Forward den profile.jsp
        request.getRequestDispatcher("/views/profile.jsp").forward(request, response);
    }

    /**
     * POST /profile - Cap nhat profile.
     * 
     * Workflow:
     * Browser (multipart/form-data) -> ProfileServlet
     *   -> Lay fullname, phone
     *   -> Lay Part image
     *   -> Validate file (extension, size)
     *   -> Generate unique filename
     *   -> Save file vao uploads/users/
     *   -> UserService.updateProfile()
     *   -> Cap nhat session
     *   -> Xoa anh cu (neu co)
     *   -> Redirect GET /profile
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Lay user tu session
        HttpSession session = request.getSession(false);
        User sessionUser = (User) session.getAttribute("user");

        // Lay thong tin tu form
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");

        // Tao DTO
        UpdateProfileDTO dto = new UpdateProfileDTO(fullname, phone);

        // ====== XU LY UPLOAD ANH ======
        String newImageFilename = null;
        String oldImageFilename = null;
        Part imagePart = null;

        try {
            imagePart = request.getPart("image");
        } catch (Exception e) {
            // Khong co file upload - khong sao
        }

        if (imagePart != null && imagePart.getSize() > 0) {
            // Lay ten file goc
            String originalFilename = getSubmittedFileName(imagePart);

            if (originalFilename != null && !originalFilename.isEmpty()) {
                // Lay extension
                String extension = getFileExtension(originalFilename).toLowerCase();

                // Validate extension
                if (!ALLOWED_EXTENSIONS.contains(extension)) {
                    request.setAttribute("error", "Chi chap nhan file: JPG, JPEG, PNG, WEBP!");
                    request.setAttribute("profileUser", userService.getProfile(sessionUser.getId()));
                    request.getRequestDispatcher("/views/profile.jsp").forward(request, response);
                    return;
                }

                // Validate size
                if (imagePart.getSize() > MAX_FILE_SIZE) {
                    request.setAttribute("error", "File khong duoc vuot qua 2MB!");
                    request.setAttribute("profileUser", userService.getProfile(sessionUser.getId()));
                    request.getRequestDispatcher("/views/profile.jsp").forward(request, response);
                    return;
                }

                // Luu ten anh cu de xoa sau
                User currentUser = userService.getProfile(sessionUser.getId());
                if (currentUser != null) {
                    oldImageFilename = currentUser.getImage();
                }

                // Generate unique filename: user_{id}_{uuid}.{ext}
                String uuid = UUID.randomUUID().toString().substring(0, 8);
                newImageFilename = "user_" + sessionUser.getId() + "_" + uuid + "." + extension;

                // Save file vao uploads/users/
                String uploadDir = AppConstant.UPLOAD_DIR + "/users";
                Path uploadPath = Paths.get(uploadDir);

                // Tao thu muc neu chua co
                if (!Files.exists(uploadPath)) {
                    Files.createDirectories(uploadPath);
                }

                // Luu file
                Path filePath = uploadPath.resolve(newImageFilename);
                try (InputStream input = imagePart.getInputStream()) {
                    Files.copy(input, filePath, StandardCopyOption.REPLACE_EXISTING);
                }
            }
        }

        // ====== CAP NHAT PROFILE ======
        try {
            User updatedUser = userService.updateProfile(sessionUser.getId(), dto, newImageFilename);

            if (updatedUser != null) {
                // Cap nhat session voi user moi (QUAN TRONG!)
                session.setAttribute("user", updatedUser);

                // Xoa anh cu (neu upload anh moi thanh cong)
                if (newImageFilename != null && oldImageFilename != null && !oldImageFilename.isEmpty()) {
                    deleteOldImage(oldImageFilename);
                }

                // Redirect ve GET /profile (PRG pattern)
                response.sendRedirect(request.getContextPath() + "/profile?success=1");
            } else {
                request.setAttribute("error", "Khong tim thay user!");
                request.setAttribute("profileUser", userService.getProfile(sessionUser.getId()));
                request.getRequestDispatcher("/views/profile.jsp").forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            // Loi validate tu UserService
            request.setAttribute("error", e.getMessage());
            request.setAttribute("profileUser", userService.getProfile(sessionUser.getId()));
            request.getRequestDispatcher("/views/profile.jsp").forward(request, response);
        }
    }

    /**
     * Lay ten file goc tu Part.
     */
    private String getSubmittedFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp != null) {
            for (String token : contentDisp.split(";")) {
                if (token.trim().startsWith("filename")) {
                    String filename = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                    // Lay ten file (bo duong dan neu co)
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

    /**
     * Lay extension cua file (vd: "jpg", "png").
     */
    private String getFileExtension(String filename) {
        int dotIndex = filename.lastIndexOf('.');
        if (dotIndex > 0 && dotIndex < filename.length() - 1) {
            return filename.substring(dotIndex + 1);
        }
        return "";
    }

    /**
     * Xoa file anh cu khoi server.
     * Chi xoa sau khi upload anh moi thanh cong.
     */
    private void deleteOldImage(String oldFilename) {
        try {
            Path oldPath = Paths.get(AppConstant.UPLOAD_DIR, "users", oldFilename);
            Files.deleteIfExists(oldPath);
        } catch (IOException e) {
            // Khong can throw exception neu xoa that bai
            e.printStackTrace();
        }
    }
}
