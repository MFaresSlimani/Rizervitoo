import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Rizervitoo/controllers/user_controller.dart';
import 'package:Rizervitoo/core/services/user_service.dart';
import '../../themes/app_theme.dart';
import '../profile/edit_profile_screen.dart';
import 'contact_us.dart';

final box = GetStorage();

void setLocale(Locale locale) {
  Get.updateLocale(locale);
  box.write('locale', locale.languageCode);
}

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  final userController = Get.find<UserController>();
  final UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black87;
    final subTextColor = theme.textTheme.bodyMedium?.color?.withOpacity(0.7) ?? Colors.grey[600];
    final sectionBg = theme.colorScheme.surface.withOpacity(0.9);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'settings'.tr,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          children: [
            // Profile summary
            Obx(() {
              final user = userController.user.value;
              return Container(
                color: sectionBg,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundImage: user?.imageUrl != null && user!.imageUrl!.isNotEmpty
                          ? NetworkImage(user.imageUrl!)
                          : const AssetImage('assets/avatar.png') as ImageProvider,
                    ),
                    const SizedBox(width: 18),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? '',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? '',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: subTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 18),

            // Section: Preferences
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
              child: Text(
                'preferences'.tr,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: subTextColor,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              color: sectionBg,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(LucideIcons.moonStar),
                    title: Text('change_theme'.tr, style: GoogleFonts.poppins()),
                    onTap: () {
                      AppTheme.toggleTheme();
                      Get.changeTheme(AppTheme.currentTheme);
                    },
                  ),
                  const Divider(height: 0, indent: 72),
                  ListTile(
                    leading: const Icon(LucideIcons.languages),
                    title: Text('languages'.tr, style: GoogleFonts.poppins()),
                    onTap: () {
                      Get.bottomSheet(
                        Container(
                          decoration: BoxDecoration(
                            color: sectionBg,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: Text('english'.tr),
                                onTap: () {
                                  setLocale(const Locale('en', 'US'));
                                  Get.back();
                                },
                              ),
                              ListTile(
                                title: Text('french'.tr),
                                onTap: () {
                                  setLocale(const Locale('fr', 'FR'));
                                  Get.back();
                                },
                              ),
                              ListTile(
                                title: Text('arabic'.tr),
                                onTap: () {
                                  setLocale(const Locale('ar', 'DZ'));
                                  Get.back();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Section: Account
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
              child: Text(
                'account'.tr,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: subTextColor,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              color: sectionBg,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(LucideIcons.user),
                    title: Text('edit_profile'.tr, style: GoogleFonts.poppins()),
                    onTap: () => Get.to(() => EditProfileScreen()),
                  ),
                  Obx(() {
                    final isBusinessOwner =
                        userController.user.value?.isBusinessOwner ?? false;
                    return SwitchListTile(
                      secondary: const Icon(LucideIcons.building2),
                      title: Text(
                        isBusinessOwner ? 'you_are_host'.tr : 'become_host'.tr,
                        style: GoogleFonts.poppins(),
                      ),
                      value: isBusinessOwner,
                      onChanged: (value) {
                        Get.dialog(
                          AlertDialog(
                            title: Text(
                              value ? 'become_host'.tr : 'remove_host'.tr,
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                            ),
                            content: Text(
                              value
                                  ? 'become_host_description'.tr
                                  : 'remove_host_description'.tr,
                              style: GoogleFonts.poppins(),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: Text('cancel'.tr),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await userService.updateIsBusinessOwner(
                                    userController.user.value!.id,
                                    value,
                                  );
                                  await userService.updateUserProfile(
                                    userController.user.value!.copyWith(
                                      isBusinessOwner: value,
                                    ),
                                  );
                                  userController.user.value =
                                      userController.user.value!.copyWith(
                                    isBusinessOwner: value,
                                  );
                                  Get.back();
                                  Get.snackbar(
                                    'Success',
                                    value
                                        ? 'You are now a business owner.'
                                        : 'You are no longer a business owner.',
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                },
                                child: Text('confirm'.tr),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),

            // Section: Support
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
              child: Text(
                'support'.tr,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: subTextColor,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              color: sectionBg,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(LucideIcons.mailQuestion),
                    title: Text('contact_us'.tr, style: GoogleFonts.poppins()),
                    onTap: () {
                      Get.to(ContactUsScreen());
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
