package vn.iotstar.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

import java.io.Serializable;

/**
 * DTO cho form đăng ký tài khoản có kèm Validation annotations.
 */
public class RegisterDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    @NotBlank(message = "Tên đăng nhập không được để trống!")
    @Size(min = 3, max = 30, message = "Tên đăng nhập phải từ 3 đến 30 ký tự!")
    @Pattern(regexp = "^[a-zA-Z0-9_]+$", message = "Tên đăng nhập chỉ được chứa chữ cái, số và dấu gạch dưới!")
    private String username;

    @NotBlank(message = "Mật khẩu không được để trống!")
    @Size(min = 6, message = "Mật khẩu phải có ít nhất 6 ký tự!")
    private String password;

    @NotBlank(message = "Xác nhận mật khẩu không được để trống!")
    private String confirmPassword;

    @NotBlank(message = "Họ và tên không được để trống!")
    @Size(min = 2, max = 100, message = "Họ và tên phải từ 2 đến 100 ký tự!")
    private String fullname;

    @NotBlank(message = "Email không được để trống!")
    @Email(message = "Định dạng email không hợp lệ!")
    private String email;

    public RegisterDTO() {}

    public RegisterDTO(String username, String password, String confirmPassword, String fullname, String email) {
        this.username = username;
        this.password = password;
        this.confirmPassword = confirmPassword;
        this.fullname = fullname;
        this.email = email;
    }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getConfirmPassword() { return confirmPassword; }
    public void setConfirmPassword(String confirmPassword) { this.confirmPassword = confirmPassword; }

    public String getFullname() { return fullname; }
    public void setFullname(String fullname) { this.fullname = fullname; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}
