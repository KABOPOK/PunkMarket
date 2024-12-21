package kabopok.server.services;

import kabopok.server.entities.Product;
import kabopok.server.entities.User;
import kabopok.server.minio.StorageService;
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
  private final StorageService storageService;

  @Transactional
  public void save(Product product, UUID userId, List<MultipartFile> images) {
    User user = getOrThrow(userId, userRepository::findById);
    product.setUser(user);
    product.setProductID(UUID.randomUUID());
    storageService.uploadFiles("products", product, images);
    String path = product.getUser().getUserID() + "/" + product.getProductID()  + "/" + "envelop.jpg";
    product.setPhotoUrl(storageService.generateImageUrl("products", path));
    productRepository.save(product);
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
  public void deleteProduct(UUID productId) {
    Product deletedProduct = getOrThrow(productId, productRepository::findById);
    productRepository.delete(deletedProduct);
    String path = deletedProduct.getUser().getUserID() + "/" + deletedProduct.getProductID();
    storageService.deleteFolder("products",path);
  }

  @Transactional
  public void updateProduct(UUID productId, Product updatedProduct, List<MultipartFile> images) {
    Product product  = getOrThrow(productId, productRepository::findById);
    updatedProduct.setProductID(product.getProductID());
    updatedProduct.setUser(product.getUser());
    String path = updatedProduct.getUser().getUserID() + "/" + updatedProduct.getProductID();
    if (images != null) {
      storageService.deleteFolder("products", path);
      storageService.uploadFiles("products", updatedProduct, images);
    }
    path = product.getUser().getUserID() + "/" + product.getProductID()  + "/" + "envelop.jpg";
    updatedProduct.setPhotoUrl(storageService.generateImageUrl("products", path));
    productRepository.save(updatedProduct);
  }

  public Product getProduct(String productId) {
    return getOrThrow(UUID.fromString(productId), productRepository::findById);
  }

  public void sellProduct(UUID productId) {
    Product product  = getOrThrow(productId, productRepository::findById);
    product.setIsSold(true);
    productRepository.save(product);
  }

  public void reportOnProduct(UUID productId) {
    Product product  = getOrThrow(productId, productRepository::findById);
    product.setIsReported(true);
    productRepository.save(product);
  }

  public void declineReportOnProduct(UUID productId) {
    Product product  = getOrThrow(productId, productRepository::findById);
    product.setIsReported(false);
    productRepository.save(product);
  }

}
