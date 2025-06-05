import 'package:get/get.dart';
import '../models/agency_model.dart';
import '../core/services/agency_service.dart';
import 'user_controller.dart';

class AgencyController extends GetxController {
  final agencies = <AgencyModel>[].obs;
  final AgencyService _service = AgencyService();

  Future<void> loadAgencies() async {
    agencies.value = await _service.fetchAgencies();
  }

  // delete method as needed
  Future<void> deleteAgency(String agencyId) async {
    await _service.deleteAgency(agencyId);
    agencies.removeWhere((agency) => agency.id == agencyId);
  }

}