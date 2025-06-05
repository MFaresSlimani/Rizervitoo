import 'package:get/get.dart';
import 'package:Rizervitoo/controllers/user_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/user_model.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  Future<UserModel?> signUp(
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
      'phone_number': '',
      'image_url': '',
      'isBusinessOwner': false,
      'savedProperties': [],
    });

    final data =
        await supabase.from('users').select().eq('id', user.id).single();

    return UserModel.fromJson(data);
  }

  Future<UserModel?> signIn(String email, String password) async {
    final response = await supabase.auth
        .signInWithPassword(email: email, password: password);

    if (response.user != null) {
      final userId = response.user!.id;
      final data =
          await supabase.from('users').select().eq('id', userId).single();

      return UserModel.fromJson(data);
    } else {
      throw Exception('Login failed');
    }
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

}
