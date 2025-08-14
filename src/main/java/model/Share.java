package model;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Share {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "UserId")
    @JsonIgnore
    private User user;

    @ManyToOne
    @JoinColumn(name = "VideoId")
    @JsonIgnore
    private Video video;

    private String emails;

    private LocalDate  shareDate;
}
