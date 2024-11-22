package kabopok.server.entities;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;


@Entity
@Table(name = "products")
@Data
@AllArgsConstructor
@NoArgsConstructor
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

  @ManyToOne
  @JoinColumn(name = "user_id", referencedColumnName = "user_id")
  private User user;

//  @ManyToMany(mappedBy = "productsWish")
//  private Set<User> usersWishedBy = new HashSet<>();

}
