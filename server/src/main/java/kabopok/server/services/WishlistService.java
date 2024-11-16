package kabopok.server.services;

import kabopok.server.entities.Wishlist;
import kabopok.server.repositories.WishlistRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class WishlistService {

  private final WishlistRepository wishlistRepository;

  public List<UUID> getWishlist(UUID userId, UUID productId) {
      return wishlistRepository.findProductIdByUserID(userId);
  }

    public void save(UUID userId, UUID productId) {
        UUID wishlistID = UUID.randomUUID();
        Wishlist wishlist = new Wishlist(wishlistID, userId, productId);
        wishlistRepository.save(wishlist);
    }
}
