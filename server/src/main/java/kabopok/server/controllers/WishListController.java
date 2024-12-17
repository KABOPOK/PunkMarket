package kabopok.server.controllers;

import generated.kabopok.server.api.WishListApi;
import generated.kabopok.server.api.model.ProductDTO;
import kabopok.server.mappers.ProductMapper;
import kabopok.server.services.WishListService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
public class WishListController implements WishListApi {

  private final WishListService wishListService;

  private final ProductMapper productMapper;
  @Override
  public Boolean saveToWishlist(UUID userId, UUID productId) {
    return wishListService.addToWishList(userId, productId);
  }

  @Override
  public List<ProductDTO> getWishlist(String userId) {
    return productMapper.map(wishListService.getMyFavProducts(UUID.fromString(userId)));
  }

}
