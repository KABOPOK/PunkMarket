package kabopok.server;

import generated.kabopok.server.api.model.ProductDTO;
import kabopok.server.entities.Product;
import kabopok.server.entities.User;
import kabopok.server.mappers.ProductMapper;
import kabopok.server.repositories.ProductRepository;
import kabopok.server.repositories.UserRepository;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.ResponseEntity;
import java.util.List;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class WishListTest extends AbstractTest{
  @Autowired
  private ProductRepository productRepository;
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
  public void saveToWishlistTest() {
    // Given
    User user = SampleObjectGenerator.createSampleUser();
    userRepository.save(user);
    Product product = SampleObjectGenerator.createSampleProduct(user);
    productRepository.save(product);
    // When
    String url = "/api/users/add_to_wishlist?userId=" + user.getUserID() + "&productId=" + product.getProductID();
    ResponseEntity<Boolean> response = httpSteps.sendAddToWishListRequest(url);
    // Then
    assertEquals(200, response.getStatusCode().value());
    assertNotNull(response.getBody());
    assertTrue(response.getBody());
    User userWithList = userRepository.findUserWithProductsWish(user.getUserID());
    ProductDTO productDTO = productMapper.map(product);
    productDTO.setPhotoUrl(userWithList.getProductsWish().get(0).getPhotoUrl());
    productDTO.setUserID(userWithList.getProductsWish().get(0).getUser().getUserID());
    assertEquals(productMapper.map(userWithList.getProductsWish().get(0)), productMapper.map(product));
  }

  @Test
  public void getWishlistTest() {
    // Given
    User user = SampleObjectGenerator.createSampleUser();
    userRepository.save(user);
    Product product1 = SampleObjectGenerator.createSampleProduct(user);
    Product product2 = SampleObjectGenerator.createSampleProduct(user);
    Product product3 = SampleObjectGenerator.createSampleProduct(user);
    productRepository.save(product1);
    productRepository.save(product2);
    user.setProductsWish(List.of(product1, product2));
    userRepository.save(user);
    productRepository.save(product3);
    // When
    String url = "/api/users/get_fav_products?userId=" + user.getUserID();
    ResponseEntity<List<ProductDTO>> response = httpSteps.sendGetRequest(url, new ParameterizedTypeReference<>() {});
    // Then
    assertEquals(200, response.getStatusCode().value());
    assertNotNull(response.getBody());
    assertEquals(2,response.getBody().size());
    ProductDTO productDTO = productMapper.map(product1);
    productDTO.setUserID(response.getBody().get(0).getUserID());
    productDTO.setPhotoUrl(response.getBody().get(0).getPhotoUrl());
    assertEquals(productDTO,response.getBody().get(0));
  }

}
