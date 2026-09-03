package vn.iotstar.entity;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotEmpty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Data
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
