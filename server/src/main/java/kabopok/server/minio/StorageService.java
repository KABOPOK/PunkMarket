package kabopok.server.minio;

import io.minio.BucketExistsArgs;
import io.minio.GetObjectArgs;
import io.minio.GetPresignedObjectUrlArgs;
import io.minio.MakeBucketArgs;
import io.minio.MinioClient;
import io.minio.PutObjectArgs;
import io.minio.errors.ErrorResponseException;
import io.minio.errors.InsufficientDataException;
import io.minio.errors.InternalException;
import io.minio.errors.InvalidResponseException;
import io.minio.errors.MinioException;
import io.minio.errors.ServerException;
import io.minio.errors.XmlParserException;
import lombok.SneakyThrows;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.io.InputStream;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

@Service
public class StorageService {

  @Autowired
  private MinioClient minioClient;

  public void uploadFile(String bucketName, String objectName, InputStream inputStream, String contentType) {
    try {
      boolean found = minioClient.bucketExists(BucketExistsArgs.builder().bucket(bucketName).build());
      if (!found) {
        minioClient.makeBucket(MakeBucketArgs.builder().bucket(bucketName).build());
      }
      minioClient.putObject(
              PutObjectArgs.builder().bucket(bucketName).object(objectName).stream(
                              inputStream, inputStream.available(), -1)
                      .contentType(contentType)
                      .build());
    } catch (Exception e) {
      throw new RuntimeException("Error occurred: " + e.getMessage());
    }
  }

  public InputStream loadFile(String bucketName, String objectName) {
    try {
      // Retrieve the object from the bucket as an InputStream
      return minioClient.getObject(
              GetObjectArgs.builder()
                      .bucket(bucketName)
                      .object(objectName)
                      .build()
      );
    } catch (Exception e) {
      throw new RuntimeException("Error occurred during file download: " + e.getMessage());
    }
  }
  public String generateImageUrl(String bucketName, String objectName, int expiryTimeInSeconds) {
    try {
      // Create presigned URL for the object
      GetPresignedObjectUrlArgs args = GetPresignedObjectUrlArgs.builder()
              .bucket(bucketName)
              .object(objectName)
              .method(io.minio.http.Method.GET)  // Specify HTTP method (GET for download)
              .expiry(expiryTimeInSeconds)  // Expiry time in seconds
              .build();

      // Generate and return the presigned URL
      return minioClient.getPresignedObjectUrl(args);
    } catch (MinioException |
             InvalidKeyException | IOException | NoSuchAlgorithmException e) {
      throw new RuntimeException("Error generating presigned URL: " + e.getMessage(), e);
    }
  }
  @SneakyThrows(Exception.class)
  public String getPresignedObjectUrl(String bucketName, String objectName, Integer expires) {
    GetPresignedObjectUrlArgs args = GetPresignedObjectUrlArgs.builder().expiry(expires).bucket(bucketName).object(objectName).build();
    return minioClient.getPresignedObjectUrl(args);
  }

}
