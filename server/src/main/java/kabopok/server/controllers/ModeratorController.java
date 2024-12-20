package kabopok.server.controllers;

import generated.kabopok.server.api.ModeratorApi;
import generated.kabopok.server.api.model.ProductDTO;
import generated.kabopok.server.api.model.UserDTO;
import kabopok.server.mappers.ProductMapper;
import kabopok.server.mappers.UserMapper;
import kabopok.server.repositories.ProductRepository;
import kabopok.server.repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Objects;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
public class ModeratorController implements ModeratorApi {

  private final ProductRepository productRepository;
  private final UserRepository userRepository;
  private final ProductMapper productMapper;
  private final UserMapper userMapper;

  @Override
  public List<ProductDTO> getReportedProducts(UUID key) {
    if(Objects.equals(key.toString(), "da10e78e-2bdb-46cc-b53a-70a7612dff24")){
      return productMapper.map(productRepository.findAllByIsReportedIsTrue());
    }
    return null;
  }

  @Override
  public List<UserDTO> getReportedUsers(UUID key) {
    if(Objects.equals(key.toString(), "da10e78e-2bdb-46cc-b53a-70a7612dff24")){
      return userMapper.map(userRepository.findAllByIsReportedIsTrue());
    }
    return null;
  }

  @Override
  public Boolean isModerator(UUID moderatorKey) {
    return Objects.equals(moderatorKey.toString(), "da10e78e-2bdb-46cc-b53a-70a7612dff24");
  }

}
