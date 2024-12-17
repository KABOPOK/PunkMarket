package kabopok.server.controllers;

import generated.kabopok.server.api.UserApi;
import generated.kabopok.server.api.model.LoginDataDTO;
import generated.kabopok.server.api.model.UserDTO;
import kabopok.server.entities.User;
import kabopok.server.mappers.UserMapper;
import kabopok.server.minio.MinioConfig;
import kabopok.server.minio.StorageService;
import kabopok.server.services.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.util.UUID;

@RestController
@RequiredArgsConstructor
public class UserController implements UserApi {

  private final UserService userService;
  private final UserMapper userMapper;
  private final StorageService storageService;

  @Override
  @Transactional
  public void saveUser(UserDTO userDTO, MultipartFile image) {
    User user = userMapper.map(userDTO);
    String userId = userService.save(user).toString();
    storageService.uploadFile("users", userId + ".jpg", image);
  }

  @Override
  @Transactional
  public UserDTO getUser(String networkUrl, LoginDataDTO loginDataDTO) {
    MinioConfig.networkUrl = networkUrl;
    User user = userService.getUser(loginDataDTO);
    user.setPhotoUrl(storageService.generateImageUrl("users", user.getUserID().toString() + ".jpg"));
    return userMapper.map(user);
  }

  @Override
  @Transactional
  public void deleteUser(UUID userId) {
    UUID userID = userService.deleteUser(userId);
    storageService.deleteFile("users", userID + ".jpg");
  }

  @Override
  @Transactional
  public UserDTO updateUser(UUID userId, UserDTO userDTO, MultipartFile image) {
    User updatedUser = userService.updateUser(userId, userMapper.map(userDTO));
    if(image != null){
      storageService.deleteFile("users", updatedUser.getUserID().toString() + ".jpg");
      storageService.uploadFile("users", updatedUser.getUserID().toString() + ".jpg", image);
    }
    updatedUser.setPhotoUrl(storageService.generateImageUrl("users", updatedUser.getUserID().toString() + ".jpg"));
    return userMapper.map(updatedUser);
  }

}
