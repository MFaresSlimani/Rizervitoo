import 'package:get/get.dart';
import '../models/user_profile.dart';

class UserController extends GetxController {
  Rxn<UserProfile> user = Rxn<UserProfile>();

  void setUser(UserProfile newUser) {
    user.value = newUser;
  }

  void clearUser() {
    user.value = null;
  }
}
