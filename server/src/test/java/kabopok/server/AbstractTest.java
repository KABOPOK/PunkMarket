package kabopok.server;

import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.flyway.FlywayAutoConfiguration;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;

@ActiveProfiles("test")
@EnableAutoConfiguration(exclude = FlywayAutoConfiguration.class)
@ContextConfiguration(initializers = {
        PostgresTestContainerConfig.Initializer.class,
        MinioTestContainerConfig.Initializer.class
})
@SpringBootTest(classes = ServerApplication.class, webEnvironment = SpringBootTest.WebEnvironment.NONE)
public abstract class AbstractTest {
}
