package kabopok.server.services;

import generated.kabopok.server.api.model.LoginDataDTO;
import kabopok.server.entities.Product;
import kabopok.server.entities.User;
import kabopok.server.minio.StorageService;
import kabopok.server.repositories.ProductRepository;
import kabopok.server.repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UserService extends DefaultService {

  private final UserRepository userRepository;
  private final ProductRepository productRepository;
  private final StorageService storageService;


  @Transactional
  public UUID save(User user, MultipartFile image) {
    user.setUserID(UUID.randomUUID());
    storageService.uploadFile("users", user.getUserID().toString() + ".jpg", image);
    if (image != null) {
      user.setPhotoUrl(storageService.generateImageUrl("users", user.getUserID().toString() + ".jpg"));
    }
    userRepository.save(user);
    return user.getUserID();
  }

  public User findByNumber(LoginDataDTO loginDataDTO){
    User current = getOrThrow(loginDataDTO.getNumber(),userRepository::findByNumber);
    if(!current.getPassword().equals(loginDataDTO.getPassword())){
      throw new RuntimeException("Wrong answer");
    }
    return current;
  }

  @Transactional
  public void deleteUser(UUID userId){
    User deletedUser = getOrThrow(userId, userRepository::findById);
    userRepository.delete(deletedUser);
    storageService.deleteFile("users", deletedUser.getUserID().toString() + ".jpg");
  }

  @Transactional
  public User updateUser(UUID userId, User updatedUser, MultipartFile image){
    User user = getOrThrow(userId, userRepository::findById);
    updatedUser.setUserID(user.getUserID());
    if(image != null){
      storageService.deleteFile("users", updatedUser.getUserID().toString() + ".jpg");
      storageService.uploadFile("users", updatedUser.getUserID().toString() + ".jpg", image);
    }
    updatedUser.setPhotoUrl(storageService.generateImageUrl("users", user.getUserID().toString() + ".jpg"));
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
    User user = getOrThrow(userId, userRepository::findById);
    return user.getProductsWish();
  }

  public void reportOnUser(UUID userId) {
    User user = getOrThrow(userId, userRepository::findById);
    user.setIsReported(true);
    userRepository.save(user);
  }

  public void declineReportOnUser(UUID userId) {
    User user = getOrThrow(userId, userRepository::findById);
    user.setIsReported(false);
    userRepository.save(user);
  }

}
