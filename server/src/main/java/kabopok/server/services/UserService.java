package kabopok.server.services;

import generated.kabopok.server.api.model.LoginDataDTO;
import io.minio.MinioClient;
import io.minio.PutObjectArgs;
import io.minio.errors.*;
import kabopok.server.entities.Product;
import kabopok.server.entities.User;
import kabopok.server.repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UserService extends DefaultService {

  private final UserRepository userRepository;
  private final JdbcTemplate jdbcTemplate;
  private final MinioClient minioClient;
  public UUID save(User user) {
    UUID userID = UUID.randomUUID();
    user.setUserID(userID);
    user.setPhotoUrl(userID.toString());
    userRepository.save(user);
    return userID;
  }

  public User findByNumber(LoginDataDTO loginDataDTO){
    User current = getOrThrow(loginDataDTO.getNumber(),userRepository::findByNumber);
    if(!current.getPassword().equals(loginDataDTO.getPassword())){
      throw new RuntimeException("Wrong answer");
    }
    return current;
  }

  public User findById(UUID userId){
    return getOrThrow(userId, userRepository::findById);
  }

  public User deleteUser(UUID userId){
    User deletedUser = getOrThrow(userId, userRepository::findById);
    userRepository.delete(deletedUser);
    return  deletedUser;
  }

  public User updateUser(UUID userId, User updatedUser){
    User user = getOrThrow(userId, userRepository::findById);
    updatedUser.setUserID(user.getUserID());
    userRepository.save(updatedUser);
    return updatedUser;
  }

}
