package kabopok.server.entities;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.UUID;

@Entity
@Table(name = "products")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Product {

  @Id
  @GeneratedValue(strategy = GenerationType.AUTO)
  @Column(name = "product_id", columnDefinition = "UUID")
  private UUID productID; // UUID for unique identification

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

  @Column(name = "user_id")
  private UUID userID;
}

