import 'package:get/get.dart';
import '../models/agency_offer.dart';
import '../core/services/agency_offer_service.dart';

class AgencyOfferController extends GetxController {
  final offers = <AgencyOffer>[].obs;
  final AgencyOfferService _service = AgencyOfferService();

  Future<void> loadOffers(String agencyId) async {
    offers.value = await _service.fetchOffers(agencyId);
  }

  Future<void> addOffer(AgencyOffer offer) async {
    final newOffer = await _service.addOffer(offer);
    if (newOffer != null) {
      offers.add(newOffer);
    }
  }

  Future<void> deleteOffer(String offerId) async {
    final success = await _service.deleteOffer(offerId);
    if (success) {
      offers.removeWhere((offer) => offer.id == offerId);
      loadOffers(offers.first.agencyId);
    }
  }
}