package kabopok.server.services;

import kabopok.server.entities.Product;
import kabopok.server.entities.User;
import kabopok.server.repositories.ProductRepository;
import kabopok.server.repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ProductService extends DefaultService {

  private final ProductRepository productRepository;
  private final UserRepository userRepository;

  @Transactional
  public Product save(Product product, UUID userId) {
    User user = getOrThrow(userId, userRepository::findById);
    product.setUser(user);
    product.setProductID(UUID.randomUUID());
    productRepository.save(product);
    return product;
  }

  public List<Product> getProducts(Integer page, Integer limit, String query) {
    if (query == null) { query = ""; }
    Pageable pageable = PageRequest.of(page - 1, limit);
    return productRepository.findAllByTitleContaining(query, pageable);
  }
  public List<Product> getMyProducts(UUID userId, Integer page, Integer limit) {
    User user = getOrThrow(userId, userRepository::findById);
    Pageable pageable = PageRequest.of(page - 1, limit);
    return productRepository.findAllByUser(user, pageable);
  }

  @Transactional
  public Product updateProduct(UUID productId, Product updatedProduct) {
    Product product  = getOrThrow(productId, productRepository::findById);
    updatedProduct.setProductID(product.getProductID());
    updatedProduct.setUser(product.getUser());
    productRepository.save(updatedProduct);
    return updatedProduct;
  }

  public Product deleteProduct(UUID productId) {
    Product deletedProduct = getOrThrow(productId, productRepository::findById);
    productRepository.delete(deletedProduct);
    return deletedProduct;
  }

  public Product getProduct(String productId) {
    return getOrThrow(UUID.fromString(productId), productRepository::findById);
  }

}
