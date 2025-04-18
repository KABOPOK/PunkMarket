package kabopok.server.repositories;

import kabopok.server.entities.Product;
import kabopok.server.entities.User;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.UUID;

public interface ProductRepository extends JpaRepository<Product, UUID> {

  List<Product> findAllByUser(User user, Pageable pageable);

  @Query("SELECT p FROM Product p WHERE p.productID IN :productIdList")
  List<Product> findByProductIdList(@Param("productIdList") List<UUID> productIdList, Pageable pageable);

  List<Product> findAllByTitleContaining(String query, Pageable pageable);

  List<Product> findAllByIsReportedIsTrue();

}
