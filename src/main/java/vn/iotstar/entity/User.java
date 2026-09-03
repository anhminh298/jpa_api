package vn.iotstar.entity;

import java.io.Serializable;

import jakarta.persistence.*;

/**
 * JPA Entity dai dien cho bang users trong database.
 * Day la thanh phan Model trong mo hinh MVC.
 * 
 * Da chuyen tu JDBC sang JPA de ho tro Profile feature.
 * 
 * OTP fields:
 * - otp: ma OTP 6 chu so
 * - otpExpiredAt: thoi gian het han OTP (epoch millis)
 * - otpType: loai OTP (ACTIVATION hoac RESET_PASSWORD)
 */
@Entity
@Table(name = "users")
public class User implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "username", columnDefinition = "nvarchar(100)")
    private String username;

    @Column(name = "password", columnDefinition = "nvarchar(500)")
    private String password;       // Luu dang hash (SHA-256 + salt)

    @Column(name = "fullname", columnDefinition = "nvarchar(200)")
    private String fullname;

    @Column(name = "email", columnDefinition = "nvarchar(200)")
    private String email;

    @Column(name = "phone", columnDefinition = "nvarchar(20)")
    private String phone;

    @Column(name = "image", columnDefinition = "nvarchar(500)")
    private String image;

    @Column(name = "isActive")
    private boolean isActive;      // Tai khoan da kich hoat chua

    // OTP fields
    @Column(name = "otp", columnDefinition = "nvarchar(10)")
    private String otp;            // Ma OTP 6 chu so

    @Column(name = "otpExpiredAt")
    private Long otpExpiredAt;     // Thoi gian het han OTP (epoch millis), dung Long de chap nhan null

    @Column(name = "otpType", columnDefinition = "nvarchar(50)")
    private String otpType;        // ACTIVATION hoac RESET_PASSWORD

    // Constructor mac dinh
    public User() {}

    // Constructor day du (khong bao gom OTP, phone, image)
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

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public String getOtp() { return otp; }
    public void setOtp(String otp) { this.otp = otp; }

    public Long getOtpExpiredAt() { return otpExpiredAt; }
    public void setOtpExpiredAt(Long otpExpiredAt) { this.otpExpiredAt = otpExpiredAt; }

    public String getOtpType() { return otpType; }
    public void setOtpType(String otpType) { this.otpType = otpType; }
}
