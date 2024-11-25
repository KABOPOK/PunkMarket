package kabopok.server.repositories;

import kabopok.server.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface UserRepository extends JpaRepository<User, UUID> {
  Optional<User> findByNumber(String number);
//  @NotNull
//  Page<User> findAll(@NotNull Pageable pageable);
}
