import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/property_controller.dart';
import '../../core/services/property_service.dart';
import '../../widgets/property_card.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({super.key});

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  final PropertyController propertyController = Get.find<PropertyController>();
  final PropertyService propertyService = PropertyService();

  @override
  void initState() {
    super.initState();
  }
  


  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final props = propertyController.savedProperties;
      if (props.isEmpty) {
        return Center(child: Text('no_properties'.tr));
      }
      return ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        itemCount: props.length,
        itemBuilder: (context, index) {
          final property = props[index];
          return PropertyCard(property: property);
        },
      );
    });
  }
}
