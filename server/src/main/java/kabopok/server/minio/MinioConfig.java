package kabopok.server.minio;

import io.minio.MinioClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class MinioConfig {
  @Value("${minio.url}")
  private String minioUrl;

  @Bean
  public MinioClient minioClient() {
    return MinioClient.builder()
            .endpoint(minioUrl)  // MinIO endpoint
            .credentials("minioadmin", "minioadmin")  // Access key and secret key
            .build();
  }
}
