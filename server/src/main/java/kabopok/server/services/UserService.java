package kabopok.server.services;

import generated.kabopok.server.api.model.LoginDataDTO;
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
public class UserService extends DefaultService {

  private final UserRepository userRepository;
  private final ProductRepository productRepository;
  public UUID save(User user) {
    UUID userID = UUID.randomUUID();
    user.setUserID(userID);
    user.setPhotoUrl(userID.toString());
    userRepository.save(user);
    return userID;
  }

  public User findByNumber(LoginDataDTO loginDataDTO){
    User current = getOrThrow(loginDataDTO.getNumber(),userRepository::findByNumber);
    if(!current.getPassword().equals(loginDataDTO.getPassword())){
      throw new RuntimeException("Wrong answer");
    }
    return current;
  }

  public User findById(UUID userId){
    return getOrThrow(userId, userRepository::findById);
  }

  public User deleteUser(UUID userId){
    User deletedUser = getOrThrow(userId, userRepository::findById);
    userRepository.delete(deletedUser);
    return  deletedUser;
  }

  public User updateUser(UUID userId, User updatedUser){
    User user = getOrThrow(userId, userRepository::findById);
    updatedUser.setUserID(user.getUserID());
    userRepository.save(updatedUser);
    return updatedUser;
  }

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
    User user = getOrThrow(userId,userRepository::findById);
    return user.getProductsWish().stream().toList();
  }

}
