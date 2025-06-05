import 'dart:io';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../controllers/property_controller.dart';
import '../../models/property_model.dart';

class PropertyService {
  final _client = Supabase.instance.client;
  final PropertyController propertyController = Get.find<PropertyController>();
  final properties = <PropertyModel>[].obs;
  final savedProperties = <PropertyModel>[].obs;

  Future<String?> createProperty({
    required String title,
    required List<String> imageUrls,
    required String owner,
    required double price,
    required String type,
    required String landmark,
    required String wilaya,
    required String description,
    double? distanceToLandmark,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'You must be logged in.');
      return "Please log in to create a property.";
    }

    final response = await _client
        .from('properties')
        .insert({
          'title': title,
          'image_urls': imageUrls,
          'price': price,
          'type': type,
          'landmark': landmark,
          'wilaya': wilaya,
          'description': description,
          'owner_id': owner,
          'distance_to_landmark': distanceToLandmark,
        })
        .select('id')
        .single();

    if (response['id'] != null) {
      final propertyId = response['id'] as String;

      return propertyId;
    }
    return null;
  }

  Future<bool> deleteProperty(String propertyId) async {
    await _client.from('properties').delete().eq('id', propertyId);

    // Remove property from user's propertiesIds array
    return true;
  }

  Future<void> fetchProperties() async {
    final response = await _client.from('properties').select('*');

    properties.value = await Future.wait((response as List)
        .map((prop) async => await PropertyModel.fromMap(prop)));
    propertyController.setProperties(properties);
  }

  // Fetch saved properties
  Future<void> fetchSavedProperties() async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    final response = await _client
        .from('users')
        .select('savedProperties')
        .eq('id', user.id)
        .single();

    final savedPropertyIds =
        (response['savedProperties'] as List<dynamic>?) ?? [];
    print('savedProperties: $savedPropertyIds');

    if (savedPropertyIds.isEmpty) {
      savedProperties.clear();
      propertyController.setSavedProperties(savedProperties);
      return;
    }

    final fetchedSavedProperties =
        await Future.wait(savedPropertyIds.map((propertyId) async {
      final propertyResponse = await _client
          .from('properties')
          .select('*')
          .eq('id', propertyId)
          .single();
      return PropertyModel.fromMap(propertyResponse);
    }));

    savedProperties.value = fetchedSavedProperties;
    propertyController.setSavedProperties(savedProperties);
  }

  // Fetch current user's property (every user has only one property)
  Future<void> fetchCurrentUserProperties() async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    final response =
        await _client.from('properties').select('*').eq('owner_id', user.id);

    final properties = await Future.wait(
      (response as List).map((prop) => PropertyModel.fromMap(prop)),
    );
    propertyController
        .setCurrentUserProperties(properties); // replaces the list
  }

  // Fetch properties by user
  Future<List<String>> fetchUserProperties(String UserId) async {
    final response =
        await _client.from('properties').select('*').eq('owner_id', UserId);

    final properties = await Future.wait(
      (response as List).map((prop) => PropertyModel.fromMap(prop)),
    );
    // return the ids
    final propertyIds = properties.map((p) => p.id).toList();
    return propertyIds;
  }

  Future<List<String>> uploadPropertyImages(
      String propertyId, List<File> images) async {
    print('uploadPropertyImages called with propertyId: $propertyId');
    print('Number of images to upload: ${images.length}');
    final List<String> urls = [];
    final storage = _client.storage.from('properties');

    for (var i = 0; i < images.length; i++) {
      final file = images[i];
      print('Image $i exists: ${file.existsSync()}');
      print('Image $i size: ${file.lengthSync()} bytes');
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
      final path = '$propertyId/$fileName';

      print('Uploading image $i: $file');
      print('Upload path: $path');

      try {
        final uploadResponse = await storage.upload(
          path,
          file,
          fileOptions: const FileOptions(upsert: true, cacheControl: '3600'),
        );
        print('Upload response for image $i: $uploadResponse');

        final url = storage.getPublicUrl(path);
        print('Public URL for image $i: $url');

        urls.add(url);
      } catch (e, stack) {
        print('Failed to upload image $i: $e');
        print('Stacktrace: $stack');
        Get.snackbar('Upload Error', 'Failed to upload image ${i + 1}');
        // Optionally: break or continue
      }
    }
    print('All uploaded image URLs: $urls');
    print('Finished uploading all images');
    return urls;
  }

  Future<void> updateProperty({
    required String propertyId,
    required String title,
    required double price,
    required String type,
    required String landmark,
    required String wilaya,
    required String description,
    required double distanceToLandmark,
  }) async {
    await _client.from('properties').update({
      'title': title,
      'price': price,
      'type': type,
      'landmark': landmark,
      'wilaya': wilaya,
      'description': description,
      'distance_to_landmark': distanceToLandmark,
    }).eq('id', propertyId);
  }

  Future<List<String>> updatePropertyImages(
      String propertyId, List<String> images) async {
    await _client.from('properties').update({
      'image_urls': images,
    }).eq('id', propertyId);
    return images;
  }

  Future<PropertyModel?> fetchPropertyById(String propertyId) async {
    final response = await _client
        .from('properties')
        .select('*')
        .eq('id', propertyId)
        .single();

    return PropertyModel.fromMap(response);
  }

  Future<void> deleteImageFromStorage(String url) async {
    // Parse the path from the public URL
    final uri = Uri.parse(url);
    final segments = uri.pathSegments;
    final idx = segments.indexOf('properties');
    if (idx == -1 || idx + 1 >= segments.length) return;
    final path = segments.sublist(idx, segments.length).join('/');
    await _client.storage.from('properties').remove([path]);
  }
}
