import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/property_controller.dart';
import '../models/property_model.dart';
import '../screens/properties/property_details.dart';

class PropertyCard extends StatelessWidget {
  const PropertyCard({
    super.key,
    required this.property,
  });

  final PropertyModel property;

  @override
  Widget build(BuildContext context) {
    final PropertyController propertyController =
        Get.find<PropertyController>();
    propertyController.savedProperties.any((p) => p.id == property.id);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Get.to(
            () => PropertyDetailScreen(property: property),
            transition: Transition.downToUp,
            duration: const Duration(milliseconds: 300),
          );
        },
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: property.imageUrls.isNotEmpty ?
                  Image.network(
                    property.imageUrls[0],
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.broken_image),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ) : Image.asset('assets/logo_black.png'),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${property.price.toStringAsFixed(2)} ${'dzd_night'.tr}',
                        style: TextStyle(color: Colors.green.shade700),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            property.wilaya,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      if (property.distanceToLandmark != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.place,
                                size: 16, color: Colors.blueGrey),
                            const SizedBox(width: 4),
                            Text(
                              '${property.distanceToLandmark!.toStringAsFixed(1)} ${'km_from'.tr} ${property.landmark}',
                              style: const TextStyle(color: Colors.blueGrey),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            // Heart button overlay
            Positioned(
              top: 12,
              right: 12,
              child: Obx(() {
                final isSaved = propertyController.savedProperties
                    .any((p) => p.id == property.id);
                return GestureDetector(
                  onTap: () {
                    if (isSaved) {
                      propertyController.removeSavedProperty(property);
                    } else {
                      propertyController.addSavedProperty(property);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      isSaved ? Icons.favorite : Icons.favorite_border,
                      color: isSaved ? Colors.red : Colors.white,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
