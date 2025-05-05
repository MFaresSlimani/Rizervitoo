import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  void login() async {
    setState(() { isLoading = true; });

    try {
      final response = await AuthService().signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      AuthService().fetchUserDetails(response!.id);
      
      Get.offAll(() => const HomeScreen());
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }

    setState(() { isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            
            const SizedBox(height: 12),

            TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
            const SizedBox(height: 20),
            isLoading 
              ? const LoadingIndicator()
              : ElevatedButton(onPressed: login, child: const Text('Login')),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Get.to(() => SignUpScreen());
              },
              child: const Text('Don\'t have an account? Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
