package kabopok.server;

import generated.kabopok.server.api.model.IdDTO;
import generated.kabopok.server.api.model.UserDTO;
import kabopok.server.entities.User;
import kabopok.server.mappers.UserMapper;
import kabopok.server.repositories.UserRepository;
import kabopok.server.services.UserService;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.*;
import org.springframework.test.annotation.Commit;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;


import java.util.HashMap;
import java.util.Map;
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



  @Test
  @Order(1)
  @Commit
  public void createUserTest() {
    // Given
    User user = createSampleUser();
    Resource resource = new ClassPathResource("images/photo.jpg");
    UserDTO userDTO = userMapper.map(user);

    // When
    String url = "/api/users/create";
    ResponseEntity<IdDTO> response = sendMultipartPostRequest(userDTO, resource, url, IdDTO.class);

    // Then
    assertEquals(200, response.getStatusCode().value());
    assertNotNull(response.getBody());

    // Save the user ID for use in other tests
    createdUserId = response.getBody().getId();
  }

  @Test
  @Order(3)
  public void updateUserTest() {
    // Given
    assertNotNull(createdUserId, "User ID should be available from createUserTest");

    UserDTO updatedUserDTO = new UserDTO();
    //updatedUserDTO.setUserID(String.valueOf(createdUserId));
    updatedUserDTO.setUserID(String.valueOf(UUID.randomUUID()));
    updatedUserDTO.setUserName("updatedUser");
    updatedUserDTO.setPassword("UpdatedPassword");
    updatedUserDTO.setNumber("987654321");
    updatedUserDTO.setLocation("updatedLocation");
    updatedUserDTO.setTelegramID("updatedTelegramID");
    updatedUserDTO.setPhotoUrl("updatedPhoto");

    Resource updatedImage = new ClassPathResource("images/photo.jpg");

    String url = "/api/users/update?userId=" + createdUserId;

    // When
    ResponseEntity<IdDTO> response = sendMultipartPutRequest(updatedUserDTO, updatedImage, url, IdDTO.class);

    // Then
    assertEquals(200, response.getStatusCode().value());

    User updatedUser = userRepository.findById(createdUserId)
            .orElseThrow(() -> new RuntimeException("User not found"));
    assertEquals("updatedUser", updatedUser.getUserName());
    assertEquals("987654321", updatedUser.getNumber());
    assertEquals("updatedLocation", updatedUser.getLocation());
    assertEquals("updatedTelegramID", updatedUser.getTelegramID());
    assertEquals("updatedPhoto", updatedUser.getPhotoUrl());
  }
  @Test
  @Order(4)
  public void deleteUserTest() {
    // Given
    assertNotNull(createdUserId, "User ID is null. Ensure createUserTest runs before deleteUserTest.");

    String url = "/api/users/delete?userId=" + createdUserId;

    // When
    ResponseEntity<Void> response = testRestTemplate.exchange(
            url,
            HttpMethod.DELETE,
            null,
            Void.class
    );

    // Then
    assertEquals(200, response.getStatusCode().value(), "Expected HTTP status 200 for successful deletion.");

    boolean userExists = userRepository.existsById(createdUserId);
    assertEquals(false, userExists, "User should be deleted from the database.");
  }

  @Test
  @Order(2)
  public void authorizeUserTest() {
    // Prepare valid login data
    Map<String, String> loginData = new HashMap<>();
    loginData.put("number", TEST_USER_NUMBER); // Replace with the test user's phone number
    loginData.put("password", TEST_USER_PASSWORD); // Replace with the test user's password

    // Set headers
    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(MediaType.APPLICATION_JSON);

    // Create the request with login data
    HttpEntity<Map<String, String>> request = new HttpEntity<>(loginData, headers);

    // Define the endpoint URL
    String url = "/api/users/authorization";

    // Send POST request
    ResponseEntity<UserDTO> response = testRestTemplate.postForEntity(url, request, UserDTO.class);

    // Assert response
    assertEquals(200, response.getStatusCode().value(), "Expected HTTP status 200 for successful authorization.");
    assertNotNull(response.getBody(), "Response body should not be null.");
    assertEquals(TEST_USER_NUMBER, response.getBody().getNumber(), "User number should match the test user.");
    assertEquals(TEST_USER_NAME, response.getBody().getUserName(), "User name should match the test user.");
  }






}

