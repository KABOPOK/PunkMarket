package kabopok.server;

import generated.kabopok.server.api.model.IdDTO;
import generated.kabopok.server.api.model.UserDTO;
import jakarta.transaction.Transactional;
import kabopok.server.entities.User;
import kabopok.server.mappers.UserMapper;
import kabopok.server.repositories.UserRepository;
import kabopok.server.services.UserService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.*;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;


public class UserTest extends AbstractTest {
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
  private static final String TEST_USER_NUMBER = "123456789";
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
  public <T> ResponseEntity<T> sendMultipartPostRequest(Object userDTO, File imageFile, String url, Class<T> responseType) throws IOException {
    // Create headers
    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(MediaType.MULTIPART_FORM_DATA);

    // Build multipart request body
    MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
    body.add("user", userDTO); // Assuming `userDTO` can be serialized correctly
    body.add("image", new FileSystemResource(imageFile));

    // Create HttpEntity with headers and body
    HttpEntity<MultiValueMap<String, Object>> request = new HttpEntity<>(body, headers);

    // Send POST request
    return testRestTemplate.exchange(
            url,
            HttpMethod.POST,
            request,
            responseType
    );
  }



  @Test
  @Transactional
  public void createUserTest() throws IOException {
    // Having
    User user = createSampleUser();
    ClassLoader classLoader = UserTest.class.getClassLoader();
    File file = new File("D:\\Projects\\PunkMarket\\server\\src\\test\\java\\resources\\images\\photo.jpg");
    String imageRelativePath = "src/test/resources/images/photo.jpg";
    Path imagePath = Paths.get(imageRelativePath).toAbsolutePath(); // Resolves the relative path to absolute
    File imageFile = imagePath.toFile();
    // When
    UserDTO userDTO = userMapper.map(user);
    String url = "/api/users/create";
    ResponseEntity<IdDTO> response = sendMultipartPostRequest(userDTO,file,url, IdDTO.class);
    /*ResponseEntity<User> mockResponse = new ResponseEntity<>(userMapper.map(user), HttpStatus.OK);
    when(restTemplate.exchange(
            eq("/api/users/create"),
            eq(HttpMethod.POST),
            eq(null),
            any(ParameterizedTypeReference.class)
    )).thenReturn(mockResponse);

    UUID newUserID = userService.save(newUser);

    assertEquals(2, userRepository.findAll().size()); // Expecting 2 users in the database
    assertEquals(newUserID, newUser.getUserID());
    assertEquals("newUser", newUser.getUserName());
    assertEquals("+79001002030", newUser.getNumber());
    */
  }


/*

  @Test
  @Transactional
  public void deleteUserTest() {

    UUID userId = testUser.getUserID();

    userService.deleteUser(userId);

    assertFalse(userRepository.existsById(userId));
  }

  @Test
  @Transactional
  public void updateUserTest() {
    // Given
    UUID userId = testUser.getUserID();
    User updatedUser = new User();
    updatedUser.setUserID(userId);
    updatedUser.setUserName("updatedUser");
    updatedUser.setNumber("123456789");
    updatedUser.setPassword("newPassword123");
    updatedUser.setLocation("updatedLocation");
    updatedUser.setTelegramID("newtg123456789");
    updatedUser.setPhotoUrl("");

    updatedUser = userService.updateUser(userId, updatedUser);

    assertEquals(userRepository.findAll().size(), 1);
    assertEquals(updatedUser.getUserName(), "updatedUser");
    assertEquals(updatedUser.getTelegramID(), "newtg123456789");
    assertEquals(updatedUser.getLocation(), "updatedLocation");
    assertEquals(updatedUser.getNumber(), "123456789");
  }

  @Test
  @Transactional
  public void getUserByIdTest() {
    // Given
    UUID userId = testUser.getUserID();

    User fetchedUser = userService.findById(userId);

    assertEquals(fetchedUser.getUserID(), userId);
    assertEquals(fetchedUser.getUserName(), TEST_USER_NAME);
  }
*/
}

