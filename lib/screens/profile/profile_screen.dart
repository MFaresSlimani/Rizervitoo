import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../controllers/user_controller.dart';
import '../../controllers/property_controller.dart';
import '../../core/services/property_service.dart';
import '../../core/services/user_service.dart';
import '../agency/add_agency_screen.dart';
import '../properties/add_property_screen.dart';
import 'edit_profile_screen.dart';
import '../../controllers/agency_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final RxList<String> currentUserPropertiesIds = <String>[].obs;

  @override
  void initState() {
    super.initState();
    fetchCurrentUserProperties();
  }

  Future<void> fetchCurrentUserProperties() async {
    final user = Get.find<UserController>().user.value;
    if (user != null) {
      currentUserPropertiesIds.value =
          await PropertyService().fetchUserProperties(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final propertyController = Get.find<PropertyController>();
    final agencyController = Get.find<AgencyController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
            Get.locale?.languageCode == 'ar'
              ? LucideIcons.arrowRight
              : LucideIcons.arrowLeft,
            color: theme.iconTheme.color,
            ),
          onPressed: () => Get.back(),
          tooltip: 'back'.tr,
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'profile'.tr,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(LucideIcons.edit, color: theme.iconTheme.color),
            onPressed: () => Get.to(() => EditProfileScreen()),
            tooltip: 'edit_profile'.tr,
          ),
        ],
      ),
      body: Obx(() {
        final user = userController.user.value;
        if (user == null) {
          return Center(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[700]!,
              highlightColor: Colors.grey[500]!,
              child: CircleAvatar(radius: 60, backgroundColor: Colors.white),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            userController.clearUser();
            var temp = await UserService().getCurrentUser();
            userController.setUser(temp!);
          },
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            children: [
              // Profile Info
              Padding(
                padding: const EdgeInsets.only(top: 32, bottom: 12),
                child: Column(
                  children: [
                    user.imageUrl != null && user.imageUrl!.isNotEmpty
                        ? CircleAvatar(
                            radius: 44,
                            backgroundImage: NetworkImage(user.imageUrl!),
                          )
                        : CircleAvatar(
                            radius: 44,
                            backgroundColor:
                                isDark ? Colors.grey[800] : Colors.grey[300],
                            child: Icon(Icons.person,
                                size: 44,
                                color:
                                    isDark ? Colors.white54 : Colors.black26),
                          ),
                    const SizedBox(height: 16),
                    Text(
                      user.name,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.titleLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.phoneNumber ?? 'no_phone'.tr,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Divider(),
              // Properties Section
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                child: Row(
                  children: [
                    Icon(LucideIcons.home, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      'your_properties'.tr,
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.titleMedium?.color,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Obx(() {
                  final properties = propertyController.currentUserProperties;
                  if (properties.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          Icon(LucideIcons.home,
                              size: 32, color: theme.disabledColor),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'no_properties_yet'.tr,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: theme.textTheme.bodyMedium?.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: properties.length,
                    separatorBuilder: (_, __) => Divider(),
                    itemBuilder: (context, i) {
                      final property = properties[i];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: property.imageUrls.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  property.imageUrls.first,
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(LucideIcons.home,
                                size: 36, color: theme.disabledColor),
                        title: Text(property.title,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: theme.textTheme.titleMedium?.color)),
                        subtitle: Text(property.wilaya,
                            style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: theme.textTheme.bodySmall?.color)),
                      );
                    },
                  );
                }),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton.icon(
                  onPressed: () => Get.to(() => AddPropertyScreen()),
                  icon: const Icon(LucideIcons.plus, size: 18),
                  label: Text('add_property'.tr),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    minimumSize: const Size(10, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              Divider(),
              // Agencies Section
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                child: Row(
                  children: [
                    Icon(LucideIcons.building2, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      'your_agencies'.tr,
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.titleMedium?.color,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Obx(() {
                  final userId = userController.user.value?.id;
                  final userAgencies = agencyController.agencies
                      .where((agency) => agency.ownerId == userId)
                      .toList();

                  if (userAgencies.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          Icon(LucideIcons.building2,
                              size: 32, color: theme.disabledColor),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'no_agencies_yet'.tr,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: theme.textTheme.bodyMedium?.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: userAgencies.length,
                    separatorBuilder: (_, __) => Divider(),
                    itemBuilder: (context, i) {
                      final agency = userAgencies[i];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: agency.imageUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  agency.imageUrl,
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(LucideIcons.building2,
                                size: 36, color: theme.disabledColor),
                        title: Text(agency.name,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: theme.textTheme.titleMedium?.color)),
                        subtitle: Text(agency.location,
                            style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: theme.textTheme.bodySmall?.color)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: 'delete_agency'.tr,
                          onPressed: () async {
                            // ...your delete logic...
                          },
                        ),
                      );
                    },
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton.icon(
                  onPressed: () => Get.to(() => AddAgencyScreen()),
                  icon: const Icon(LucideIcons.plus, size: 18),
                  label: Text('add_agency'.tr),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    minimumSize: const Size(10, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }
}
