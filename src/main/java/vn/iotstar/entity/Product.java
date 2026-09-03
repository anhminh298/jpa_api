package vn.iotstar.entity;

import java.io.Serializable;
import java.util.Date;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Data
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
