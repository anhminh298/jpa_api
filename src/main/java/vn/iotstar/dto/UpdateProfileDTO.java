package vn.iotstar.dto;

import java.io.Serializable;

/**
 * DTO cho form update profile.
 * Chi chua cac truong cho phep user chinh sua.
 * 
 * Multipart Part (file upload) khong dat trong DTO,
 * Servlet xu ly upload rieng.
 */
public class UpdateProfileDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private String fullname;
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
