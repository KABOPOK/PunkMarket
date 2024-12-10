package kabopok.server.mappers;

import generated.kabopok.server.api.model.ProductDTO;
import kabopok.server.entities.Product;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper(componentModel = "spring", uses = {ProductMapper.class})
public interface ProductMapper {

  Product map(ProductDTO productDTO);

  ProductDTO map(Product product);

  List<ProductDTO> map(List<Product> productList);

}
