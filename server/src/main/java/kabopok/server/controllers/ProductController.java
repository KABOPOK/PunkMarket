package kabopok.server.controllers;

import generated.kabopok.server.api.ProductApi;
import generated.kabopok.server.api.model.ProductDTO;
import jakarta.validation.constraints.NotNull;
import kabopok.server.entities.Product;
import kabopok.server.entities.User;
import kabopok.server.mappers.ProductMapper;
import kabopok.server.minio.StorageService;
import kabopok.server.services.ProductService;
import kabopok.server.services.UserService;
import kabopok.server.services.WishlistService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
public class ProductController implements ProductApi {

  private final ProductService productService;
  private final ProductMapper productMapper;
  private final StorageService storageService;
  private final WishlistService wishlistService;

  private final UserService userService;

  @Override
  public void createProduct(ProductDTO productDTO, List<MultipartFile> images) {
    Product product = productMapper.map(productDTO);
    UUID productId = productService.save(product);
    product.setProductID(productId);
    storageService.uploadFiles("products", product, images);
  }

  @Override
  public void deleteProduct(UUID productId) {
    Product product = productService.deleteProduct(productId);
    String path = product.getUserID() + "/" + product.getProductID();
    storageService.deleteFolder("products",path);
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

  @Override
  public List<ProductDTO> getWishlist(@NotNull String userId, @NotNull String productId, Integer page, Integer limit) {
    List<UUID> productsIdList =  wishlistService.getWishlist(UUID.fromString(userId), UUID.fromString(productId));
    List<Product> productList = productService.getMyFavProducts(productsIdList,page,limit);
    List<ProductDTO> productDTOList = new ArrayList<>();
    productList.forEach(product -> {
      productDTOList.add(productMapper.map(product));
    });
    return productDTOList;
  }

  @Override
  public void updateProduct(UUID productId, ProductDTO productDTO, List<MultipartFile> images) {
    Product updatedProduct = productMapper.map(productDTO);
    updatedProduct = productService.updateProduct(productId, updatedProduct);
    String path = updatedProduct.getUserID() + "/" + updatedProduct.getProductID();
    storageService.deleteFolder("products",path);
    storageService.uploadFiles("products", updatedProduct, images);
  }

}
