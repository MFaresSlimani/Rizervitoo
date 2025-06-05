import 'package:get/get.dart';
import '../core/services/user_service.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  Rxn<UserModel> user = Rxn<UserModel>();
  RxList<UserNotification> notifications = <UserNotification>[].obs;

  void setUser(UserModel newUser) {
    user.value = newUser;
    notifications.value = newUser.notifications;
  }

  void clearUser() {
    user.value = null;
    notifications.clear();
  }

  void addNotification(UserNotification notification) {
    notifications.insert(0, notification);
  }

  void markNotificationAsRead(String notificationId) {
    final idx = notifications.indexWhere((n) => n.id == notificationId);
    if (idx != -1) {
      notifications[idx] = UserNotification(
        id: notifications[idx].id,
        title: notifications[idx].title,
        body: notifications[idx].body,
        createdAt: notifications[idx].createdAt,
        read: true,
      );
      update();
    }
  }
}
