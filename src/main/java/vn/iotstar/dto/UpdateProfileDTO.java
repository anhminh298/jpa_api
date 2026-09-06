package vn.iotstar.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

import java.io.Serializable;

/**
 * DTO cho form update profile có validation annotations.
 */
public class UpdateProfileDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    @NotBlank(message = "Họ và tên không được để trống!")
    @Size(min = 2, max = 100, message = "Họ và tên phải từ 2 đến 100 ký tự!")
    private String fullname;

    @Pattern(regexp = "^(0|\\+84)(3[2-9]|5[25689]|7[06-9]|8[1-9]|9[0-9])[0-9]{7}$|^$", 
             message = "Số điện thoại không hợp lệ (10 chữ số di động VN)!")
    private String phone;

    public UpdateProfileDTO() {}

    public UpdateProfileDTO(String fullname, String phone) {
        this.fullname = fullname;
        this.phone = phone;
    }

    public String getFullname() { return fullname; }
    public void setFullname(String fullname) { this.fullname = fullname; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
}
