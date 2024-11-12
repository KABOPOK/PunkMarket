package kabopok.server.controllers;

import com.fasterxml.jackson.databind.DeserializationContext;
import generated.kabopok.server.api.UserApi;
import generated.kabopok.server.api.model.IdDTO;
import generated.kabopok.server.api.model.LoginDataDTO;
import generated.kabopok.server.api.model.UserDTO;
import io.minio.MinioClient;
import kabopok.server.entities.User;
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
import java.util.UUID;

@RestController
@RequiredArgsConstructor
public class UserController implements UserApi {

  private final UserService userService;
  private final StorageService storageService;
  private final UserMapper userMapper;
  private final MinioClient minioClient;

  @Override
  public UserDTO getUser(LoginDataDTO loginDataDTO) {
    User user = userService.findByNumber(loginDataDTO);
    String url = storageService.generateImageUrl("users", user.getUserID().toString() + ".jpg",3600);
    user.setPhotoUrl(url);
    return userMapper.map(user);
  }

  @PostMapping("/test")
  public void registerUser(
          @RequestParam("user") String userJson,
          @RequestPart(value = "image", required = false) MultipartFile image) {
    // Deserialize the JSON string into UserDTO
    DeserializationContext objectMapper = null;
    System.out.println(userJson);
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


}
