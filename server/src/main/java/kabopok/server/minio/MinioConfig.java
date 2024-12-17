package kabopok.server.minio;

import io.minio.MinioClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class MinioConfig {

  @Value("${minio.url}")
  private String minioUrl;
  public static String networkUrl;

  @Bean
  public MinioClient minioClient() {
    return MinioClient.builder()
            .endpoint(minioUrl)
            .credentials("minioadmin", "minioadmin")
            .build();
  }

}
