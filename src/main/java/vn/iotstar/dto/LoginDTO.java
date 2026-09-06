package vn.iotstar.dto;

import jakarta.validation.constraints.NotBlank;

import java.io.Serializable;

/**
 * DTO cho form đăng nhập có validation annotations.
 */
public class LoginDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    @NotBlank(message = "Tên đăng nhập không được để trống!")
    private String username;

    @NotBlank(message = "Mật khẩu không được để trống!")
    private String password;

    public LoginDTO() {}

    public LoginDTO(String username, String password) {
        this.username = username;
        this.password = password;
    }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}
