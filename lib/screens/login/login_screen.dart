import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Rizervitoo/core/services/user_service.dart';
import '../../controllers/user_controller.dart';
import '../../core/services/auth_service.dart';
import '../home/home_screen.dart';
import '../../widgets/loading_indicator.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool _obscurePassword = true;

  void login() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await AuthService().signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      UserService().getUserById(response!.id).then((user) {
        if (user != null) {
          Get.find<UserController>().setUser(user);
        }
      });

      Get.offAll(() => const HomeScreen());
    } catch (e) {
      Get.snackbar('error'.tr, e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final logoPath =
        isDarkTheme ? 'assets/logo_white.png' : 'assets/logo_blue.png';

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                logoPath,
                height: 100,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 40),

              // Email TextField
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'email'.tr,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Password TextField with eye icon
              TextField(
                controller: passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Login Button or Loading Indicator
              isLoading
                  ? const LoadingIndicator()
                  : ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text('login'.tr),
                    ),
              const SizedBox(height: 16),

              // Sign Up Button
              TextButton(
                onPressed: () {
                  Get.to(() => SignUpScreen());
                },
                child: Text('dont_have_account'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
