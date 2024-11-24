package kabopok.server;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.test.util.TestPropertyValues;
import org.springframework.context.ApplicationContextInitializer;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.stereotype.Component;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.containers.output.Slf4jLogConsumer;
import org.testcontainers.utility.DockerImageName;

import java.time.Duration;

@Slf4j
public class PostgresTestContainerConfig {

  private static volatile PostgreSQLContainer<?> postgreSQLContainer = null;

  private static PostgreSQLContainer<?> getPostgreSQLContainer() {
    PostgreSQLContainer<?> instance = postgreSQLContainer;
    if (instance == null) {
      DockerImageName myImage = DockerImageName.parse("postgis/postgis:15-3.4-alpine").asCompatibleSubstituteFor("postgres");
      synchronized (PostgreSQLContainer.class) {
        postgreSQLContainer = instance =
                new PostgreSQLContainer<>(myImage)
                        .withReuse(true)
                        .withLogConsumer(new Slf4jLogConsumer(log))
                        .withStartupTimeout(Duration.ofSeconds(60));
        postgreSQLContainer.start();
      }
    }
    return instance;
  }

  @Component("PostgresInitializer")
  public static class Initializer implements ApplicationContextInitializer<ConfigurableApplicationContext> {

    @Override
    public void initialize(ConfigurableApplicationContext configurableApplicationContext) {
      var postgreSQLContainer = getPostgreSQLContainer();
      TestPropertyValues.of(
              "spring.datasource.url=" + postgreSQLContainer.getJdbcUrl(),
              "spring.datasource.username=" + postgreSQLContainer.getUsername(),
              "spring.datasource.password=" + postgreSQLContainer.getPassword()
      ).applyTo(configurableApplicationContext.getEnvironment());
    }
  }

}
