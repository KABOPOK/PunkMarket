package kabopok.server.entities;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Entity
@Table(name = "wishlists")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Wishlist {

  @Id
  @Column(name = "wishlist_id", columnDefinition = "UUID")
  private UUID wishlistID;

  @Column(name = "user_id", columnDefinition = "UUID", nullable = false)
  private UUID userID;

  @Column(name = "product_id", columnDefinition = "UUID", nullable = false)
  private UUID productID;

}
