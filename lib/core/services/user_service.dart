import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:siyahati/models/user_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final _client = Supabase.instance.client;

  Future<UserProfile?> getUserById(String userId) async {
    final response = await _client
        .from('users')
        .select()
        .eq('id', userId)
        .single();

    

    final data = response;
    return UserProfile.fromJson(data);
  }

  Future<String> uploadProfileImage(String fileName, File image) async {
  final response = await _client.storage
      .from('avatars').upload(
        'public/$fileName',
        image,
        fileOptions: FileOptions(
          cacheControl: '3600',
          upsert: true,
        ),
      );

  final url = _client.storage.from('avatars').getPublicUrl('public/$fileName');
  print('Image uploaded: $url');
  return url;
}


  Future<void> updateUserProfile(UserProfile user) async {
    final response = await _client
        .from('users')
        .update(user.toJson())
        .eq('id', user.id);

    print(response);
  }
}
