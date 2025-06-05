import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/agency_model.dart';

class AgencyService {
  final _client = Supabase.instance.client;

  Future<List<AgencyModel>> fetchAgencies() async {
    final response = await _client.from('agencies').select();
    return (response as List)
        .map((json) => AgencyModel.fromJson(json))
        .toList();
  }
  Future<AgencyModel?> fetchAgencyById(String agencyId) async {
    final response = await _client.from('agencies').select().eq('id', agencyId).single();
    return AgencyModel.fromJson(response);
  }
  
  Future<AgencyModel> addAgency({
    required String ownerId,
    required String name,
    required String location,
    required String description,
    required String imageUrl,
    required String phoneNumber,
  }) async {
    final response = await _client.from('agencies').insert({
      'owner_id': ownerId,
      'name': name,
      'location': location,
      'description': description,
      'image_url': imageUrl,
      'phone_number': phoneNumber,
    }).select().single();

    return AgencyModel.fromJson(response);
  }

  // delete method as needed
  Future<void> deleteAgency(String agencyId) async {
    final response = await _client.from('agencies').delete().eq('id', agencyId);
    // delete picture from storage if needed
    await _client.storage.from('agencies').remove([agencyId]);
    if (response.error != null) {
      throw Exception('Failed to delete agency: ${response.error!.message}');
    }
    
  }

}