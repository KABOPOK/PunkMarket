package kabopok.server.minio;

import io.minio.BucketExistsArgs;
import io.minio.GetObjectArgs;
import io.minio.GetPresignedObjectUrlArgs;
import io.minio.ListObjectsArgs;
import io.minio.MakeBucketArgs;
import io.minio.MinioClient;
import io.minio.PutObjectArgs;
import io.minio.RemoveObjectArgs;
import io.minio.Result;
import io.minio.errors.ErrorResponseException;
import io.minio.errors.InsufficientDataException;
import io.minio.errors.InternalException;
import io.minio.errors.InvalidResponseException;
import io.minio.errors.MinioException;
import io.minio.errors.ServerException;
import io.minio.errors.XmlParserException;
import io.minio.messages.Item;
import kabopok.server.entities.Product;
import lombok.SneakyThrows;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.List;

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

  public void deleteFile(String bucketName, String objectName) {
    try {
      boolean found = minioClient.bucketExists(BucketExistsArgs.builder().bucket(bucketName).build());
      if (!found) {
        throw new RuntimeException("Bucket does not exist: " + bucketName);
      }
      minioClient.removeObject(RemoveObjectArgs.builder().bucket(bucketName).object(objectName).build());
    } catch (Exception e) {
      throw new RuntimeException("Error occurred while deleting the file: " + e.getMessage());
    }
  }

  public void deleteFolder(String bucketName, String folderName) {
    try {
      ListObjectsArgs listObjectsArgs = ListObjectsArgs.builder()
              .bucket(bucketName)
              .prefix(folderName)
              .recursive(true)
              .build();
      Iterable<Result<Item>> objects = minioClient.listObjects(listObjectsArgs);
      for (Result<Item> result : objects) {
        Item item = result.get();
        String objectName = item.objectName();
        minioClient.removeObject(RemoveObjectArgs.builder()
                .bucket(bucketName)
                .object(objectName)
                .build());
      }
    } catch (Exception e) {
      throw new RuntimeException("Error occurred while deleting the folder: " + e.getMessage());
    }
  }

  public String generateImageUrl(String bucketName, String objectName, int expiryTimeInSeconds) {
    try {
      GetPresignedObjectUrlArgs args = GetPresignedObjectUrlArgs.builder()
              .bucket(bucketName)
              .object(objectName)
              .method(io.minio.http.Method.GET)
              .expiry(expiryTimeInSeconds)
              .build();
      return minioClient.getPresignedObjectUrl(args);
    } catch (MinioException |
             InvalidKeyException | IOException | NoSuchAlgorithmException e) {
      throw new RuntimeException("Error generating presigned URL: " + e.getMessage(), e);
    }
  }

  public void uploadFiles(String bucketName, Product product, List<MultipartFile> images){
    for (MultipartFile image : images) {
      try (InputStream inputStream = image.getInputStream()) {
        String path = product.getUser().getUserID() + "/" + product.getProductID() + "/" + image.getOriginalFilename();
        uploadFile("products", path, inputStream, image.getContentType());
      } catch (IOException e) {
        throw new RuntimeException("Failed to upload images: " + e.getMessage(), e);
      }
    }
  }

}
