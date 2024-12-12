package kabopok.server;

import kabopok.server.entities.User;
import kabopok.server.minio.StorageService;
import kabopok.server.services.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
public class HelloController {

  private final UserService userService;
  private final StorageService storageService;
  @GetMapping("/hello")
  public String sayHello() {
    return "Hello World";
  }
  @Transactional
  @GetMapping("/test/{userId}")
  public ResponseEntity<byte[]> apiTestUserIdGet(@PathVariable String userId) {
    try {
      User user = userService.getUser(UUID.fromString(userId));
      if (user == null) {
        throw new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found for userId: " + userId);
      }
      String imageUrl = storageService.generateImageUrl("users", user.getUserID().toString() + ".jpg");
      Resource resource = new UrlResource(imageUrl);
      try (InputStream inputStream = resource.getInputStream()) {
        byte[] fileBytes = inputStream.readAllBytes();
        return ResponseEntity.ok(fileBytes);
      }
    } catch (MalformedURLException e) {
      throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Invalid URL for userId: " + userId, e);
    } catch (IOException e) {
      throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Error reading file for userId: " + userId, e);
    } catch (IllegalArgumentException e) {
      throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid userId: " + userId, e);
    }
  }
}
