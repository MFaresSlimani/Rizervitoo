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
    url: 'i removed it',
    anonKey:
        'insert',
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
