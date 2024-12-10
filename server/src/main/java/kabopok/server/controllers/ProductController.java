package kabopok.server.controllers;

import generated.kabopok.server.api.ProductApi;
import generated.kabopok.server.api.model.ProductDTO;
import kabopok.server.entities.Product;
import kabopok.server.mappers.ProductMapper;
import kabopok.server.minio.StorageService;
import kabopok.server.services.ProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
public class ProductController implements ProductApi {

  private final ProductService productService;
  private final ProductMapper productMapper;

  private final StorageService storageService;

  @Override
  public void createProduct(ProductDTO productDTO, List<MultipartFile> images) {
    Product product = productMapper.map(productDTO);
    productService.save(product, productDTO.getUserID(), images);
  }

  @Override
  public void deleteProduct(UUID productId) {
    productService.deleteProduct(productId);

  }

  @Override
  public List<ProductDTO> getMyProducts(UUID userId, Integer page, Integer limit) {
    return productMapper.map(productService.getMyProducts(userId,page,limit));
  }

  @Override
  @Transactional
  public List<String> getProductUrlList(String productId) {
    Product product = productService.getProduct(productId);
    String path = product.getUser().getUserID() + "/" + product.getProductID() + "/";
    return storageService.getProductUrlList("products", path);
  }

  @Override
  public List<ProductDTO> getProducts(Integer page, Integer limit, String query) {
    return productMapper.map(productService.getProducts(page, limit, query));
  }

  @Override
  public void updateProduct(UUID productId, ProductDTO productDTO, List<MultipartFile> images) {
    Product updatedProduct = productMapper.map(productDTO);
    productService.updateProduct(productId, updatedProduct, images);
  }

}
