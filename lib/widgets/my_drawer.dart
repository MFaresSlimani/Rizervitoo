import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siyahati/screens/guide_screen.dart';
import 'package:siyahati/screens/profile_screen.dart';

import '../controllers/user_controller.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    return Container(
      width: 200,
      height: double.infinity,
      decoration: BoxDecoration(
        // color is gradient and changes with the theme
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).hintColor,
          ],
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
            decoration: const BoxDecoration(
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: userController.user.value?.imageUrl != null
                      ? NetworkImage(userController.user.value!.imageUrl!)
                      : const AssetImage('assets/avatar.png')
                          as ImageProvider,
                ),
                const SizedBox(height: 10),
                Text(
                  userController.user.value?.name.capitalize ?? 'User Name',
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
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Get.back();
            },
          ),
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Travel Guide'),
            onTap: () {
              Get.to(() => GuideScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Get.to(() => ProfileScreen());
            },
          ),
        ],
      ),
    );
  }
}
