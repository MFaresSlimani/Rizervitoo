import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:Rizervitoo/controllers/agency_controller.dart';
import 'package:Rizervitoo/controllers/property_controller.dart';
import 'package:Rizervitoo/core/services/auth_gate.dart';
import 'package:Rizervitoo/core/services/auth_service.dart';
import 'package:Rizervitoo/core/services/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'controllers/user_controller.dart';
import 'core/localization/app_translations.dart';
import 'themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); 
  await Supabase.initialize(
    url: 'https://ouggsvmgkrqyoygehhxj.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91Z2dzdm1na3JxeW95Z2VoaHhqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU3OTA5MjEsImV4cCI6MjA2MTM2NjkyMX0.hHaQEVXlnzqZFOBDVx5woGLfUoqZiC-Tz9PIVg6n4nU',
  );
  final box = GetStorage();
  String? langCode = box.read('locale');
  Locale initialLocale;
  if (langCode == 'fr') {
    initialLocale = const Locale('fr', 'FR');
  } else if (langCode == 'ar') {
    initialLocale = const Locale('ar', 'DZ');
  } else {
    initialLocale = const Locale('en', 'US');
  }

  Get.put(UserController());
  Get.put(PropertyController());
  Get.put(AgencyController());
  UserService().getUserById(Supabase.instance.client.auth.currentUser?.id ?? '').then((user) {
    if (user != null) {
      Get.find<UserController>().setUser(user);
    }
  });
  runApp(RizervitooApp( 
    initialLocale: initialLocale,
  ));
}

class RizervitooApp extends StatelessWidget {
  final Locale initialLocale;
  const RizervitooApp({super.key, required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        color: Colors.blue[900],
        title: 'Rezervitoo',
        translations: AppTranslations(),
        locale: initialLocale,
        fallbackLocale: AppTranslations.fallbackLocale,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: AppTheme.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        initialBinding: BindingsBuilder(() {
          Get.put(AuthService());
        }),
        home: const AuthGate(),
      ),
    );
  }
}
