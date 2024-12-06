package kabopok.server;

import kabopok.server.entities.User;

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
    user.setProducts(null);
    user.setProductsWish(null);
    return user;
  }

}
