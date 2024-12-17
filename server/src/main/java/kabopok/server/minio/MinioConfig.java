package kabopok.server.minio;

import io.minio.MinioClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.net.InetAddress;
import java.net.UnknownHostException;

@Configuration
public class MinioConfig {
  @Value("${minio.url}")
  private String minioUrl;

  @Bean
  public MinioClient minioClient() throws UnknownHostException {
//    InetAddress inetAddress = InetAddress.getLocalHost();
//    String ip = inetAddress.getHostAddress();
//    minioUrl = minioUrl.replace("localhost", ip);
    return MinioClient.builder()
            .endpoint(minioUrl)
            .credentials("minioadmin", "minioadmin")
            .build();
  }

}
