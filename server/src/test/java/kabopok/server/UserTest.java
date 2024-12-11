package kabopok.server;

import generated.kabopok.server.api.model.IdDTO;
import generated.kabopok.server.api.model.LoginDataDTO;
import generated.kabopok.server.api.model.UserDTO;
import kabopok.server.entities.User;
import kabopok.server.mappers.UserMapper;
import kabopok.server.minio.StorageService;
import kabopok.server.repositories.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.http.ResponseEntity;
import java.util.List;
import java.util.UUID;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;



@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class UserTest extends AbstractTest {

  @Autowired
  private UserRepository userRepository;
  @Autowired
  private StorageService storageService;
  @Autowired
  private UserMapper userMapper;
  @Autowired
  private HttpSteps httpSteps;

  @BeforeEach
  public void clear() {
    userRepository.deleteAll();
  }

  @Test
  @Order(1)
  public void createUserDBTest() {
    // Given
    User user = SampleObjectGenerator.createSampleUser();
    // When
    UserDTO userDTO = userMapper.map(user);
    String url = "/api/users/create";
    ResponseEntity<IdDTO> response = httpSteps.sendMultipartPostRequest(userDTO, (Resource) null, url, IdDTO.class);
    // Then
    assertEquals(200, response.getStatusCode().value());
    assertNotNull(response.getBody());
    List<User> userList = userRepository.findAll();
    userDTO.setUserID(response.getBody().getId().toString());
    assertEquals(userMapper.map(userList.get(0)), userDTO);
  }

  @Test
  @Order(2)
  public void createUserFileStorageTest() {
    // Given
    User user = SampleObjectGenerator.createSampleUser();
    Resource resource = new ClassPathResource("images/photo.jpg");
    // When
    UserDTO userDTO = userMapper.map(user);
    String url = "/api/users/create";
    ResponseEntity<IdDTO> response = httpSteps.sendMultipartPostRequest(userDTO, resource, url, IdDTO.class);
    // Then
    assertEquals(200, response.getStatusCode().value());
    assertNotNull(response.getBody());
    List<User> userList = userRepository.findAll();
    String photoUrl = userList.get(0).getPhotoUrl();
    String expectedFileName = userList.get(0).getUserID().toString() + ".jpg";
    assertTrue(Functions.compareResources(resource, photoUrl, expectedFileName));
  }

  @Test
  @Order(3)
  public void getUserTest() {
    // Given
    User user = SampleObjectGenerator.createSampleUser();
    userRepository.save(user);
    // When
    LoginDataDTO loginDataDTO = new LoginDataDTO();
    loginDataDTO.setNumber(user.getNumber());
    loginDataDTO.setPassword(user.getPassword());
    String url = "/api/users/authorization";
    ResponseEntity<UserDTO> response = httpSteps.sendAuthorizeUserRequest(url, loginDataDTO);
    // Then
    assertEquals(200, response.getStatusCode().value());
    assertNotNull(response.getBody());
    user.setUserID(UUID.fromString(response.getBody().getUserID()));
    user.setPhotoUrl(response.getBody().getPhotoUrl());
    assertEquals(response.getBody(), userMapper.map(user));
  }

  @Test
  @Order(4)
  public void updateUserDBTest() {
    // Given
    User user = SampleObjectGenerator.createSampleUser();
    userRepository.save(user);
    // When
    UserDTO updatedUserDTO = userMapper.map(user);
    updatedUserDTO.setUserID(String.valueOf(user.getUserID()));
    updatedUserDTO.setUserName("updatedUserName");
    updatedUserDTO.setNumber(String.valueOf((int)(Math.random() * 1000000000 + 1)));
    String url = "/api/users/update?userId=" + user.getUserID();
    ResponseEntity<UserDTO> response = httpSteps.sendMultipartPutRequest(updatedUserDTO, (Resource) null, url, UserDTO.class);
    // Then
    assertEquals(200, response.getStatusCode().value());
    List<User> userList = userRepository.findAll();
    updatedUserDTO.setUserID(userList.get(0).getUserID().toString());
    updatedUserDTO.setPhotoUrl(userList.get(0).getPhotoUrl());
    assertEquals(updatedUserDTO, userMapper.map(userList.get(0)));
  }

  @Test
  @Order(5)
  public void updateUserStorageTest() {
    // Given
    User user = SampleObjectGenerator.createSampleUser();
    Resource resource = new ClassPathResource("images/photo.jpg");
    storageService.uploadFile("users", user.getUserID().toString(),resource);
    user.setPhotoUrl(storageService.generateImageUrl("users",user.getUserID().toString()));
    userRepository.save(user);
    Resource updatedImage = new ClassPathResource("images/photo1.jpg");
    // When
    UserDTO updatedUserDTO = userMapper.map(user);
    updatedUserDTO.setNumber(String.valueOf((int)(Math.random() * 1000000000 + 1)));
    String url = "/api/users/update?userId=" + user.getUserID();
    ResponseEntity<UserDTO> response = httpSteps.sendMultipartPutRequest(updatedUserDTO, updatedImage, url, UserDTO.class);
    // Then
    assertEquals(200, response.getStatusCode().value());
    List<User> userList = userRepository.findAll();
    String photoUrl = userList.get(0).getPhotoUrl();
    String expectedFileName = userList.get(0).getUserID().toString() + ".jpg";
    assertTrue(Functions.compareResources(updatedImage, photoUrl,  expectedFileName));
  }

  @Test
  @Order(6)
  public void deleteUserTest() {
    // Given
    User user = SampleObjectGenerator.createSampleUser();
    userRepository.save(user);
    // When
    String url = "/api/users/delete?userId=" + user.getUserID();
    ResponseEntity<Void> response = httpSteps.sendDeleteRequest(url);
    // Then
    assertEquals(200, response.getStatusCode().value());
    assertFalse(userRepository.existsById(user.getUserID()));
  }

}

