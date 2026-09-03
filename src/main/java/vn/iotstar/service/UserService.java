package vn.iotstar.service;

import jakarta.mail.MessagingException;
import vn.iotstar.constant.AppConstant;
import vn.iotstar.dao.UserDAO;
import vn.iotstar.entity.User;
import vn.iotstar.utils.EmailService;
import vn.iotstar.utils.PasswordUtil;

import java.util.Random;

/**
 * Tang Business Logic cho User.
 * Xu ly nghiep vu: dang nhap, dang ky, xac thuc OTP, quen mat khau.
 * 
 * QUAN TRONG:
 * - Password luon duoc hash truoc khi luu vao DB
 * - OTP co loai (ACTIVATION / RESET_PASSWORD) va thoi han het han
 */
public class UserService {
    private UserDAO userDAO = new UserDAO();

    /**
     * Xac thuc dang nhap.
     * 1. Tim user theo username
     * 2. So sanh password hash
     * @return User neu dang nhap thanh cong, null neu that bai
     */
    public User login(String username, String password) {
        if (username == null || username.trim().isEmpty()) return null;
        if (password == null || password.trim().isEmpty()) return null;

        // Tim user theo username
        User user = userDAO.findByUsername(username.trim());
        if (user == null) return null;

        // Kiem tra password hash
        if (PasswordUtil.checkPassword(password, user.getPassword())) {
            return user;
        }

        return null;
    }

    /**
     * Tim user theo username.
     */
    public User findByUsername(String username) {
        if (username == null || username.trim().isEmpty()) return null;
        return userDAO.findByUsername(username.trim());
    }

    /**
     * Tim user theo email.
     */
    public User findByEmail(String email) {
        if (email == null || email.trim().isEmpty()) return null;
        return userDAO.findByEmail(email.trim());
    }

    /**
     * Dang ky tai khoan moi.
     * - Hash password truoc khi luu
     * - Tao OTP voi type = ACTIVATION
     * - Gui OTP qua email
     * @return thong bao loi hoac null neu thanh cong
     */
    public String register(User user) {
        // Kiem tra trung username
        if (userDAO.findByUsername(user.getUsername()) != null) {
            return "Username da ton tai!";
        }
        // Kiem tra trung email
        if (userDAO.findByEmail(user.getEmail()) != null) {
            return "Email da duoc su dung!";
        }

        // === HASH PASSWORD ===
        user.setPassword(PasswordUtil.hashPassword(user.getPassword()));

        // Sinh OTP va set thoi han
        String otp = generateOtp();
        user.setOtp(otp);
        user.setOtpExpiredAt(System.currentTimeMillis() + AppConstant.OTP_EXPIRY_MINUTES * 60 * 1000L);
        user.setOtpType(AppConstant.OTP_TYPE_ACTIVATION);
        user.setActive(false);

        // Luu vao DB
        userDAO.insert(user);

        // Gui email OTP
        try {
            EmailService.sendOTP(user.getEmail(), otp, "Kich hoat tai khoan - JPA API");
        } catch (MessagingException e) {
            e.printStackTrace();
            return "Khong the gui email. Vui long thu lai!";
        }

        return null; // thanh cong
    }

    /**
     * Xac thuc OTP kich hoat tai khoan.
     * Kiem tra: OTP dung + chua het han + type = ACTIVATION
     * @return true neu OTP hop le
     */
    public boolean verifyOtp(String email, String otp) {
        User user = userDAO.findByEmail(email);
        if (user == null) return false;
        if (user.getOtp() == null) return false;
        if (!user.getOtp().equals(otp)) return false;
        if (System.currentTimeMillis() > user.getOtpExpiredAt()) return false;

        // Kiem tra loai OTP phai la ACTIVATION
        if (!AppConstant.OTP_TYPE_ACTIVATION.equals(user.getOtpType())) return false;

        // Kich hoat tai khoan
        userDAO.activateUser(email);
        return true;
    }

    /**
     * Gui OTP quen mat khau.
     * OTP type = RESET_PASSWORD
     * @return thong bao loi hoac null neu thanh cong
     */
    public String sendForgotPasswordOtp(String email) {
        User user = userDAO.findByEmail(email);
        if (user == null) {
            return "Email khong ton tai trong he thong!";
        }

        String otp = generateOtp();
        long expiredAt = System.currentTimeMillis() + AppConstant.OTP_EXPIRY_MINUTES * 60 * 1000L;
        userDAO.updateOtp(email, otp, expiredAt, AppConstant.OTP_TYPE_RESET_PASSWORD);

        try {
            EmailService.sendOTP(email, otp, "Dat lai mat khau - JPA API");
        } catch (MessagingException e) {
            e.printStackTrace();
            return "Khong the gui email. Vui long thu lai!";
        }

        return null; // thanh cong
    }

    /**
     * Xac thuc OTP quen mat khau va doi mat khau.
     * Kiem tra: OTP dung + chua het han + type = RESET_PASSWORD
     * Password moi se duoc hash truoc khi luu.
     * @return true neu thanh cong
     */
    public boolean resetPassword(String email, String otp, String newPassword) {
        User user = userDAO.findByEmail(email);
        if (user == null) return false;
        if (user.getOtp() == null || !user.getOtp().equals(otp)) return false;
        if (System.currentTimeMillis() > user.getOtpExpiredAt()) return false;

        // Kiem tra loai OTP phai la RESET_PASSWORD
        if (!AppConstant.OTP_TYPE_RESET_PASSWORD.equals(user.getOtpType())) return false;

        // === HASH PASSWORD MOI ===
        String hashedPassword = PasswordUtil.hashPassword(newPassword);
        userDAO.updatePassword(email, hashedPassword);
        return true;
    }

    /**
     * Gui lai OTP (resend).
     * Giu nguyen otpType cu, chi doi OTP va thoi han.
     */
    public String resendOtp(String email) {
        User user = userDAO.findByEmail(email);
        if (user == null) return "Email khong ton tai!";

        String otp = generateOtp();
        long expiredAt = System.currentTimeMillis() + AppConstant.OTP_EXPIRY_MINUTES * 60 * 1000L;

        // Giu nguyen otpType cu (ACTIVATION hoac RESET_PASSWORD)
        String otpType = user.getOtpType();
        if (otpType == null) {
            otpType = AppConstant.OTP_TYPE_ACTIVATION;
        }

        userDAO.updateOtp(email, otp, expiredAt, otpType);

        try {
            EmailService.sendOTP(email, otp, "Ma OTP moi - JPA API");
        } catch (MessagingException e) {
            e.printStackTrace();
            return "Khong the gui email!";
        }

        return null;
    }

    /**
     * Sinh ma OTP ngau nhien 6 chu so.
     */
    public String generateOtp() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000); // 100000 - 999999
        return String.valueOf(otp);
    }
}
