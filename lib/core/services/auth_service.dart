import 'package:get/get.dart';
import 'package:siyahati/controllers/user_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/user_profile.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  Future<UserProfile?> signUp(
      String email, String password, String name) async {
    final response =
        await supabase.auth.signUp(email: email, password: password);
    final user = response.user;

    if (user == null) {
      throw Exception('User signup failed. No user object returned.');
    }

    await supabase.from('users').insert({
      'id': user.id,
      'name': name,
      'email': email,
      'phone_number': null,
      'image_url': null,
      'isBusinessOwner': false, // Default to false, can change after
    });

    final data =
        await supabase.from('users').select().eq('id', user.id).single();

    return UserProfile.fromJson(data);
  }

  Future<UserProfile?> signIn(String email, String password) async {
    final response = await supabase.auth
        .signInWithPassword(email: email, password: password);

    if (response.user != null) {
      final userId = response.user!.id;
      final data =
          await supabase.from('users').select().eq('id', userId).single();

      return UserProfile.fromJson(data);
    } else {
      throw Exception('Login failed');
    }
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  fetchUserDetails(String id) async {
    final data = await supabase.from('users').select().eq('id', id).single();
    if (data.isEmpty) {
      throw Exception('Failed to fetch user data: No data returned.');
    }

    // Use the updated UserModel to handle null values
    final userModel = UserProfile.fromJson(data);
    final currentUserController = Get.find<UserController>();
    currentUserController.setUser(userModel);
    return userModel;
  }
}
