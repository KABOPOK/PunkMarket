package kabopok.server;

import kabopok.server.entities.Product;
import kabopok.server.entities.User;

import java.util.ArrayList;
import java.util.UUID;

public class SampleObjectGenerator {

  public static User createSampleUser(){
    User user = new User();
    user.setUserID(UUID.randomUUID());
    user.setUserName("testUser");
    user.setNumber(String.valueOf((int)(Math.random() * 1000000000 + 1)));
    user.setPassword("password123");
    user.setLocation("testLocation");
    user.setTelegramID("tg123456789");
    user.setPhotoUrl("halo");
    user.setProducts(new ArrayList<>());
    user.setProductsWish(new ArrayList<>());
    return user;
  }

  static public Product createSampleProduct(User user){
    Product product = new Product();
    product.setProductID(UUID.randomUUID());
    product.setOwnerName(user.getUserName());
    product.setDescription("productDescription");
    product.setPrice("1999.99");
    product.setUser(user);
    product.setCategory("sampleCategory");
    product.setTitle("sampleTitle");
    product.setLocation("sampleLocation");
    product.setPhotoUrl("hola");
    product.setUsersWishedBy(null);
    return product;
  }

}
