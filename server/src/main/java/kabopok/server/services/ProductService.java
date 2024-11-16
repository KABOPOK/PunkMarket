package kabopok.server.services;

import kabopok.server.entities.Product;
import kabopok.server.repositories.ProductRepository;
import kabopok.server.repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ProductService extends DefaultService {

  private final ProductRepository productRepository;
  private final UserRepository userRepository;
  public UUID save(Product product) {
    UUID productID = UUID.randomUUID();
    product.setProductID(productID);
    productRepository.save(product);
    return productID;
  }

  public List<Product> getProducts(Integer page, Integer limit) {
    Pageable pageable = PageRequest.of(page - 1, limit);
    return productRepository.findAll(pageable).getContent();
  }
  public List<Product> getMyProducts(UUID userId, Integer page, Integer limit) {
    getOrThrow(userId, userRepository::findById);
    Pageable pageable = PageRequest.of(page - 1, limit);
    return productRepository.findAllByUserID(userId, pageable);
  }

  public List<Product> getMyFavProducts(List<UUID> productsIdList, Integer page, Integer limit){
    Pageable pageable = PageRequest.of(page - 1, limit);
    return productRepository.findByProductIdList(productsIdList,pageable);
  }

  public Product deleteProduct(UUID productId) {
    Product deletedProduct = getOrThrow(productId, productRepository::findById);
    productRepository.delete(deletedProduct);
    return deletedProduct;
  }

  public Product updateProduct(UUID productId, Product updatedProduct) {
    Product product  = getOrThrow(productId, productRepository::findById);
    updatedProduct.setProductID(product.getProductID());
    updatedProduct.setUserID(product.getUserID());
    productRepository.save(updatedProduct);
    return updatedProduct;
  }

}
