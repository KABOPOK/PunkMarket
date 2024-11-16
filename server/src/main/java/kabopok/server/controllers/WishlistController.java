package kabopok.server.controllers;

import generated.kabopok.server.api.WishlistApi;
import kabopok.server.services.WishlistService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RestController
@RequiredArgsConstructor
public class WishlistController implements WishlistApi {

  private final WishlistService wishlistService;

  @Override
  public void saveToWishlist(UUID userId, UUID productId) {
    wishlistService.save(userId, productId);
  }

}
