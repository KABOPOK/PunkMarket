package kabopok.server;

import generated.kabopok.server.api.model.LoginDataDTO;
import generated.kabopok.server.api.model.UserDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import java.util.List;

@Component
public class HttpSteps {

  @Autowired
  private TestRestTemplate testRestTemplate;
  
  public <T> ResponseEntity<T> sendMultipartPostRequest(Object userDTO, Resource resource, String url, Class<T> responseType) {
    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(MediaType.MULTIPART_FORM_DATA);
    MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
    body.add("user", userDTO);
    body.add("image", resource);
    HttpEntity<MultiValueMap<String, Object>> request = new HttpEntity<>(body, headers);
    return testRestTemplate.exchange(
            url,
            HttpMethod.POST,
            request,
            responseType
    );
  }
  public <T> ResponseEntity<T> sendMultipartPostRequest(Object productDTO, List<Resource> resources, String url, Class<T> responseType) {
    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(MediaType.MULTIPART_FORM_DATA);
    MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
    body.add("product", productDTO);
    resources.forEach(resource -> body.add("images", resource));
    HttpEntity<MultiValueMap<String, Object>> request = new HttpEntity<>(body, headers);
    return testRestTemplate.exchange(
            url,
            HttpMethod.POST,
            request,
            responseType
    );
  }

  public <T> ResponseEntity<T> sendMultipartPutRequest(Object userDTO, Resource resource, String url, Class<T> responseType){
    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(MediaType.MULTIPART_FORM_DATA);
    MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
    body.add("user", userDTO);
    body.add("image", resource);
    HttpEntity<MultiValueMap<String, Object>> request = new HttpEntity<>(body, headers);
    return testRestTemplate.exchange(
            url,
            HttpMethod.PUT,
            request,
            responseType
    );
  }

  public <T> ResponseEntity<T> sendMultipartPutRequest(Object productDTO, List<Resource> resources, String url, Class<T> responseType){
    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(MediaType.MULTIPART_FORM_DATA);
    MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
    body.add("product", productDTO);
    resources.forEach(resource -> body.add("images", resource));
    HttpEntity<MultiValueMap<String, Object>> request = new HttpEntity<>(body, headers);
    return testRestTemplate.exchange(
            url,
            HttpMethod.PUT,
            request,
            responseType
    );
  }

  public ResponseEntity<Void> sendRequestWithoutBodyVoid(String url, HttpMethod method) {
    return testRestTemplate.exchange(
            url,
            method,
            null,
            Void.class
    );
  }

  public ResponseEntity<UserDTO> sendAuthorizeUserRequest(String url, LoginDataDTO loginData) {
    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(MediaType.APPLICATION_JSON);
    HttpEntity<LoginDataDTO> request = new HttpEntity<>(loginData, headers);
    return testRestTemplate.postForEntity(url, request, UserDTO.class);
  }

  public <T> ResponseEntity<List<T>> sendGetRequest(String url, ParameterizedTypeReference<List<T>> responseType) {
    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(MediaType.APPLICATION_JSON);
    HttpEntity<Object> request = new HttpEntity<>(headers);
    return testRestTemplate.exchange(
            url,
            HttpMethod.GET,
            request,
            responseType
    );
  }

  public ResponseEntity<Boolean> sendAddToWishListRequest(String url) {
    return testRestTemplate.exchange(
            url,
            HttpMethod.POST,
            null,
            Boolean.class
    );
  }

}
