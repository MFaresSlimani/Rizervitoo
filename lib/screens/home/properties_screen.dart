import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:siyahati/models/property_model.dart';
import 'package:siyahati/screens/property_details/property_details.dart';

import '../../controllers/property_controller.dart';

class PropertiesScreen extends StatelessWidget {
  PropertiesScreen({super.key});
  final propertyController = Get.put(PropertyController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
        if (propertyController.properties.isEmpty) {
          return const Center(child: Text('No properties available'));
        }
        return ListView.builder(
          itemCount: propertyController.properties.length,
          itemBuilder: (context, index) {
            final property = propertyController.properties[index];
            return PropertyCard(property: property);
          },
        );
      }
    );
  }
}

class PropertyCard extends StatelessWidget {
  const PropertyCard({
    super.key,
    required this.property,
  });

  final PropertyModel property;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Get.to(
            () => PropertyDetailScreen(property: property),
            transition: Transition.downToUp, // You can choose other transitions like Transition.zoom, Transition.cupertino, etc.
            duration: const Duration(milliseconds: 300),
          );
          Get.to(() => PropertyDetailScreen(property: property));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                property.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${property.price.toStringAsFixed(2)} € / night',
                    style: TextStyle(color: Colors.green.shade700),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
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
                        const Icon(Icons.place, size: 16, color: Colors.blueGrey),
                        const SizedBox(width: 4),
                        Text(
                          '${property.distanceToLandmark!.toStringAsFixed(1)} km from landmark',
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
      ),
    );
  }
}