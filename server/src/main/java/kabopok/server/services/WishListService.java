package kabopok.server.services;

import kabopok.server.entities.Product;
import kabopok.server.entities.User;
import kabopok.server.repositories.ProductRepository;
import kabopok.server.repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class WishListService extends DefaultService {

  private final ProductRepository productRepository;
  private final UserRepository userRepository;

  public Boolean addToWishList(UUID userId, UUID productId) {
    User user = getOrThrow(userId, userRepository::findById);
    Product product = getOrThrow(productId, productRepository::findById);
    boolean heartState = false;
    if(user.getProductsWish().contains(product)){
      user.getProductsWish().remove(product);
    } else {
      heartState = true;
      user.getProductsWish().add(product);
    }
    userRepository.save(user);
    return heartState;
  }

  public List<Product> getMyFavProducts(UUID userId){
    User user = getOrThrow(userId, userRepository::findById);
    return user.getProductsWish();
  }
}
