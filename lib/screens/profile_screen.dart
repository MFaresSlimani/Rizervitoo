import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siyahati/core/services/auth_service.dart';
import '../../controllers/user_controller.dart';
import 'add_property_screen.dart';
import 'edit_profile_screen.dart';
import 'login/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final user = userController.user.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Get.to(() => EditProfileScreen());
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AuthService().signOut();
              // Navigate to login screen
              Get.offAll(() => LoginScreen()); // replace if needed
            },
          ),
        ],
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: user.imageUrl != null
                        ? NetworkImage(user.imageUrl!)
                        : const AssetImage('assets/avatar.png') as ImageProvider,
                  ),
                  const SizedBox(height: 16),

                  // Name
                  Text(
                    user.name ?? 'No Name',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  // Email
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.email, size: 18),
                      const SizedBox(width: 6),
                      Text(user.email ?? 'No Email'),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Phone
                  
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.phone, size: 18),
                        const SizedBox(width: 6),
                        Text(user.phoneNumber ?? 'No Phone'),
                      ],
                    ),

                  const SizedBox(height: 24),

                  // Add Property Button
                  ElevatedButton.icon(
                    onPressed: () => Get.to(() => AddPropertyScreen()),
                    icon: const Icon(Icons.add_business, color: Colors.white,),
                    label: const Text('Add Property'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
