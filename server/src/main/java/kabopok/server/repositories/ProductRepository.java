package kabopok.server.repositories;

import kabopok.server.entities.Product;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.UUID;

public interface ProductRepository extends JpaRepository<Product, UUID> {

  List<Product> findAllByUserID(UUID userId, Pageable pageable);
  @Query("SELECT p FROM Product p WHERE p.productID IN :productIdList")
  List<Product> findByProductIdList(@Param("productIdList") List<UUID> productIdList, Pageable pageable);


}
