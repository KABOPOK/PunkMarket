package kabopok.server.minio;

import io.minio.MinioClient;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class MinioConfig {

  @Bean
  public MinioClient minioClient() {
    return MinioClient.builder()
            .endpoint("http://localhost:9000")  // MinIO endpoint
            .credentials("minioadmin", "minioadmin")  // Access key and secret key
            .build();
  }
}
