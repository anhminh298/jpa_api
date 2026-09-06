package vn.iotstar.utils;

import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.ValidatorFactory;

import java.util.*;
import java.util.regex.Pattern;

/**
 * Lớp tiện ích kiểm tra dữ liệu (Validation Utility).
 * Tích hợp Jakarta Bean Validation (Hibernate Validator)
 * và các phương thức kiểm tra định dạng dữ liệu an toàn.
 */
public class ValidationUtil {

    private static final Validator validator;

    // Pattern kiểm tra email RFC 5322 cơ bản
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
    );

    // Pattern số điện thoại Việt Nam (10 chữ số, bắt đầu 03, 05, 07, 08, 09 hoặc +84)
    private static final Pattern VN_PHONE_PATTERN = Pattern.compile(
            "^(0|\\+84)(3[2-9]|5[25689]|7[06-9]|8[1-9]|9[0-9])[0-9]{7}$"
    );

    // Các phần mở rộng ảnh được phép
    private static final Set<String> ALLOWED_IMAGE_EXTENSIONS = new HashSet<>(
            Arrays.asList("jpg", "jpeg", "png", "webp", "gif")
    );

    // Kích thước tối đa của file ảnh (2MB)
    public static final long MAX_IMAGE_FILE_SIZE = 2 * 1024 * 1024;

    static {
        ValidatorFactory factory = Validation.buildDefaultValidatorFactory();
        validator = factory.getValidator();
    }

    /**
     * Kiểm tra đối tượng bằng Jakarta Bean Validation annotations.
     * @param object đối tượng cần kiểm tra (Entity / DTO)
     * @return Map chứa key là tên thuộc tính và value là câu thông báo lỗi
     */
    public static <T> Map<String, String> validate(T object) {
        Map<String, String> errors = new LinkedHashMap<>();
        if (object == null) {
            errors.put("global", "Dữ liệu không được để trống!");
            return errors;
        }

        Set<ConstraintViolation<T>> violations = validator.validate(object);
        for (ConstraintViolation<T> violation : violations) {
            String property = violation.getPropertyPath().toString();
            String message = violation.getMessage();
            // Nếu thuộc tính chưa có lỗi, lưu lại lỗi đầu tiên
            errors.putIfAbsent(property, message);
        }
        return errors;
    }

    /**
     * Lấy thông báo lỗi đầu tiên (nếu có)
     */
    public static <T> String getFirstError(T object) {
        Map<String, String> errors = validate(object);
        if (!errors.isEmpty()) {
            return errors.values().iterator().next();
        }
        return null;
    }

    /**
     * Kiểm tra chuỗi có chứa ký tự thực sự (không rỗng và không toàn khoảng trắng)
     */
    public static boolean isNotBlank(String str) {
        return str != null && !str.trim().isEmpty();
    }

    /**
     * Kiểm tra định dạng Email hợp lệ
     */
    public static boolean isValidEmail(String email) {
        if (!isNotBlank(email)) return false;
        return EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    /**
     * Kiểm tra số điện thoại Việt Nam hợp lệ (10 chữ số)
     */
    public static boolean isValidPhone(String phone) {
        if (!isNotBlank(phone)) return false;
        String cleanPhone = phone.trim().replaceAll("\\s+", "");
        return VN_PHONE_PATTERN.matcher(cleanPhone).matches();
    }

    /**
     * Kiểm tra định dạng file ảnh qua tên file
     */
    public static boolean isValidImageExtension(String filename) {
        if (!isNotBlank(filename)) return false;
        int dotIndex = filename.lastIndexOf('.');
        if (dotIndex <= 0 || dotIndex >= filename.length() - 1) return false;
        String ext = filename.substring(dotIndex + 1).toLowerCase();
        return ALLOWED_IMAGE_EXTENSIONS.contains(ext);
    }

    /**
     * Parse số nguyên an toàn, trả về defaultValue nếu sai định dạng
     */
    public static int parseIntSafe(String str, int defaultValue) {
        if (!isNotBlank(str)) return defaultValue;
        try {
            return Integer.parseInt(str.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    /**
     * Parse số thực an toàn, trả về defaultValue nếu sai định dạng
     */
    public static double parseDoubleSafe(String str, double defaultValue) {
        if (!isNotBlank(str)) return defaultValue;
        try {
            return Double.parseDouble(str.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
}
