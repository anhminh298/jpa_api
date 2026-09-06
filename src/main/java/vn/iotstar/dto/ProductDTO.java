package vn.iotstar.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

import java.io.Serializable;

/**
 * DTO cho form thêm / sửa sản phẩm có kèm Validation annotations.
 */
public class ProductDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;

    @NotBlank(message = "Tên sản phẩm không được để trống!")
    @Size(min = 2, max = 255, message = "Tên sản phẩm phải từ 2 đến 255 ký tự!")
    private String name;

    @Positive(message = "Giá sản phẩm phải lớn hơn 0!")
    private double price;

    @Min(value = 0, message = "Số lượng sản phẩm không được âm!")
    private int quantity;

    @Size(max = 1000, message = "Mô tả không được vượt quá 1000 ký tự!")
    private String description;

    @Min(value = 1, message = "Vui lòng chọn một danh mục hợp lệ!")
    private int categoryId;

    private String imageUrl;

    public ProductDTO() {}

    public ProductDTO(String name, double price, int quantity, String description, int categoryId) {
        this.name = name;
        this.price = price;
        this.quantity = quantity;
        this.description = description;
        this.categoryId = categoryId;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
}
