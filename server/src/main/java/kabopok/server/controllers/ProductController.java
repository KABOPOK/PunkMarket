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
  @Transactional
  public void createProduct(ProductDTO productDTO, List<MultipartFile> images) {
    Product product = productMapper.map(productDTO);
    product = productService.save(product, productDTO.getUserID());
    storageService.uploadFiles("products", product, images);
    String path = product.getUser().getUserID() + "/" + product.getProductID()  + "/" + "envelop.jpg";
    product.setPhotoUrl(storageService.generateImageUrl("products", path));
  }

  @Override
  @Transactional
  public List<ProductDTO> getProducts(Integer page, Integer limit, String query) {
    List <Product> productList = productService.getProducts(page, limit, query);
    storageService.generateImageUrls("users", productList);
    return productMapper.map(productList);
  }

  @Override
  @Transactional
  public List<ProductDTO> getMyProducts(UUID userId, Integer page, Integer limit) {
    List <Product> productList = productService.getMyProducts(userId,page,limit);
    storageService.generateImageUrls("users", productList);
    return productMapper.map(productList);
  }

  @Override
  @Transactional
  public void updateProduct(UUID productId, ProductDTO productDTO, List<MultipartFile> images) {
    Product updatedProduct = productMapper.map(productDTO);
    updatedProduct = productService.updateProduct(productId, updatedProduct);
    String path = updatedProduct.getUser().getUserID() + "/" + updatedProduct.getProductID();
    if (images != null) {
      storageService.deleteFolder("products", path);
      storageService.uploadFiles("products", updatedProduct, images);
    }
    path = updatedProduct.getUser().getUserID() + "/" + updatedProduct.getProductID()  + "/" + "envelop.jpg";
    updatedProduct.setPhotoUrl(storageService.generateImageUrl("products", path));
  }

  @Override
  @Transactional
  public void deleteProduct(UUID productId) {
    Product deletedProduct = productService.deleteProduct(productId);
    String path = deletedProduct.getUser().getUserID() + "/" + deletedProduct.getProductID();
    storageService.deleteFolder("products", path);
  }

  @Override
  @Transactional
  public List<String> getProductUrlList(String productId) {
    Product product = productService.getProduct(productId);
    String path = product.getUser().getUserID() + "/" + product.getProductID() + "/";
    return storageService.getProductUrlList("products", path);
  }

}
