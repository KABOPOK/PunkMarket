package kabopok.server;

import generated.kabopok.server.api.model.ProductDTO;
import kabopok.server.entities.Product;
import kabopok.server.entities.User;
import kabopok.server.mappers.ProductMapper;
import kabopok.server.repositories.ProductRepository;
import kabopok.server.repositories.UserRepository;
import kabopok.server.services.ProductService;
import org.junit.jupiter.api.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.http.*;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;

import java.util.List;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class ProductTest extends AbstractTest{
  @Autowired
  private ProductRepository productRepository;
  @Autowired
  private ProductService productService;
  @Autowired
  ProductMapper productMapper;

  @Autowired
  private UserRepository userRepository;

  @Autowired
  private TestRestTemplate testRestTemplate;

  public User createSampleUser(){
    User user = new User();
    user.setUserID(UUID.randomUUID());
    user.setUserName("testUser");
    user.setNumber(String.valueOf((int)(Math.random() * 1000000000 + 1)));
    user.setPassword("password123");
    user.setLocation("testLocation");
    user.setTelegramID("tg123456789");
    user.setPhotoUrl("halo");
    user.setProducts(null);
    user.setProductsWish(null);
    return user;
  }
  public Product createSampleProduct(User user){
    Product product = new Product();
    product.setProductID(UUID.randomUUID());
    product.setOwnerName(user.getUserName());
    product.setDescription("productDescription");
    product.setPrice("1999.99");
    product.setUser(user);
    product.setCategory("sampleCategory");
    product.setTitle("sampleTitle");
    product.setLocation("sampleLocation");
    product.setPhotoUrl("hola");
    product.setUsersWishedBy(null);
    return product;
  }

  public <T> ResponseEntity<T> sendMultipartPostRequest1(Object productDTO, List<Resource> resources, String url, Class<T> responseType) {
    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(MediaType.MULTIPART_FORM_DATA);

    MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
    body.add("product", productDTO);
    resources.forEach(resource -> body.add("images", resource));

    HttpEntity<MultiValueMap<String, Object>> request = new HttpEntity<>(body, headers);

    return testRestTemplate.exchange(
            url,
            HttpMethod.POST,
            request,
            responseType
    );
  }

  public <T> ResponseEntity<T> sendMultipartPutRequest1(Object productDTO, List<Resource> resources, String url, Class<T> responseType){
    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(MediaType.MULTIPART_FORM_DATA);
    MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
    body.add("product", productDTO);
    resources.forEach(resource -> body.add("images", resource));
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
    productRepository.deleteAll();
  }

  @Test
  @Order(1)
  public void createProductTest() {
    // Given
    User user = createSampleUser();
    userRepository.save(user);

    Product product = createSampleProduct(user);
    List<Resource> resources = List.of(
            new ClassPathResource("images/photo1.jpg"),
            new ClassPathResource("images/photo2.jpg")
    );

    // When
    ProductDTO productDTO = productMapper.map(product);
    productDTO.setUserID(user.getUserID());
    String url = "/api/products/create";

    ResponseEntity<Void> response = sendMultipartPostRequest1(productDTO, resources, url, Void.class);

    // Then
    assertEquals(HttpStatus.OK.value(), response.getStatusCode().value());
    List<User> userList = userRepository.findAll();
    assertEquals(1, userList.size());
    assertEquals(userList.get(0).getUserName(), user.getUserName());
  }

  @Test
  @Order(2)
  public void deleteProductTest() {
    // Given
    User user = createSampleUser();
    userRepository.save(user);

    Product product = createSampleProduct(user);
    productRepository.save(product);


    // When
    ProductDTO productDTO = productMapper.map(product);
    productDTO.setUserID(user.getUserID());
    String url = "/api/products/delete?productId=" + product.getProductID();

    ResponseEntity<Void> response = testRestTemplate.exchange(
            url,
            HttpMethod.DELETE,
            null,
            Void.class
    );

    // Then
    assertEquals(200, response.getStatusCode().value());

    boolean productExists = productRepository.existsById(product.getProductID());
    assertEquals(false, productExists);
  }

  @Test
  @Order(3)
  public void updateProductTest() {
    // Given
    User user = createSampleUser();
    userRepository.save(user);

    Product product = createSampleProduct(user);
    productRepository.save(product);

    // When
    ProductDTO updatedProductDTO = new ProductDTO();
    updatedProductDTO.setUserID(user.getUserID());
    updatedProductDTO.setCategory("updatedCategory");
    updatedProductDTO.setDescription("updatedDescription");
    updatedProductDTO.setPrice("0.99");
    updatedProductDTO.setLocation("updatedLocation");
    updatedProductDTO.setOwnerName(user.getUserName());
    updatedProductDTO.setTitle("updatedTitle");
    updatedProductDTO.setProductID(UUID.randomUUID());
    updatedProductDTO.setPhotoUrl("photo");

    List<Resource> updatedImages = List.of(
            new ClassPathResource("images/photo2.jpg"),
            new ClassPathResource("images/photo.jpg")
    );
    String url = "/api/products/update?productId=" + product.getProductID();
    ResponseEntity<Void> response = sendMultipartPutRequest1(updatedProductDTO, updatedImages, url, Void.class);


    // Then
    assertEquals(200, response.getStatusCode().value());

    boolean productExists = productRepository.existsById(product.getProductID());
    assertEquals(true, productExists);
  }

  @Test
  @Order(4)
  public void getProductsTest() {
    // Given
    User user = createSampleUser();
    userRepository.save(user);

    // Create and save multiple sample products
    for (int i = 1; i <= 5; i++) {
      Product product = new Product();
      product.setProductID(UUID.randomUUID());
      product.setOwnerName(user.getUserName());
      product.setDescription("Product Description " + i);
      product.setPrice(String.valueOf(1000 + i));
      product.setUser(user);
      product.setCategory("Category " + i);
      product.setTitle("Product Title " + i);
      product.setLocation("Location " + i);
      product.setPhotoUrl("Photo URL " + i);
      productRepository.save(product);
    }

    // When
    String url = "/api/products/get_products?page=1&limit=5&query=Product Title";
    ResponseEntity<ProductDTO[]> response = testRestTemplate.exchange(
            url,
            HttpMethod.GET,
            null,
            ProductDTO[].class
    );

    // Then
    assertEquals(HttpStatus.OK.value(), response.getStatusCode().value());
    assertNotNull(response.getBody());
    assertEquals(5, response.getBody().length);

    for (ProductDTO product : response.getBody()) {
      assertTrue(product.getTitle().contains("Product Title"));
    }
  }

  @Test
  @Order(5)
  public void getMyProductsTest() {
    // Given
    User user = createSampleUser();
    userRepository.save(user);

    for (int i = 1; i <= 5; i++) {
      Product product = new Product();
      product.setProductID(UUID.randomUUID());
      product.setOwnerName(user.getUserName());
      product.setDescription("User Product Description " + i);
      product.setPrice(String.valueOf(1000 + i));
      product.setUser(user);
      product.setCategory("User Category " + i);
      product.setTitle("User Product Title " + i);
      product.setLocation("User Location " + i);
      product.setPhotoUrl("User Photo URL " + i);
      productRepository.save(product);
    }

    User anotherUser = createSampleUser();
    anotherUser.setUserName("anotherUser");
    userRepository.save(anotherUser);

    for (int i = 1; i <= 3; i++) {
      Product otherProduct = new Product();
      otherProduct.setProductID(UUID.randomUUID());
      otherProduct.setOwnerName(anotherUser.getUserName());
      otherProduct.setDescription("Other Product Description " + i);
      otherProduct.setPrice(String.valueOf(500 + i));
      otherProduct.setUser(anotherUser);
      otherProduct.setCategory("Other Category " + i);
      otherProduct.setTitle("Other Product Title " + i);
      otherProduct.setLocation("Other Location " + i);
      otherProduct.setPhotoUrl("Other Photo URL " + i);
      productRepository.save(otherProduct);
    }

    // When
    String url = "/api/products/get_my_products?page=1&limit=3&userId=" + user.getUserID();
    ResponseEntity<ProductDTO[]> response = testRestTemplate.exchange(
            url,
            HttpMethod.GET,
            null,
            ProductDTO[].class
    );

    // Then
    assertEquals(HttpStatus.OK.value(), response.getStatusCode().value());
    assertNotNull(response.getBody());
    assertEquals(3, response.getBody().length); 

    for (ProductDTO product : response.getBody()) {
      assertEquals(user.getUserName(), product.getOwnerName());
    }
  }

}

