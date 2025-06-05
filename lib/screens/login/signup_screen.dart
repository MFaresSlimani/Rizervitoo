import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Rizervitoo/core/services/user_service.dart';
import '../../controllers/user_controller.dart';
import '../../core/services/auth_service.dart';
import '../home/home_screen.dart';
import '../../widgets/loading_indicator.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  void signUp() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await AuthService().signUp(
        emailController.text.trim(),
        passwordController.text.trim(),
        nameController.text.trim(),
      );

      UserService().getUserById(response!.id).then((user) {
        if (user != null) {
          Get.find<UserController>().setUser(user);
        }
      });

      // Redirect to Home Screen
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      print('Error: $e');
      Get.snackbar('Error', e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme =
        Theme.of(Get.context!).brightness == Brightness.dark ? true : false;
    final logoPath =
        isDarkTheme ? 'assets/logo_white.png' : 'assets/logo_blue.png';
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                logoPath,
                height: 100,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'name'.tr),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'email'.tr),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'password'.tr),
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const LoadingIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: signUp,
                      child: Text('signup'.tr),
                    ),
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('already_have_account'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
