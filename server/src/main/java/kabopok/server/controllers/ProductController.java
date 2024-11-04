package kabopok.server.controllers;

import generated.kabopok.server.api.ProductApi;
import generated.kabopok.server.api.model.IdDTO;
import generated.kabopok.server.api.model.ProductDTO;
import kabopok.server.entities.Product;
import kabopok.server.mappers.ProductMapper;
import kabopok.server.services.ProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequiredArgsConstructor
public class ProductController implements ProductApi {

  private final ProductService productService;
  private final ProductMapper productMapper;

  @Override
  public void createProduct(ProductDTO productDTO) {
    Product product = productMapper.map(productDTO);
    productService.save(product);
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
