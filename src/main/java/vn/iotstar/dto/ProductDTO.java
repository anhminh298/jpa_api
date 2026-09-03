package vn.iotstar.dto;

import java.io.Serializable;

/**
 * DTO cho form them/sua san pham.
 */
public class ProductDTO implements Serializable {
    private int id;
    private String name;
    private double price;
    private int quantity;
    private String description;
    private int categoryId;
    private String imageUrl;

    public ProductDTO() {}

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
