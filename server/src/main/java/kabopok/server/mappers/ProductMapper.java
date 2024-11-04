package kabopok.server.mappers;

import generated.kabopok.server.api.model.ProductDTO;
import kabopok.server.entities.Product;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring", uses = {ProductMapper.class})
public interface ProductMapper {

  public Product map(ProductDTO productDTO);
  public ProductDTO map(Product product);

}
