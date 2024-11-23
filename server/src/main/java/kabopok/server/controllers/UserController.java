package kabopok.server.controllers;

import com.fasterxml.jackson.databind.DeserializationContext;
import generated.kabopok.server.api.UserApi;
import generated.kabopok.server.api.model.IdDTO;
import generated.kabopok.server.api.model.LoginDataDTO;
import generated.kabopok.server.api.model.ProductDTO;
import generated.kabopok.server.api.model.UserDTO;
import io.minio.MinioClient;
import kabopok.server.entities.Product;
import kabopok.server.entities.User;
import kabopok.server.mappers.ProductMapper;
import kabopok.server.mappers.UserMapper;
import kabopok.server.minio.StorageService;
import kabopok.server.services.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.Console;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
public class UserController implements UserApi {

  private final UserService userService;
  private final StorageService storageService;
  private final UserMapper userMapper;
  private final ProductMapper productMapper;
  private final MinioClient minioClient;

  @Override
  public void deleteUser(UUID userId) {
    User user = userService.deleteUser(userId);
    storageService.deleteFile("users", user.getUserID().toString() + ".jpg");
  }

  @Override
  public UserDTO getUser(LoginDataDTO loginDataDTO) {
    User user = userService.findByNumber(loginDataDTO);
    String url = storageService.generateImageUrl("users", user.getUserID().toString() + ".jpg",3600);
    user.setPhotoUrl(url);
    return userMapper.map(user);
  }

  @Override
  public void saveToWishlist(UUID userId, UUID productId) {
    userService.addToWishList(userId, productId);
  }

  public IdDTO saveUser(UserDTO userDTO, MultipartFile image) {
    User user = userMapper.map(userDTO);
    userService.save(user);
    try (InputStream inputStream = image.getInputStream()) {
      storageService.uploadFile("users", user.getUserID().toString() + ".jpg", inputStream, image.getContentType());
    } catch (IOException e) {
      throw new RuntimeException("Failed to upload image: " + e.getMessage(), e);
    }
    return new IdDTO(user.getUserID());
  }

  @Override
  public void updateUser(UUID userId, UserDTO userDTO, MultipartFile image) {
    User updatedUser = userService.updateUser(userId,userMapper.map(userDTO));
    if(image != null){
      storageService.deleteFile("users", updatedUser.getUserID().toString() + ".jpg");
      try (InputStream inputStream = image.getInputStream()) {
        storageService.uploadFile("users", updatedUser.getUserID().toString() + ".jpg", inputStream, image.getContentType());
      } catch (IOException e) {
        throw new RuntimeException("Failed to upload image: " + e.getMessage(), e);
      }
    }
  }

  @Override
  public List<ProductDTO> getWishlist(String userId) {
    List<Product> productList = userService.getMyFavProducts(UUID.fromString(userId));
    List<ProductDTO> productDTOList = new ArrayList<>();
    productList.forEach(product -> {
      String path = product.getUser().getUserID() + "/" + product.getProductID()  + "/" + "envelop.jpg";
      String url = storageService.generateImageUrl("products", path,3600);
      product.setPhotoUrl(url);
      productDTOList.add(productMapper.map(product));
    });
    return productDTOList;
  }

}
