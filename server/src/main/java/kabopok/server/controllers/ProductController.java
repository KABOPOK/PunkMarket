package kabopok.server.controllers;

import generated.kabopok.server.api.ProductApi;
import generated.kabopok.server.api.model.ProductDTO;
import kabopok.server.entities.Product;
import kabopok.server.entities.User;
import kabopok.server.mappers.ProductMapper;
import kabopok.server.minio.StorageService;
import kabopok.server.repositories.UserRepository;
import kabopok.server.services.ProductService;
import kabopok.server.services.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
public class ProductController implements ProductApi {

  private final ProductService productService;
  private final ProductMapper productMapper;
  private final StorageService storageService;

  private final UserService userService;
  @Override
  public void createProduct(ProductDTO productDTO, List<MultipartFile> images) {
    Product product = productMapper.map(productDTO);
    UUID productId = productService.save(product);
    product.setProductID(productId);
    for (MultipartFile image : images) {
      try (InputStream inputStream = image.getInputStream()) {
        String path = product.getUserID() + "/" + product.getProductID() + "/" + image.getOriginalFilename();
        storageService.uploadFile("products", path, inputStream, image.getContentType());
      } catch (IOException e) {
        throw new RuntimeException("Failed to upload images: " + e.getMessage(), e);
      }
    }
  }

  @Override
  public List<ProductDTO> getMyProducts(UUID userId, Integer page, Integer limit) {
    User user = userService.findById(userId);
    List<Product> productList = productService.getMyProducts(userId,page,limit);
    List<ProductDTO> productDTOList = new ArrayList<>();
    productList.forEach(product -> {
      String path = product.getUserID() + "/" + product.getProductID()  + "/" + "envelop.jpg";
      String url = storageService.generateImageUrl("products", path,3600);
      product.setPhotoUrl(url);
      productDTOList.add(productMapper.map(product));
    });
    return productDTOList;
  }

  @Override
  public List<ProductDTO> getProducts(Integer page, Integer limit) {
    List<Product> productList = productService.getProducts(page, limit);
    List<ProductDTO> productDTOList = new ArrayList<>();
    productList.forEach(product -> {
      String path = product.getUserID() + "/" + product.getProductID()  + "/" + "envelop.jpg";
      String url = storageService.generateImageUrl("products", path,3600);
      product.setPhotoUrl(url);
      productDTOList.add(productMapper.map(product));
    });
    return productDTOList;
  }

}
