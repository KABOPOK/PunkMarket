package kabopok.server;

import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;

import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.util.Objects;

import static com.jayway.jsonpath.internal.path.PathCompiler.fail;

public class Functions {

  static boolean compareResources(Resource sentResource, String photoUrl, String expectedFileName) {
    Resource receivedResource;
    try {
      receivedResource = new UrlResource(photoUrl);
    } catch (MalformedURLException e) {
      fail("URL is malformed: " + photoUrl);
      return false;
    }
    try (
            InputStream sentStream = sentResource.getInputStream();
            InputStream receivedStream = receivedResource.getInputStream()
    ) {
      byte[] sentBytes = sentStream.readAllBytes();
      byte[] receivedBytes = receivedStream.readAllBytes();
      if (!Objects.deepEquals(sentBytes, receivedBytes)) {
        return false;
      }
    } catch (IOException e) {
      fail("Error reading resource content: " + e.getMessage());
      return false;
    }
    String receivedFilename = receivedResource.getFilename();
    return Objects.equals(expectedFileName, receivedFilename);
  }

}
