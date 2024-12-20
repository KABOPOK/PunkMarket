package kabopok.server.mappers;

import generated.kabopok.server.api.model.UserDTO;
import kabopok.server.entities.User;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper(componentModel = "spring", uses = {UserMapper.class})
public interface UserMapper {

  User map(UserDTO request);

  UserDTO map (User user);

  List<UserDTO> map(List<User> allByIsReportedIsTrue);

}