package vn.iotstar.entity;

import java.io.Serializable;

/**
 * Model class dai dien cho bang users trong database.
 * Day la thanh phan Model trong mo hinh MVC.
 * 
 * Su dung JDBC (khong dung JPA) de the hien su khac biet
 * giua 2 cach tiep can: JDBC vs JPA.
 * 
 * OTP fields:
 * - otp: ma OTP 6 chu so
 * - otpExpiredAt: thoi gian het han OTP (epoch millis)
 * - otpType: loai OTP (ACTIVATION hoac RESET_PASSWORD)
 */
public class User implements Serializable {
    private int id;
    private String username;
    private String password;       // Luu dang hash (SHA-256 + salt)
    private String fullname;
    private String email;
    private boolean isActive;      // Tai khoan da kich hoat chua

    // OTP fields
    private String otp;            // Ma OTP 6 chu so
    private long otpExpiredAt;     // Thoi gian het han OTP (epoch millis)
    private String otpType;        // ACTIVATION hoac RESET_PASSWORD

    // Constructor mac dinh
    public User() {}

    // Constructor day du (khong bao gom OTP)
    public User(int id, String username, String password, String fullname, String email) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.fullname = fullname;
        this.email = email;
    }

    // Getter va Setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getFullname() { return fullname; }
    public void setFullname(String fullname) { this.fullname = fullname; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public String getOtp() { return otp; }
    public void setOtp(String otp) { this.otp = otp; }

    public long getOtpExpiredAt() { return otpExpiredAt; }
    public void setOtpExpiredAt(long otpExpiredAt) { this.otpExpiredAt = otpExpiredAt; }

    public String getOtpType() { return otpType; }
    public void setOtpType(String otpType) { this.otpType = otpType; }
}
