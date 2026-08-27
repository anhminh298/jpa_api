package vn.iotstar.entity;

import java.io.Serializable;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Entity
@Table(name = "Videos")
@NamedQuery(name = "Video.findAll", query = "SELECT v FROM Video v")
public class Video implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "VideoId")
	private String videoId;

	@Column(name = "Active")
	private int active;

	@Column(name = "Description", columnDefinition = "nvarchar(500) null")
	private String description;

	@Column(name = "Poster", columnDefinition = "nvarchar(500) null")
	private String poster;

	@Column(name = "Title", columnDefinition = "nvarchar(500) null")
	private String title;

	@Column(name = "Views")
	private int views;

	// bi-directional many-to-one association to Category
	@ManyToOne
	@JoinColumn(name = "CategoryId")
	private Category category;

}
