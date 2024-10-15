import '../clases/User.dart';

class Online {
  static User user = User();

  Online({User? newUser}) {
    if (newUser != null) {
      user = newUser;
    }
  }
}