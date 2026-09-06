package vn.iotstar.entity;

import java.io.Serializable;
import java.util.Date;

import jakarta.persistence.*;

@Entity
@Table(name = "products")
@NamedQuery(name = "Product.findAll", query = "SELECT p FROM Product p")
public class Product implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	private int id;

	@Column(name = "name", columnDefinition = "nvarchar(200) not null")
	private String name;

	@Column(name = "price")
	private double price;

	@Column(name = "quantity")
	private int quantity;

	@Column(name = "description", columnDefinition = "nvarchar(max) null")
	private String description;

	@Column(name = "image", columnDefinition = "nvarchar(500) null")
	private String image;

	@Column(name = "createdDate")
	@Temporal(TemporalType.TIMESTAMP)
	private Date createdDate;

	@Column(name = "updatedDate")
	@Temporal(TemporalType.TIMESTAMP)
	private Date updatedDate;

	// Quan he N-1 voi Category
	@ManyToOne
	@JoinColumn(name = "CategoryId")
	private Category category;

	public Product() {}

	public Product(int id, String name, double price, int quantity, String description, String image,
			Date createdDate, Date updatedDate, Category category) {
		this.id = id;
		this.name = name;
		this.price = price;
		this.quantity = quantity;
		this.description = description;
		this.image = image;
		this.createdDate = createdDate;
		this.updatedDate = updatedDate;
		this.category = category;
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

	public String getImage() { return image; }
	public void setImage(String image) { this.image = image; }

	public Date getCreatedDate() { return createdDate; }
	public void setCreatedDate(Date createdDate) { this.createdDate = createdDate; }

	public Date getUpdatedDate() { return updatedDate; }
	public void setUpdatedDate(Date updatedDate) { this.updatedDate = updatedDate; }

	public Category getCategory() { return category; }
	public void setCategory(Category category) { this.category = category; }

	@PrePersist
	protected void onCreate() {
		if (createdDate == null) {
			createdDate = new Date();
		}
	}

	@PreUpdate
	protected void onUpdate() {
		updatedDate = new Date();
	}
}
