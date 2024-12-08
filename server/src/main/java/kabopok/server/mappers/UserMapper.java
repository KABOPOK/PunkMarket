package kabopok.server.mappers;

import generated.kabopok.server.api.model.UserDTO;
import generated.kabopok.server.api.model.UserWithWishListDTO;
import kabopok.server.entities.User;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring", uses = {UserMapper.class})
public interface UserMapper {

  User map(UserDTO userDTO);
  User mapWithWishList(UserWithWishListDTO userWithWishListDTO);
  UserWithWishListDTO mapWithWishList(User user);
  UserDTO map (User user);

}