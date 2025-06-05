import 'package:Rizervitoo/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Rizervitoo/models/agency_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/agency_controller.dart';
import '../../controllers/agency_offer_controller.dart';
import '../../widgets/agency_offer_list.dart';
import '../../widgets/add_offer_form.dart';
import '../../models/agency_offer.dart';

class AgencyDetailsScreen extends StatefulWidget {
  final AgencyModel agency;
  const AgencyDetailsScreen({super.key, required this.agency});

  @override
  State<AgencyDetailsScreen> createState() => _AgencyDetailsScreenState();
}

class _AgencyDetailsScreenState extends State<AgencyDetailsScreen> {
  late AgencyModel agency;
  final agencyController = Get.find<AgencyController>();
  final AgencyOfferController offerController =
      Get.put(AgencyOfferController());

  @override
  void initState() {
    super.initState();
    agency = widget.agency;
    offerController.loadOffers(agency.id);
  }

  Future<void> _refresh() async {
    await agencyController.loadAgencies();
    final updated =
        agencyController.agencies.firstWhereOrNull((a) => a.id == agency.id);
    if (updated != null) {
      setState(() => agency = updated);
    }
    await offerController.loadOffers(agency.id);
  }

  void _callAgency() async {
    final uri = Uri.parse('tel:${agency.phoneNumber}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar('error'.tr, 'could_not_launch_dialer'.tr,
          backgroundColor: Colors.red.shade100, colorText: Colors.black);
    }
  }

  void _openAddOfferScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddAgencyOfferScreen(
          agencyId: agency.id,
          onOfferAdded: (offer) async {
            await offerController.addOffer(offer);
            await offerController.loadOffers(agency.id);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOwner = agency.ownerId == Get.find<UserController>().user.value?.id;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('agency_details'.tr,
            style: const TextStyle(color: Colors.white)),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top image header
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 260,
                    child: agency.imageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(32),
                              bottomRight: Radius.circular(32),
                            ),
                            child: Image.network(
                              agency.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 260,
                              loadingBuilder: (context, child, progress) =>
                                  progress == null
                                      ? child
                                      : Container(
                                          color: Colors.grey[200],
                                          child: const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        ),
                              errorBuilder: (context, _, __) => Container(
                                color: Colors.grey[200],
                                child: const Icon(Icons.business,
                                    size: 80, color: Colors.grey),
                              ),
                            ),
                          )
                        : Container(
                            height: 260,
                            color: Colors.grey[200],
                            child: const Icon(Icons.business,
                                size: 80, color: Colors.grey),
                          ),
                  ),
                  // Gradient overlay for text readability
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 90,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(32),
                          bottomRight: Radius.circular(32),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Agency Name
                  Positioned(
                    left: 24,
                    bottom: 24,
                    child: Text(
                      agency.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          const Shadow(
                            color: Colors.black54,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Info Card
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 30, 24, 0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Location
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 22),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                agency.location,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        // About
                        Text(
                          'about_agency'.tr,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          agency.description.isNotEmpty
                              ? agency.description
                              : 'no_description'.tr,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.9),
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 18),
                        // Contact
                        Row(
                          children: [
                            const Icon(Icons.phone,
                                color: Colors.green, size: 22),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                agency.phoneNumber,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Offers Section
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('offers'.tr,
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    if (isOwner)
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton.icon(
                          onPressed: _openAddOfferScreen,
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          label: Text('add_offer'.tr),
                        ),
                      ),
                    AgencyOfferList(
                        offers: offerController.offers, isOwner: isOwner),
                  ],
                ),
              ),
              // Legal Section
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(height: 32),
                    Text(
                      'legal'.tr,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'legal_text'.tr,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: ElevatedButton.icon(
            onPressed: _callAgency,
            icon: const Icon(Icons.call, size: 22, color: Colors.white),
            label: Text('call_agency'.tr),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              textStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

// New screen for adding an offer
class AddAgencyOfferScreen extends StatelessWidget {
  final String agencyId;
  final Future<void> Function(AgencyOffer) onOfferAdded;
  const AddAgencyOfferScreen(
      {super.key, required this.agencyId, required this.onOfferAdded});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add_offer'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AddAgencyOfferForm(
          agencyId: agencyId,
          onOfferAdded: (offer) async {
            await onOfferAdded(offer);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
