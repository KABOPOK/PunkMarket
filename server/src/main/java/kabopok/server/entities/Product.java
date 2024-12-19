package kabopok.server.entities;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.ToString;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;


@Entity
@Table(name = "products")
@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString(exclude = "usersWishedBy")
@EqualsAndHashCode(exclude = {"usersWishedBy"})
public class Product {

  @Id
  @Column(name = "product_id", columnDefinition = "UUID")
  private UUID productID;

  @Column(name = "price", nullable = false)
  private String price;

  @Column(name = "title", nullable = false)
  private String title;

  @Column(name = "owner_name")
  private String ownerName;

  @Column(name = "photo_url")
  private String photoUrl;

  @Column(name = "location")
  private String location;

  @Column(name = "description", columnDefinition = "TEXT")
  private String description;

  @Column(name = "category")
  private String category;

  @Column(name = "is_sold")
  private Boolean isSold;

  @ManyToOne
  @JoinColumn(name = "user_id", referencedColumnName = "user_id")
  private User user;

  @ManyToMany(mappedBy = "productsWish")
  private List<User> usersWishedBy = new ArrayList<>();

}
