package vn.iotstar.dao;

import vn.iotstar.entity.User;
import vn.iotstar.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * UserDAO - Truy van database bang JDBC.
 * Thuoc tang Data Access trong kien truc 3 tang.
 * 
 * User dung JDBC (khong dung JPA) de the hien su khac biet
 * giua 2 cach truy cap database.
 */
public class UserDAO {

    /**
     * Chuyen doi 1 dong ResultSet thanh object User.
     */
    private User extractUser(ResultSet rs) throws Exception {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setFullname(rs.getString("fullname"));
        user.setEmail(rs.getString("email"));
        user.setActive(rs.getBoolean("isActive"));
        user.setOtp(rs.getString("otp"));
        user.setOtpExpiredAt(rs.getLong("otpExpiredAt"));
        user.setOtpType(rs.getString("otpType"));
        return user;
    }

    /**
     * Tim user theo username.
     * Dung cho dang nhap: tim user -> verify password hash o tang Service.
     */
    public User findByUsername(String username) {
        String sql = "SELECT * FROM users WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractUser(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Tim user theo email.
     */
    public User findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractUser(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Them user moi vao database (isActive = false, chua kich hoat).
     * Password phai duoc hash TRUOC khi goi method nay.
     */
    public void insert(User user) {
        String sql = "INSERT INTO users (username, password, fullname, email, isActive, otp, otpExpiredAt, otpType) "
                   + "VALUES (?, ?, ?, ?, 0, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getFullname());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getOtp());
            ps.setLong(6, user.getOtpExpiredAt());
            ps.setString(7, user.getOtpType());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Cap nhat OTP, thoi han, va loai OTP cho user.
     */
    public void updateOtp(String email, String otp, long expiredAt, String otpType) {
        String sql = "UPDATE users SET otp = ?, otpExpiredAt = ?, otpType = ? WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, otp);
            ps.setLong(2, expiredAt);
            ps.setString(3, otpType);
            ps.setString(4, email);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Kich hoat tai khoan (set isActive = true, xoa OTP).
     */
    public void activateUser(String email) {
        String sql = "UPDATE users SET isActive = 1, otp = NULL, otpExpiredAt = NULL, otpType = NULL WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Cap nhat mat khau moi (da hash) va xoa OTP.
     */
    public void updatePassword(String email, String hashedPassword) {
        String sql = "UPDATE users SET password = ?, otp = NULL, otpExpiredAt = NULL, otpType = NULL WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashedPassword);
            ps.setString(2, email);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
