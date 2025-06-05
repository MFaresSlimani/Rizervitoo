import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import '../../../controllers/user_controller.dart';
import '../../core/services/user_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final userController = Get.find<UserController>();
  final userService = UserService();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  File? _pickedImage;
  String? _imageUrl;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final user = userController.user.value;
    if (user != null) {
      nameController.text = user.name;
      emailController.text = user.email;
      phoneController.text = user.phoneNumber ?? '';
      _imageUrl = user.imageUrl;
    }
  }

  Future<void> _pickImage() async {
    final picked =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 60);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });

      final fileName =
          '${userController.user.value!.name}_${DateTime.now().millisecondsSinceEpoch}${p.extension(picked.path)}';

      try {
        final res =
            await userService.uploadProfileImage(fileName, _pickedImage!);
        setState(() {
          _imageUrl = res;
        });
      } on Exception catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  Future<void> _saveProfile() async {
    final updated = userController.user.value!.copyWith(
      name: nameController.text,
      email: emailController.text,
      phoneNumber: phoneController.text,
      imageUrl: _imageUrl,
    );

    try {
      await userService.updateUserProfile(updated);
      userController.setUser(updated);
      Get.back();
      Get.snackbar('Success', 'Profile updated');
    } catch (e) {
      Get.snackbar('Error in the save profile fucntion', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = _pickedImage != null
        ? FileImage(_pickedImage!)
        : (_imageUrl != null
            ? NetworkImage(_imageUrl!)
            : const AssetImage('assets/avatar.png'));

    return Scaffold(
      appBar: AppBar(title: Text('edit_profile'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: imageProvider as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: _pickImage,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.deepPurple),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'name'.tr),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'email'.tr),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'phone_number'.tr),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text('save'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
