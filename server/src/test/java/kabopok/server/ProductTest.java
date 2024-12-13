package kabopok.server;

import generated.kabopok.server.api.model.IdDTO;
import generated.kabopok.server.api.model.ProductDTO;
import generated.kabopok.server.api.model.UserDTO;
import kabopok.server.entities.Product;
import kabopok.server.entities.User;
import kabopok.server.mappers.ProductMapper;
import kabopok.server.mappers.UserMapper;
import kabopok.server.repositories.ProductRepository;
import kabopok.server.repositories.UserRepository;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import java.util.List;
import static kabopok.server.SampleObjectGenerator.createSampleProduct;
import static kabopok.server.SampleObjectGenerator.createSampleUser;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class ProductTest extends AbstractTest {

  @Autowired
  private ProductRepository productRepository;
  @Autowired
  private UserMapper userMapper;
  @Autowired
  ProductMapper productMapper;
  @Autowired
  private UserRepository userRepository;
  @Autowired
  private HttpSteps httpSteps;

  @AfterEach
  public void clear() {
    productRepository.deleteAll();
    userRepository.deleteAll();
  }

  @Test
  @Order(1)
  public void createProductDBTest() {
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
    ResponseEntity<Void> response = httpSteps.sendMultipartPostRequest(productDTO, resources, url, Void.class);
    // Then
    assertEquals(HttpStatus.OK.value(), response.getStatusCode().value());
    List<Product> productList = productRepository.findAll();
    productList.get(0).setPhotoUrl(productDTO.getPhotoUrl());
    productList.get(0).setProductID(productDTO.getProductID());
    productDTO.setUserID(null);
    assertEquals(productMapper.map(productList.get(0)), productDTO);
  }

  // @Test
  // public void createProductStorageTest() {
  //   // Given
  //   User user = createSampleUser();
  //   userRepository.save(user);
  //   Product product = createSampleProduct(user);
  //   List<Resource> resources = List.of( new ClassPathResource("images/photo.jpg"));
  //   // When
  //   ProductDTO productDTO = productMapper.map(product);
  //   productDTO.setUserID(user.getUserID());
  //   String url = "/api/products/create";
  //   ResponseEntity<Void> response = httpSteps.sendMultipartPostRequest(productDTO, resources, url, Void.class);
  //   // Then
  //   assertEquals(200, response.getStatusCode().value());
  //   List<Product> productList = productRepository.findAll();
  //   String expectedFileName = "envelop.jpg";
  //   Functions.compareResources(resources.get(0), productList.get(0).getPhotoUrl(), expectedFileName);
  // }

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
    ResponseEntity<Void> response = httpSteps.sendDeleteRequest(url);
    // Then
    assertEquals(200, response.getStatusCode().value());
    assertFalse(productRepository.existsById(product.getProductID()));
  }

  @Test
  @Order(3)
  public void updateProductTest() {
    // Given
    User user = createSampleUser();
    userRepository.save(user);
    Product product = createSampleProduct(user);
    productRepository.save(product);
    product.setPrice("341");
    // When
    ProductDTO updatedProductDTO = productMapper.map(product);
    updatedProductDTO.setUserID(user.getUserID());
    List<Resource> updatedImages = List.of(
            new ClassPathResource("images/photo2.jpg"),
            new ClassPathResource("images/photo.jpg")
    );
    String url = "/api/products/update?productId=" + product.getProductID();
    ResponseEntity<Void> response = httpSteps.sendMultipartPutRequest(updatedProductDTO, updatedImages, url, Void.class);
    // Then
    assertEquals(200, response.getStatusCode().value());
    List<Product> productList = productRepository.findAll();
    productList.get(0).setUsersWishedBy(null);
    productList.get(0).setPhotoUrl(product.getPhotoUrl());
    productList.get(0).setUser(product.getUser());
    productList.get(0).setProductID(product.getProductID());
    assertEquals(productList.get(0), product);
  }

  @Test
  @Order(4)
  public void getProductsTest() {
    // Given
    User user = createSampleUser();
    userRepository.save(user);
    for (int i = 0; i < 5; ++i) {
      Product product = createSampleProduct(user);
      productRepository.save(product);
    }
    // When
    String url = "/api/products/get_products?page=1&limit=5";
    ResponseEntity<List<ProductDTO>> response = httpSteps.sendGetRequest(url, new ParameterizedTypeReference<>() {});
    // Then
    assertEquals(HttpStatus.OK.value(), response.getStatusCode().value());
    assertNotNull(response.getBody());
    assertEquals(5, response.getBody().size());
    List<Product> productList = productRepository.findAll();
    List<ProductDTO> productListDTO = response.getBody();
    for (int i = 0; i < 5; ++i) {
      productList.get(i).setPhotoUrl(productListDTO.get(i).getPhotoUrl());
      assertEquals(response.getBody().get(i), productMapper.map(productList.get(i)));
    }
  }

  @Test
  @Order(5)
  public void getMyProductsTest() {
    // Given
    User user = createSampleUser();
    userRepository.save(user);
    for (int i = 1; i <= 5; ++i) {
      productRepository.save(createSampleProduct(user));
    }
    User anotherUser = createSampleUser();
    anotherUser.setUserName("anotherUser");
    userRepository.save(anotherUser);
    for (int i = 0; i < 4; ++i) {
        productRepository.save(createSampleProduct(anotherUser));
    }
    // When
    String url = "/api/products/get_my_products?page=1&limit=3&userId=" + anotherUser.getUserID();
    ResponseEntity<List<ProductDTO>> response1 = httpSteps.sendGetRequest(url, new ParameterizedTypeReference<>() {});
    url = "/api/products/get_my_products?page=2&limit=3&userId=" + anotherUser.getUserID();
    ResponseEntity<List<ProductDTO>> response2 = httpSteps.sendGetRequest(url, new ParameterizedTypeReference<>() {});
    // Then
    assertEquals(HttpStatus.OK.value(), response1.getStatusCode().value());
    assertEquals(HttpStatus.OK.value(), response2.getStatusCode().value());
    assertNotNull(response1.getBody());
    assertNotNull(response2.getBody());
    assertEquals(3, response1.getBody().size());
    assertEquals(1, response2.getBody().size());
    Pageable pageable = PageRequest.of(0, 4);
    List<Product> productList = productRepository.findAllByUser(anotherUser, pageable);
    for (int i = 0; i < 3; ++i) {
      productList.get(i).setPhotoUrl(response1.getBody().get(i).getPhotoUrl());
      assertEquals(productMapper.map(productList.get(i)), response1.getBody().get(i));
    }
    productList.get(3).setPhotoUrl(response2.getBody().get(0).getPhotoUrl());
    assertEquals(productMapper.map(productList.get(3)), response2.getBody().get(0));
  }

}

