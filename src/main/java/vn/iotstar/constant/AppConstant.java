package vn.iotstar.constant;

/**
 * Cac hang so dung chung cho toan bo project.
 */
public class AppConstant {

    // === UPLOAD ===
    public static final String UPLOAD_DIR = "f:/Laptrinhweb/jpa_api/uploads";

    // === PAGINATION ===
    public static final int PAGE_SIZE = 6;
    public static final int NEWEST_PRODUCT_LIMIT = 10;

    // === OTP ===
    public static final int OTP_EXPIRY_MINUTES = 5;
    public static final String OTP_TYPE_ACTIVATION = "ACTIVATION";
    public static final String OTP_TYPE_RESET_PASSWORD = "RESET_PASSWORD";

    // === SESSION ===
    public static final int SESSION_TIMEOUT_MINUTES = 30;
    public static final String SESSION_USER_KEY = "user";
    public static final String SESSION_OTP_EMAIL = "otpEmail";
    public static final String SESSION_RESET_EMAIL = "resetEmail";
}
