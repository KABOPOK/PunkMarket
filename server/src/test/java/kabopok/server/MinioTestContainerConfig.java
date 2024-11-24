package kabopok.server;

import org.springframework.context.ApplicationContextInitializer;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.boot.test.util.TestPropertyValues;
import org.testcontainers.containers.GenericContainer;
import org.testcontainers.containers.wait.strategy.Wait;

public class MinioTestContainerConfig {

  public static class Initializer implements ApplicationContextInitializer<ConfigurableApplicationContext> {
    @Override
    public void initialize(ConfigurableApplicationContext applicationContext) {
      GenericContainer<?> minioContainer = MinioTestContainerConfig.getMinioContainer();
      TestPropertyValues.of(
              "minio.url=http://localhost:" + minioContainer.getMappedPort(9000),
              "minio.access.key=minioaccesskey",
              "minio.secret.key=miniosecretkey"
      ).applyTo(applicationContext.getEnvironment());
    }
  }

  private static volatile GenericContainer<?> minioContainer = null;
  public static GenericContainer<?> getMinioContainer() {
    if (minioContainer == null) {
      synchronized (GenericContainer.class) {
        minioContainer = new GenericContainer<>("minio/minio:latest")
                .withExposedPorts(9000)
                .waitingFor(Wait.forListeningPort())
                .withEnv("MINIO_ACCESS_KEY", "minioaccesskey")
                .withEnv("MINIO_SECRET_KEY", "miniosecretkey")
                .withCommand("server /data");
        minioContainer.start();
      }
    }
    return minioContainer;
  }

}
