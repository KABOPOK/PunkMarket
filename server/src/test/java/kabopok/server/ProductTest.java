/*
package kabopok.server;

import generated.kabopok.server.api.model.IdDTO;
import generated.kabopok.server.api.model.UserDTO;
import jakarta.transaction.Transactional;
import kabopok.server.entities.Product;
import kabopok.server.entities.User;
import kabopok.server.mappers.ProductMapper;
import kabopok.server.repositories.ProductRepository;
import kabopok.server.services.ProductService;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.http.*;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.util.UUID;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class ProductTest extends AbstractTest {
  @Autowired
  private ProductRepository productRepository;

  @Autowired
  private ProductService productService;
  @Autowired
  private ProductMapper productMapper;
  @Autowired
  private TestRestTemplate testRestTemplate;

  @MockBean
  private RestTemplate restTemplate;
  private static final String TEST_USER_NAME = "testUser";
  private static final String TEST_PRODUCT_PRICE = "999.99";
  private static final String TEST_PRODUCT_TITLE = "testProduct";
  private static final String TEST_PRODUCT_CATEGORY = "tech";
  private static final String TEST_PRODUCT_DESCRIPTION = "TestDescription";
  private static final UUID TEST_USER_ID = UUID.fromString("f2398c8a-7dae-4e7d-b48b-75b834413265");
  private static final String TEST_PRODUCT_LOCATION = "TestLocation";

  public Product createSampleProduct(){
    Product product = new Product();
    product.setProductID(UUID.randomUUID());
    product.setTitle(TEST_PRODUCT_TITLE);
    product.setLocation(TEST_PRODUCT_LOCATION);
    product.setUser(TEST_USER_ID);
    product.setCategory(TEST_PRODUCT_CATEGORY);
    product.setPhotoUrl("halo");
    product.setPrice(TEST_PRODUCT_PRICE);
    product.setDescription(TEST_PRODUCT_DESCRIPTION);
    product.setOwnerName(TEST_USER_NAME);
    return product;
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
  @Transactional
  public void createUserTest() {
    // Having
    User user = createSampleUser();
    Resource resource = new ClassPathResource("images/photo.jpg");
    // When
    UserDTO userDTO = userMapper.map(user);
    String url = "/api/users/create";
    ResponseEntity<IdDTO> response = sendMultipartPostRequest(userDTO, resource, url, IdDTO.class);
    //Then
    assertEquals(200, response.getStatusCode().value());
    assertNotNull(response.getBody());
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
  //}
/*
  @Test
  @Order(2)
  @Transactional
  public void updateUserTest() {
    // Given
    // Create and save a sample user in the database
    User user = createSampleUser();
    Resource resource = new ClassPathResource("images/photo.jpg");
    // When
    UserDTO userDTO = userMapper.map(user);
    String url = "/api/users/create";
    ResponseEntity<IdDTO> response = sendMultipartPostRequest(userDTO, resource, url, IdDTO.class);


    // Prepare updated user details
    UserDTO updatedUserDTO = new UserDTO();
    updatedUserDTO.setUserName("updatedUser");
    updatedUserDTO.setNumber("987654321");
    updatedUserDTO.setLocation("updatedLocation");
    updatedUserDTO.setTelegramID("updatedTelegramID");
    updatedUserDTO.setPhotoUrl("updatedPhoto");

    // Resource for the updated image
    Resource updatedImage = new ClassPathResource("images/photo.jpg");

    // URL for updating the user
    String url1 = "/api/users/update?userId=" + user.getUserID();

    // When
    ResponseEntity<IdDTO> response1 = sendMultipartPutRequest(updatedUserDTO, updatedImage, url1, IdDTO.class);

    // Then
    assertEquals(200, response1.getStatusCode().value());

    // Validate the user details are updated in the database
    User updatedUser = userRepository.findById(user.getUserID())
            .orElseThrow(() -> new RuntimeException("User not found"));
    assertEquals("updatedUser", updatedUser.getUserName());
    assertEquals("987654321", updatedUser.getNumber());
    assertEquals("updatedLocation", updatedUser.getLocation());
    assertEquals("updatedTelegramID", updatedUser.getTelegramID());
    assertEquals("updatedPhoto", updatedUser.getPhotoUrl());
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
  public void getUserByIdTest() {
    // Given
    UUID userId = testUser.getUserID();

    User fetchedUser = userService.findById(userId);

    assertEquals(fetchedUser.getUserID(), userId);
    assertEquals(fetchedUser.getUserName(), TEST_USER_NAME);
  }

}
*/
