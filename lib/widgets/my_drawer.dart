import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Rizervitoo/screens/guide/guide_screen.dart';
import 'package:Rizervitoo/screens/profile/profile_screen.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../controllers/user_controller.dart';
import '../core/services/auth_service.dart';
import '../screens/login/login_screen.dart';
import '../screens/settings/settings_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    return Container(
      width: 200,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue[900]!,
            Colors.blue[700]!,
            Colors.blue[300]!.withOpacity(0.5),
          ],
          stops: const [0.0, 0.7, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(),
            child: Column(
              children: [
                Obx(
                  () => CircleAvatar(
                    radius: 40,
                    backgroundImage: userController.user.value?.imageUrl != null
                        ? NetworkImage(userController.user.value!.imageUrl!)
                        : const AssetImage('assets/avatar.png')
                            as ImageProvider,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  userController.user.value?.name.capitalize ?? 'guest'.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            iconColor: Colors.white,
            textColor: Colors.white,
            leading: const Icon(LucideIcons.home),
            title: Text('home'.tr),
            onTap: () {
              Get.back();
            },
          ),
          ListTile(
            iconColor: Colors.white,
            textColor: Colors.white,
            leading: const Icon(LucideIcons.bookOpen),
            title: Text('travel_guide'.tr),
            onTap: () {
              Get.to(() => GuideScreen());
            },
          ),
          ListTile(
            iconColor: Colors.white,
            textColor: Colors.white,
            leading: const Icon(LucideIcons.user),
            title: Text('profile'.tr),
            onTap: () {
              Get.to(() => ProfileScreen());
            },
          ),
          ListTile(
            iconColor: Colors.white,
            textColor: Colors.white,
            leading: const Icon(LucideIcons.settings),
            title: Text('settings'.tr),
            onTap: () {
              Get.to((() => SettingsScreen()));
            },
          ),
          ListTile(
            iconColor: Colors.red,
            textColor: Colors.red,
            leading: const Icon(Icons.logout),
            title: Text('logout'.tr),
            onTap: () async {
              try {
                await AuthService().signOut();
                Get.offAll(() => LoginScreen());
              } catch (e) {
                Get.snackbar('Error', 'Failed to log out: $e');
              }
            },
          ),
        ],
      ),
    );
  }
}
