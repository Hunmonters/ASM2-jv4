package model;
import jakarta.persistence.*;
import lombok.*;
import java.util.List;
import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Video {
    @Id
    private String id;

    private String title;
    private String poster;
    private Integer views;

    @Column(columnDefinition = "NVARCHAR(MAX)")
    private String description;

    private Boolean active;

    @OneToMany(mappedBy = "video")
    @JsonIgnore
    private List<Favorite> favorites;

    @OneToMany(mappedBy = "video")
    @JsonIgnore
    private List<Share> shares;
    
    public Video(String id, String title, String poster, Integer views, String description, Boolean active) {
        this.id = id;
        this.title = title;
        this.poster = poster;
        this.views = views;
        this.description = description;
        this.active = active;
    }

}
