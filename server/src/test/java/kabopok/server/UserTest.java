package kabopok.server;

import generated.kabopok.server.api.model.IdDTO;
import generated.kabopok.server.api.model.LoginDataDTO;
import generated.kabopok.server.api.model.UserDTO;
import kabopok.server.entities.User;
import kabopok.server.mappers.UserMapper;
import kabopok.server.repositories.UserRepository;
import kabopok.server.services.UserService;
import org.junit.jupiter.api.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.http.*;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class UserTest extends AbstractTest {
  private static UUID createdUserId;
  @Autowired
  private UserRepository userRepository;

  @Autowired
  private UserService userService;
  @Autowired
  private UserMapper userMapper;
  @Autowired
  private TestRestTemplate testRestTemplate;

  @MockBean
  private RestTemplate restTemplate;
  private static final String TEST_USER_NAME = "testUser";
  private static final String TEST_USER_NUMBER = String.valueOf((int)(Math.random() * 1000000000 + 1));
  private static final String TEST_USER_PASSWORD = "password123";

  public User createSampleUser(){
    User user = new User();
    user.setUserID(UUID.randomUUID());
    user.setUserName(TEST_USER_NAME);
    user.setNumber(TEST_USER_NUMBER);
    user.setPassword(TEST_USER_PASSWORD);
    user.setLocation("testLocation");
    user.setTelegramID("tg123456789");
    user.setPhotoUrl("halo");
    user.setProducts(null);
    user.setProductsWish(null);
    return user;
  }

  public <T> ResponseEntity<T> sendMultipartPostRequest(Object userDTO, Resource resource, String url, Class<T> responseType){
    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(MediaType.MULTIPART_FORM_DATA);
    MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
    body.add("user", userDTO);
    body.add("image", resource);
    HttpEntity<MultiValueMap<String, Object>> request = new HttpEntity<>(body, headers);
    return testRestTemplate.exchange(
            url,
            HttpMethod.POST,
            request,
            responseType
    );
  }

  public <T> ResponseEntity<T> sendMultipartPutRequest(Object userDTO, Resource resource, String url, Class<T> responseType){
    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(MediaType.MULTIPART_FORM_DATA);
    MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
    body.add("user", userDTO);
    body.add("image", resource);
    HttpEntity<MultiValueMap<String, Object>> request = new HttpEntity<>(body, headers);
    return testRestTemplate.exchange(
            url,
            HttpMethod.PUT,
            request,
            responseType
    );
  }

  @BeforeEach
  public void clear() {
    userRepository.deleteAll();
  }

  @Test
  @Order(1)
  public void createUserTest() {
    // Given
    User user = createSampleUser();
    Resource resource = new ClassPathResource("images/photo.jpg");
    // When
    UserDTO userDTO = userMapper.map(user);
    String url = "/api/users/create";
    ResponseEntity<IdDTO> response = sendMultipartPostRequest(userDTO, resource, url, IdDTO.class);
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
    User user = createSampleUser();
    userRepository.save(user);

    // When
    LoginDataDTO loginData = new LoginDataDTO();
    loginData.setNumber(user.getNumber());
    loginData.setPassword(user.getPassword());
    String url = "/api/users/authorization";

    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(MediaType.APPLICATION_JSON);
    HttpEntity<LoginDataDTO> request = new HttpEntity<>(loginData, headers);
    ResponseEntity<UserDTO> response = testRestTemplate.postForEntity(url, request, UserDTO.class);

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
    User user = createSampleUser();
    userRepository.save(user);

    // When
    UserDTO updatedUserDTO = new UserDTO();
    updatedUserDTO.setUserID(String.valueOf(UUID.randomUUID()));
    updatedUserDTO.setUserName("updatedUser");
    updatedUserDTO.setPassword("updatedPassword");
    updatedUserDTO.setNumber("987654321");
    updatedUserDTO.setLocation("updatedLocation");
    updatedUserDTO.setTelegramID("updatedTelegramID");
    updatedUserDTO.setPhotoUrl("updatedPhoto");

    Resource updatedImage = new ClassPathResource("images/photo.jpg");
    String url = "/api/users/update?userId=" + user.getUserID();
    ResponseEntity<IdDTO> response = sendMultipartPutRequest(updatedUserDTO, updatedImage, url, IdDTO.class);

    // Then
    assertEquals(200, response.getStatusCode().value());

    User updatedUser = userRepository.findById(user.getUserID())
            .orElseThrow(() -> new RuntimeException("User not found"));
    assertEquals("updatedUser", updatedUser.getUserName());
    assertEquals("updatedPassword", updatedUser.getPassword());
    assertEquals("987654321", updatedUser.getNumber());
    assertEquals("updatedLocation", updatedUser.getLocation());
    assertEquals("updatedTelegramID", updatedUser.getTelegramID());
    assertEquals("updatedPhoto", updatedUser.getPhotoUrl());
  }
  @Test
  @Order(4)
  public void deleteUserTest() {
    // Given
    User user = createSampleUser();
    userRepository.save(user);



    // When
    String url = "/api/users/delete?userId=" + user.getUserID();
    ResponseEntity<Void> response = testRestTemplate.exchange(
            url,
            HttpMethod.DELETE,
            null,
            Void.class
    );

    // Then
    assertEquals(200, response.getStatusCode().value());

    boolean userExists = userRepository.existsById(user.getUserID());
    assertEquals(false, userExists);
  }

}

