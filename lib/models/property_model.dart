import 'package:Rizervitoo/core/services/user_service.dart';
import 'package:Rizervitoo/models/user_model.dart';

class PropertyModel {
  final String id;
  final String title;
  final List<String> imageUrls; // Changed from String imageUrl
  final double price;
  final String wilaya;
  final String description;
  final String ownerId;
  final String landmark;
  final double? distanceToLandmark;
  final String type;

  PropertyModel({
    required this.id,
    required this.title,
    required this.imageUrls,
    required this.price,
    required this.wilaya,
    required this.description,
    required this.ownerId,
    required this.landmark,
    required this.type,
    this.distanceToLandmark,
  });

  // For reading from Supabase
  static Future<PropertyModel> fromMap(Map<String, dynamic> map) async {
    return PropertyModel(
      id: map['id'],
      title: map['title'],
      imageUrls: (map['image_urls'] as List<dynamic>?)?.cast<String>() ?? [], // Changed
      price: (map['price'] as num).toDouble(),
      wilaya: map['wilaya'],
      description: map['description'],
      ownerId: map['owner_id'],
      landmark: map['landmark'],
      type: map['type'],
      distanceToLandmark: map['distance_to_landmark'] != null
          ? (map['distance_to_landmark'] as num).toDouble()
          : null,
    );
  }

  // For inserting to Supabase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image_urls': imageUrls, // Changed
      'price': price,
      'wilaya': wilaya,
      'description': description,
      'owner_id': ownerId,
      'landmark': landmark,
      'type': type,
      'distance_to_landmark': distanceToLandmark,
    };
  }
}
