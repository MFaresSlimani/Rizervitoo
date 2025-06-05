import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/agency_offer.dart';

class AgencyOfferService {
  final _client = Supabase.instance.client;

  Future<List<AgencyOffer>> fetchOffers(String agencyId) async {
    final response =
        await _client.from('agency_offers').select().eq('agency_id', agencyId);
    return (response as List)
        .map((json) => AgencyOffer.fromJson(json))
        .toList();
  }

  Future<AgencyOffer?> addOffer(AgencyOffer offer) async {
    final response = await _client
        .from('agency_offers')
        .insert(offer.toJson()..remove('id'))
        .select()
        .single();
    return AgencyOffer.fromJson(response);
  }

  // delete an offer by ID
  Future<bool> deleteOffer(String offerId) async {
    final response =
        await _client.from('agency_offers').delete().eq('id', offerId);

    return response.error == null;
  }
}
