import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Rizervitoo/core/services/user_service.dart';
import 'package:Rizervitoo/core/services/property_service.dart';
import 'package:Rizervitoo/widgets/property_actions_bar.dart';
import '../../models/property_model.dart';
import '../../models/user_model.dart';
import 'image_gallery_viewer.dart';

class PropertyDetailScreen extends StatefulWidget {
  final PropertyModel property;

  const PropertyDetailScreen({super.key, required this.property});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  late PropertyModel property;

  @override
  void initState() {
    super.initState();
    property = widget.property;
  }

  Future<UserModel?> fetchOwner() async {
    try {
      return await UserService().getUserById(property.ownerId);
    } catch (e) {
      debugPrint('Failed to fetch owner: $e');
      return null;
    }
  }

  Future<void> _refresh() async {
    try {
      final updated = await PropertyService().fetchPropertyById(property.id);
      if (updated != null && mounted) {
        setState(() {
          property = updated;
        });
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar('Error', 'Failed to refresh property',
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  void _onDeleteSuccess() {
    if (mounted) {
      Get.back();
      Get.snackbar(
        'success'.tr,
        'property_deleted_successfully'.tr,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.grey[300] : Colors.grey[700];

    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.33;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: imageHeight,
                  width: double.infinity,
                  child: property.imageUrls.isNotEmpty &&
                          property.imageUrls.any((url) => url.isNotEmpty)
                      ? GestureDetector(
                          onTap: () {
                            Get.to(() => ImageGalleryViewer(
                                  imageUrls: property.imageUrls
                                      .where((url) => url.isNotEmpty)
                                      .toList(),
                                ));
                          },
                          child: PageView.builder(
                            itemCount: property.imageUrls
                                .where((url) => url.isNotEmpty)
                                .length,
                            itemBuilder: (context, index) {
                              final validUrls = property.imageUrls
                                  .where((url) => url.isNotEmpty)
                                  .toList();
                              return Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    validUrls[index],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: imageHeight,
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[400]!,
                                        highlightColor: Colors.grey[200]!,
                                        child: Container(
                                          color: Colors.grey[300],
                                          width: double.infinity,
                                          height: imageHeight,
                                        ),
                                      );
                                    },
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      color: Colors.grey[300],
                                      child: const Icon(LucideIcons.imageOff,
                                          size: 60),
                                    ),
                                  ),
                                  // Gradient overlay for readability
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    height: 50,
                                    child: IgnorePointer(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Colors.black.withOpacity(0.35),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      : Container(
                          height: imageHeight,
                          color: Colors.grey[300],
                          child: const Icon(LucideIcons.image, size: 60),
                        ),
                ),
                // Positioned back button
                Positioned(
                  top: MediaQuery.of(context).padding.top + 12,
                  left: 12,
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                  ),
                ),
              ],
            ),
            // Info Section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    property.title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Divider(),
                  const SizedBox(height: 8),
                  // Price
                  Row(
                    children: [
                      const Icon(LucideIcons.dollarSign, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '${property.price} ${'dzd_night'.tr}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Wilaya
                  Row(
                    children: [
                      const Icon(LucideIcons.mapPin, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        property.wilaya,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  if (property.distanceToLandmark != null) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(LucideIcons.milestone, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          '${property.distanceToLandmark} ${'km_to'.tr} ${property.landmark}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: subTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  Divider(),
                  const SizedBox(height: 8),
                  // Owner Section
                  FutureBuilder<UserModel?>(
                    future: fetchOwner(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Row(
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey[400]!,
                              highlightColor: Colors.grey[200]!,
                              child: const CircleAvatar(radius: 18),
                            ),
                            const SizedBox(width: 12),
                            Shimmer.fromColors(
                              baseColor: Colors.grey[400]!,
                              highlightColor: Colors.grey[200]!,
                              child: Container(
                                width: 60,
                                height: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        );
                      }
                      if (!snapshot.hasData || snapshot.data == null) {
                        return Row(
                          children: [
                            const CircleAvatar(
                              radius: 18,
                              backgroundImage: AssetImage('assets/avatar.png'),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Unknown',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'owner'.tr,
                                  style: GoogleFonts.poppins(
                                    color: subTextColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                      final owner = snapshot.data!;
                      return Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundImage: owner.imageUrl != null &&
                                    owner.imageUrl!.isNotEmpty
                                ? NetworkImage(owner.imageUrl!)
                                : const AssetImage('assets/avatar.png')
                                    as ImageProvider,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                owner.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'owner'.tr,
                                style: GoogleFonts.poppins(
                                  color: subTextColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Divider(),
                  const SizedBox(height: 8),
                  // Description Section
                  Row(
                    children: [
                      const Icon(LucideIcons.alignLeft, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'description'.tr,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    property.description,
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      color: subTextColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: PropertyActionsBar(
        widget: widget,
        onDeleteSuccess: _onDeleteSuccess,
      ),
    );
  }
}
