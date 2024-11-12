package kabopok.server.repositories;

import kabopok.server.entities.Product;
import kabopok.server.entities.User;
import org.jetbrains.annotations.NotNull;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface ProductRepository extends JpaRepository<Product, UUID> {

  List<Product> findAllByUserID(UUID userId, Pageable pageable);
}
