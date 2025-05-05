import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siyahati/core/services/auth_gate.dart';
import 'package:siyahati/core/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'controllers/user_controller.dart';
import 'themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ouggsvmgkrqyoygehhxj.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91Z2dzdm1na3JxeW95Z2VoaHhqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU3OTA5MjEsImV4cCI6MjA2MTM2NjkyMX0.hHaQEVXlnzqZFOBDVx5woGLfUoqZiC-Tz9PIVg6n4nU',
  );

  Get.put(UserController());
  AuthService()
      .fetchUserDetails(Supabase.instance.client.auth.currentUser?.id ?? '');
  runApp(const SiyahatiApp());
}

class SiyahatiApp extends StatelessWidget {
  const SiyahatiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Siyahati',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialBinding: BindingsBuilder(() {
        Get.put(AuthService());
      }),
      home: const AuthGate(),
    );
  }
}
