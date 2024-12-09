package kabopok.server.controllers;

import generated.kabopok.server.api.UserApi;
import generated.kabopok.server.api.model.IdDTO;
import generated.kabopok.server.api.model.LoginDataDTO;
import generated.kabopok.server.api.model.ProductDTO;
import generated.kabopok.server.api.model.UserDTO;
import kabopok.server.entities.User;
import kabopok.server.mappers.ProductMapper;
import kabopok.server.mappers.UserMapper;
import kabopok.server.services.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
public class UserController implements UserApi {

  private final UserService userService;
  private final UserMapper userMapper;
  private final ProductMapper productMapper;

  @Override
  public void deleteUser(UUID userId) {
    userService.deleteUser(userId);
  }

  @Override
  public UserDTO getUser(LoginDataDTO loginDataDTO) {
    return userMapper.map(userService.findByNumber(loginDataDTO));
  }

  @Override
  public Boolean saveToWishlist(UUID userId, UUID productId) {
    return userService.addToWishList(userId, productId);
  }

  @Override
  public IdDTO saveUser(UserDTO userDTO, MultipartFile image) {
    User user = userMapper.map(userDTO);
    return new IdDTO(userService.save(user, image));
  }

  @Override
  public UserDTO updateUser(UUID userId, UserDTO userDTO, MultipartFile image) {
    User updatedUser = userService.updateUser(userId, userMapper.map(userDTO), image);
    return userMapper.map(updatedUser);
  }

  @Override
  public List<ProductDTO> getWishlist(String userId) {
    return productMapper.map(userService.getMyFavProducts(UUID.fromString(userId)));
  }

}
