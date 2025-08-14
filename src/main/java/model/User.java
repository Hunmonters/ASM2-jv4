package model;
import jakarta.persistence.*;
import lombok.*;
import java.util.List;
import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "[User]")
public class User {
    @Id
    private String id;

    private String password;
    private String email;
    private String fullname;
    private Boolean admin;

    @OneToMany(mappedBy = "user")
    @JsonIgnore
    private List<Favorite> favorites;

    @OneToMany(mappedBy = "user")
    @JsonIgnore
    private List<Share> shares;
    
    public User(String id, String password, String email, String fullname, boolean admin) {
        this.id = id;
        this.password = password;
        this.email = email;
        this.fullname = fullname;
        this.admin = admin;
    }

}
