package kabopok.server.services;

import generated.kabopok.server.api.ProductApi;
import generated.kabopok.server.api.model.ProductDTO;
import generated.kabopok.server.api.model.UserDTO;
import kabopok.server.entities.Product;
import kabopok.server.entities.User;
import kabopok.server.repositories.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ProductService {

  private final ProductRepository productRepository;
  public void save(Product product) {
    UUID productID = UUID.randomUUID();
    product.setProductID(productID);
    productRepository.save(product);
  }

  public List<Product> getProducts(Integer page, Integer limit) {
    Pageable pageable = PageRequest.of(page - 1, limit); // Page number is zero-based in Pageable
    return productRepository.findAll(pageable).getContent();
  }

}
