import 'dart:io';
import 'package:Rizervitoo/core/services/property_service.dart';
import 'package:Rizervitoo/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class UserService {
  final _client = Supabase.instance.client;

  Future<UserModel?> getCurrentUser() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    final response =
        await _client.from('users').select().eq('id', user.id).single();
    return UserModel.fromJson(response);
  }

  Future<void> createNotificationForUser({
  required String userId,
  required String title,
  required String body,
}) async {
  await UserService().addNotificationToUser(
    userId: userId,
    title: title,
    body: body,
  );
}
  

  Future<UserModel?> getUserById(String userId) async {
    final response =
        await _client.from('users').select().eq('id', userId).single();

    final data = response;

    PropertyService().fetchCurrentUserProperties();
    return UserModel.fromJson(data);
  }

  Future<String> uploadProfileImage(String fileName, File image) async {
    final oldImage = await _client.storage.from('avatars').list();
    if (oldImage != null && oldImage.isNotEmpty) {
      print('oldImage: $oldImage');
    }
    if (oldImage.isNotEmpty) {
      for (var file in oldImage) {
        await _client.storage.from('avatars').remove(['public/${file.name}']);
      }
    }
    await _client.storage.from('avatars').upload(
          'public/$fileName',
          image,
          fileOptions: FileOptions(
            cacheControl: '3600',
            upsert: true,
          ),
        );

    final url =
        _client.storage.from('avatars').getPublicUrl('public/$fileName');
    return url;
  }

  Future<void> updateUserProfile(UserModel user) async {
    await _client.from('users').update(user.toJson()).eq('id', user.id);
  }

  // update isBusinessOwner
  Future<void> updateIsBusinessOwner(
      String userId, bool isBusinessOwner) async {
    await _client
        .from('users')
        .update({'isBusinessOwner': isBusinessOwner}).eq('id', userId);
  }

  // add or remove saved property
  Future<void> updateSavedProperties(String propertyId, bool isSaved) async {
    final userId = _client.auth.currentUser!.id;
    // Fetch current saved_properties
    final response = await _client
        .from('users')
        .select('savedProperties')
        .eq('id', userId)
        .single();

    List<dynamic> savedProperties = [];
    if (response['savedProperties'] != null && response['savedProperties'] is List) {
      savedProperties = List<String>.from(response['savedProperties']);
    }

    if (isSaved) {
      // Remove propertyId if it exists
      savedProperties.remove(propertyId);
    } else {
      // Add propertyId if it doesn't exist
      if (!savedProperties.contains(propertyId)) {
        savedProperties.add(propertyId);
      }
    }

    await _client
        .from('users')
        .update({'savedProperties': savedProperties})
        .eq('id', userId);
  }

  // Add a notification to a user
  Future<void> addNotificationToUser({
    required String userId,
    required String title,
    required String body,
  }) async {
    final uuid = const Uuid();
    final notification = {
      'id': uuid.v4(),
      'title': title,
      'body': body,
      'createdAt': DateTime.now().toIso8601String(),
      'read': false,
    };

    // Fetch current notifications
    final response = await _client
        .from('users')
        .select('notifications')
        .eq('id', userId)
        .single();

    List<dynamic> notifications = [];
    if (response['notifications'] != null && response['notifications'] is List) {
      notifications = List<Map<String, dynamic>>.from(response['notifications']);
    }
    notifications.insert(0, notification); // newest first

    await _client
        .from('users')
        .update({'notifications': notifications})
        .eq('id', userId);
  }

  // Mark notification as read
  Future<void> markNotificationAsRead(String userId, String notificationId) async {
    final response = await _client
        .from('users')
        .select('notifications')
        .eq('id', userId)
        .single();

    List<dynamic> notifications = [];
    if (response['notifications'] != null && response['notifications'] is List) {
      notifications = List<Map<String, dynamic>>.from(response['notifications']);
    }
    for (var n in notifications) {
      if (n['id'] == notificationId) n['read'] = true;
    }

    await _client
        .from('users')
        .update({'notifications': notifications})
        .eq('id', userId);
  }
}
