package kabopok.server.mappers;

import generated.kabopok.server.api.model.ProductDTO;
import kabopok.server.entities.Product;
import kabopok.server.entities.User;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;

import java.util.List;
import java.util.UUID;

@Mapper(componentModel = "spring", uses = {ProductMapper.class})
public interface ProductMapper {

  Product map(ProductDTO productDTO);

  @Mapping(target = "userID", source = "product.user", qualifiedByName = "toUUID")
  ProductDTO map(Product product);

  List<ProductDTO> map(List<Product> productList);

  @Named("toUUID")
  default UUID mapUser(User user){
    return user.getUserID();
  }
}
