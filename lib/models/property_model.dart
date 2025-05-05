import 'package:siyahati/core/services/user_service.dart';
import 'package:siyahati/models/user_profile.dart';

class PropertyModel {
  final String id;
  final String title;
  final String imageUrl;
  final double price;
  final String wilaya;
  final String description;
  final UserProfile owner;
  final double? distanceToLandmark; // optional

  PropertyModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.wilaya,
    required this.description,
    required this.owner,
    this.distanceToLandmark,
  });

  // For reading from Supabase
  static Future<PropertyModel> fromMap(Map<String, dynamic> map) async {
    final owner = await UserService().getUserById(map['owner_id']);
    if (owner == null) {
      throw Exception('Owner not found for id: ${map['owner_id']}');
    }
    return PropertyModel(
      id: map['id'],
      title: map['title'],
      imageUrl: map['image_url'],
      price: (map['price'] as num).toDouble(),
      wilaya: map['wilaya'],
      description: map['description'],
      owner: owner,
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
      'image_url': imageUrl,
      'price': price,
      'wilaya': wilaya,
      'description': description,
      'owner_id': owner.id,
      'distance_to_landmark': distanceToLandmark,
    };
  }
}
