package kabopok.server.repositories;

import kabopok.server.entities.Wishlist;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.UUID;

public interface WishlistRepository extends JpaRepository<Wishlist, UUID> {

  @Query("SELECT w.productID FROM Wishlist w WHERE w.userID = :userID")
  List<UUID> findProductIdByUserID(@Param("userID") UUID userID);

}
