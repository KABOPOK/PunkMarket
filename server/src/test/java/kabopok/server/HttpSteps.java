package kabopok.server;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.http.*;
import org.springframework.stereotype.Component;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;

import java.io.IOException;
import java.util.UUID;

@Component
public class HttpSteps {

  @Autowired
  private TestRestTemplate testRestTemplate;

  public <T> ResponseEntity<T> sendDeleteRequest(UUID userID, String url, Class<T> responseType) throws IOException {
    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(MediaType.MULTIPART_FORM_DATA);

    // Build multipart request body
    MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
    body.add("userId", userID.toString()); // Assuming `userID` can be serialized correctly
    //body.add("image", new FileSystemResource(imageFile));

    // Create HttpEntity with headers and body
    HttpEntity<MultiValueMap<String, Object>> request = new HttpEntity<>(body, headers);

    // Send POST request
    return testRestTemplate.exchange(
            url,
            HttpMethod.DELETE,
            request,
            responseType
    );
  }
}
