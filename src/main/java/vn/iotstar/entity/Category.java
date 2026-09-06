package vn.iotstar.entity;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotEmpty;

@Entity
@Table(name = "categories")
@NamedQuery(name = "Category.findAll", query = "SELECT c FROM Category c")
public class Category implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "CategoryId")
	private int categoryid;

	@Column(name = "CategoryName", columnDefinition = "nvarchar(50) not null")
	@NotEmpty(message = "Không được phép rỗng")
	private String categoryname;

	@Column(name = "description", columnDefinition = "nvarchar(500) null")
	private String description;

	@Column(name = "Images", columnDefinition = "nvarchar(500) null")
	private String images;

	private int status;

	@Column(name = "createdAt")
	@Temporal(TemporalType.TIMESTAMP)
	private Date createdAt;

	// bi-directional many-to-one association to Video
	@OneToMany(mappedBy = "category")
	private List<Video> videos;

	// bi-directional many-to-one association to Product
	@OneToMany(mappedBy = "category")
	private List<Product> products;

	public Category() {}

	public Category(int categoryid, String categoryname, String description, String images, int status,
			Date createdAt, List<Video> videos, List<Product> products) {
		this.categoryid = categoryid;
		this.categoryname = categoryname;
		this.description = description;
		this.images = images;
		this.status = status;
		this.createdAt = createdAt;
		this.videos = videos;
		this.products = products;
	}

	public int getCategoryid() { return categoryid; }
	public void setCategoryid(int categoryid) { this.categoryid = categoryid; }

	// Alias for JSP EL convenience
	public int getCategoryId() { return categoryid; }
	public void setCategoryId(int categoryId) { this.categoryid = categoryId; }

	public String getCategoryname() { return categoryname; }
	public void setCategoryname(String categoryname) { this.categoryname = categoryname; }

	// Alias for JSP EL convenience
	public String getCategoryName() { return categoryname; }
	public void setCategoryName(String categoryName) { this.categoryname = categoryName; }

	public String getDescription() { return description; }
	public void setDescription(String description) { this.description = description; }

	public String getImages() { return images; }
	public void setImages(String images) { this.images = images; }

	public int getStatus() { return status; }
	public void setStatus(int status) { this.status = status; }

	public Date getCreatedAt() { return createdAt; }
	public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

	public List<Video> getVideos() { return videos; }
	public void setVideos(List<Video> videos) { this.videos = videos; }

	public List<Product> getProducts() { return products; }
	public void setProducts(List<Product> products) { this.products = products; }

	@PrePersist
	protected void onCreate() {
		if (createdAt == null) {
			createdAt = new Date();
		}
	}

	public Video addVideo(Video video) {
		getVideos().add(video);
		video.setCategory(this);
		return video;
	}

	public Video removeVideo(Video video) {
		getVideos().remove(video);
		video.setCategory(null);
		return video;
	}

}
