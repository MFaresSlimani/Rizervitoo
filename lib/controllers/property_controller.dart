import 'package:get/get.dart';
import '../models/property_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PropertyController extends GetxController {
  var properties = <PropertyModel>[].obs;

  final supabase = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    fetchProperties();
  }

  Future<void> createProperty({
  required String title,
  required String imageUrl,
  required double price,
  required String wilaya,
  required String description,
  double? distanceToLandmark,
}) async {
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) {
    Get.snackbar('Error', 'You must be logged in.');
    return;
  }

  await supabase.from('properties').insert({
    'title': title,
    'image_url': imageUrl,
    'price': price,
    'wilaya': wilaya,
    'description': description,
    'owner_id': user.id,
    'distance_to_landmark': distanceToLandmark,
  });

  fetchProperties(); // Refresh after adding
}


  Future<void> fetchProperties() async {
    final response = await supabase.from('properties').select('*');

    properties.value = await Future.wait((response as List).map((prop) async => await PropertyModel.fromMap(prop)));
  }
}
