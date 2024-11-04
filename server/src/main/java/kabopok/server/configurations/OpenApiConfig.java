package kabopok.server.configurations;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.MediaType;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;

import java.util.Arrays;

@Configuration
public class OpenApiConfig {

  @Bean
  public MappingJackson2HttpMessageConverter octetStreamJsonConverter() {
    MappingJackson2HttpMessageConverter converter = new MappingJackson2HttpMessageConverter();
    converter.setSupportedMediaTypes(Arrays.asList(new MediaType("application", "octet-stream")));
    return converter;
  }
}
