package kabopok.server.controllers;

import generated.kabopok.server.api.ProductApi;
import generated.kabopok.server.api.model.ProductDTO;
import kabopok.server.entities.Product;
import kabopok.server.mappers.ProductMapper;
import kabopok.server.minio.StorageService;
import kabopok.server.services.ProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequiredArgsConstructor
public class ProductController implements ProductApi {

  private final ProductService productService;
  private final ProductMapper productMapper;
  private final StorageService storageService;

  @Override
  public void createProduct(ProductDTO productDTO, List<MultipartFile> images) {
    Product product = productMapper.map(productDTO);
    productService.save(product);
    for (MultipartFile image : images) {
      try (InputStream inputStream = image.getInputStream()) {
        String objectName = product.getUserID() + "/" + image.getOriginalFilename();
        storageService.uploadFile("photos", objectName, inputStream, image.getContentType());
      } catch (IOException e) {
        throw new RuntimeException("Failed to upload images: " + e.getMessage(), e);
      }
    }
  }

  @Override
  public List<ProductDTO> getProducts(Integer page, Integer limit) {
    List<Product> productList = productService.getProducts(page, limit);
    List<ProductDTO> productDTOList = new ArrayList<>();
    productList.forEach(product -> {
      productDTOList.add(productMapper.map(product));
    });
    return productDTOList;
  }

}
