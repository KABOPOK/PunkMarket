package kabopok.server;

import generated.kabopok.server.api.model.IdDTO;
import generated.kabopok.server.api.model.LoginDataDTO;
import generated.kabopok.server.api.model.UserDTO;
import kabopok.server.entities.User;
import kabopok.server.mappers.UserMapper;
import kabopok.server.repositories.UserRepository;
import org.junit.jupiter.api.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.http.*;

import java.util.List;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class UserTest extends AbstractTest {

  @Autowired
  private UserRepository userRepository;
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
  public void createUserTest() {
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
    user.setUserID(response.getBody().getId());
    List<User> userList = userRepository.findAll();
    userList.get(0).setProductsWish(null);
    userList.get(0).setProducts(null);
    user.setPhotoUrl(userList.get(0).getPhotoUrl());
    assertEquals(response.getBody(), new IdDTO(user.getUserID()));
    assertEquals(userList.get(0), user);
  }

  @Test
  @Order(2)
  public void authorizeUserTest() {
    // Having
    User user = SampleObjectGenerator.createSampleUser();
    userRepository.save(user);
    // When
    LoginDataDTO loginData = new LoginDataDTO();
    loginData.setNumber(user.getNumber());
    loginData.setPassword(user.getPassword());
    String url = "/api/users/authorization";

    ResponseEntity<UserDTO> response = httpSteps.sendAuthorizeUserRequest(url, loginData);
    // Then
    assertEquals(200, response.getStatusCode().value());
    assertNotNull(response.getBody());
    user.setUserID(UUID.fromString(response.getBody().getUserID()));
    user.setPhotoUrl(response.getBody().getPhotoUrl());
    assertEquals(response.getBody(), userMapper.map(user));
  }

  @Test
  @Order(3)
  public void updateUserTest() {
    // Given
    User user = SampleObjectGenerator.createSampleUser();
    userRepository.save(user);
    // When
    UserDTO updatedUserDTO = userMapper.map(user);
    updatedUserDTO.setUserID(String.valueOf(user.getUserID()));
    updatedUserDTO.setUserName("updatedUserName");
    updatedUserDTO.setNumber(String.valueOf((int)(Math.random() * 1000000000 + 1)));
    Resource updatedImage = new ClassPathResource("images/photo.jpg");
    String url = "/api/users/update?userId=" + user.getUserID();
    ResponseEntity<IdDTO> response = httpSteps.sendMultipartPutRequest(updatedUserDTO, updatedImage, url, IdDTO.class);
    // Then
    assertEquals(200, response.getStatusCode().value());
    List<User> userList = userRepository.findAll();
    assertEquals(updatedUserDTO, userMapper.map(userList.get(0)));
  }

  @Test
  @Order(4)
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

