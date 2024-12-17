package kabopok.server.services;

import generated.kabopok.server.api.model.LoginDataDTO;
import kabopok.server.entities.User;
import kabopok.server.repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UserService extends DefaultService {

  private final UserRepository userRepository;

  public UUID save(User user) {
    user.setUserID(UUID.randomUUID());
    userRepository.save(user);
    return user.getUserID();
  }

  public User getUser(LoginDataDTO loginDataDTO){
    User current = getOrThrow(loginDataDTO.getNumber(),userRepository::findByNumber);
    if(!current.getPassword().equals(loginDataDTO.getPassword())){
      throw new RuntimeException("Wrong answer");
    }
    return current;
  }

  public User getUser(UUID id){
    return getOrThrow(id, userRepository::findById);
  }

  public UUID deleteUser(UUID userId){
    User deletedUser = getOrThrow(userId, userRepository::findById);
    userRepository.delete(deletedUser);
    return deletedUser.getUserID();
  }

  public User updateUser(UUID userId, User updatedUser){
    User user = getOrThrow(userId, userRepository::findById);
    updatedUser.setUserID(user.getUserID());
    userRepository.save(updatedUser);
    return updatedUser;
  }

}
