package kabopok.server.repositories;

import kabopok.server.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface UserRepository extends JpaRepository<User, UUID> {
  Optional<User> findByNumber(String number);
//  @NotNull
//  Page<User> findAll(@NotNull Pageable pageable);
  @Query("SELECT u FROM User u LEFT JOIN FETCH u.productsWish WHERE u.userID = :userId")
  User findUserWithProductsWish(@Param("userId") UUID userId);

  List<User> findAllByIsReportedIsTrue();

}
