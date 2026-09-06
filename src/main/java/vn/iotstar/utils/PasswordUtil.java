package vn.iotstar.utils;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Utility class ma hoa mat khau bang SHA-256 + salt.
 * 
 * Quy trinh:
 * 1. Tao salt ngau nhien (16 bytes)
 * 2. Hash: SHA-256(salt + password)
 * 3. Luu vao DB: salt:hash (Base64)
 * 
 * Khi kiem tra:
 * 1. Tach salt va hash tu chuoi da luu
 * 2. Hash lai password voi salt cu
 * 3. So sanh 2 hash
 */
public class PasswordUtil {

    private static final int SALT_LENGTH = 16;

    /**
     * Ma hoa mat khau.
     * @param password mat khau dang plaintext
     * @return chuoi "salt:hash" (Base64 encoded)
     */
    public static String hashPassword(String password) {
        try {
            // 1. Tao salt ngau nhien
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[SALT_LENGTH];
            random.nextBytes(salt);

            // 2. Hash password voi salt
            byte[] hash = hash(salt, password);

            // 3. Encode thanh string: salt:hash
            String saltBase64 = Base64.getEncoder().encodeToString(salt);
            String hashBase64 = Base64.getEncoder().encodeToString(hash);

            return saltBase64 + ":" + hashBase64;
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Khong ho tro SHA-256!", e);
        }
    }

    /**
     * Kiem tra mat khau co khop voi hash da luu khong.
     * @param password mat khau nguoi dung nhap
     * @param storedHash chuoi "salt:hash" da luu trong DB
     * @return true neu khop
     */
    public static boolean checkPassword(String password, String storedHash) {
        if (password == null || storedHash == null) return false;
        try {
            // Neu mat khau trong DB chua duoc hash (nhu user mau tao truc tiep tu SQL)
            if (!storedHash.contains(":")) {
                return password.equals(storedHash);
            }

            // Tach salt va hash
            String[] parts = storedHash.split(":");
            if (parts.length != 2) return false;

            byte[] salt = Base64.getDecoder().decode(parts[0]);
            byte[] expectedHash = Base64.getDecoder().decode(parts[1]);

            // Hash lai password voi salt cu
            byte[] actualHash = hash(salt, password);

            // So sanh 2 hash (constant-time de chong timing attack)
            return MessageDigest.isEqual(expectedHash, actualHash);
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Hash noi bo: SHA-256(salt + password bytes).
     */
    private static byte[] hash(byte[] salt, String password) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        md.update(salt);
        md.update(password.getBytes(StandardCharsets.UTF_8));
        return md.digest();
    }
}
