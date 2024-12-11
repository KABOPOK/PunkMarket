package kabopok.server.minio;

import io.minio.*;
import io.minio.errors.MinioException;
import io.minio.messages.Item;
import kabopok.server.entities.Product;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.net.URLConnection;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;

@Service
public class StorageService {

  @Autowired
  private MinioClient minioClient;

  public void uploadFile(String bucketName, String objectName, MultipartFile image) {
    if (image == null) { return; }
    try {
      InputStream inputStream = image.getInputStream();
      boolean found = minioClient.bucketExists(BucketExistsArgs.builder().bucket(bucketName).build());
      if (!found) {
        minioClient.makeBucket(MakeBucketArgs.builder().bucket(bucketName).build());
      }
      minioClient.putObject(
              PutObjectArgs.builder().bucket(bucketName).object(objectName).stream(
                              inputStream, inputStream.available(), -1)
                      .contentType(image.getContentType())
                      .build());
    } catch (Exception e) {
      throw new RuntimeException("Error occurred: " + e.getMessage());
    }
  }

  public void uploadFile(String bucketName, String objectName, Resource image) {
    if (image == null) { return; }
    try {
      InputStream inputStream = image.getInputStream();
      boolean found = minioClient.bucketExists(BucketExistsArgs.builder().bucket(bucketName).build());
      if (!found) {
        minioClient.makeBucket(MakeBucketArgs.builder().bucket(bucketName).build());
      }
      String contentType = URLConnection.guessContentTypeFromStream(inputStream);
      if (contentType == null) {
        contentType = "application/octet-stream";
      }
      minioClient.putObject(PutObjectArgs.builder().bucket(bucketName).object(objectName).stream(inputStream, inputStream.available(), -1).contentType(contentType).build());
    } catch (Exception e) {
      throw new RuntimeException("Error occurred: " + e.getMessage(), e);
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

  public String generateImageUrl(String bucketName, String objectName) {
    try {
      GetPresignedObjectUrlArgs args = GetPresignedObjectUrlArgs.builder()
              .bucket(bucketName)
              .object(objectName)
              .method(io.minio.http.Method.GET)
              .build();
      return minioClient.getPresignedObjectUrl(args);
    } catch (MinioException |
             InvalidKeyException | IOException | NoSuchAlgorithmException e) {
      throw new RuntimeException("Error generating presigned URL: " + e.getMessage(), e);
    }
  }

  public void uploadFiles(String bucketName, Product product, List<MultipartFile> images){
    for (MultipartFile image : images) {
      String path = product.getUser().getUserID() + "/" + product.getProductID() + "/" + image.getOriginalFilename();
      uploadFile(bucketName, path, image);
    }
  }

  public List<String> getProductUrlList(String bucketName, String path) {
    List<String> urlList = new ArrayList<>();
    try {
      Iterable<Result<Item>> objects = minioClient.listObjects(
              ListObjectsArgs.builder()
                      .bucket(bucketName)
                      .prefix(path)
                      .build()
      );
      for (Result<Item> item : objects) {
        String objectName = item.get().objectName();
        String imageUrl = generateImageUrl(bucketName, objectName);
        urlList.add(imageUrl);
      }
    } catch (MinioException | InvalidKeyException | IOException | NoSuchAlgorithmException e) {
      throw new RuntimeException("Error listing objects or generating URLs: " + e.getMessage(), e);
    }
    return urlList;
  }

}
