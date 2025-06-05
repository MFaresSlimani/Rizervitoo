import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Rizervitoo/screens/agency/agency_details_screen.dart';

import '../../controllers/agency_controller.dart';
import '../../widgets/agency_card.dart';
import '../../widgets/agency_offer.dart';

class AgenciesScreen extends StatefulWidget {
  const AgenciesScreen({super.key});

  @override
  State<AgenciesScreen> createState() => _AgenciesScreenState();
}

class _AgenciesScreenState extends State<AgenciesScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<AgencyController>().loadAgencies();
  }

  @override
  Widget build(BuildContext context) {
    final agencyController = Get.find<AgencyController>();
    return Obx(() {
      final agencies = agencyController.agencies;
      return Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            // Simulate a refresh action
            await Future.delayed(const Duration(seconds: 2));
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: PageView.builder(
                      itemCount: 3,
                      controller: PageController(viewportFraction: 0.9),
                      itemBuilder: (context, index) {
                        final images = [
                          'assets/offer1.jpg',
                          'assets/offer2.png',
                          'assets/offer3.jpg',
                        ];
                        return AgencyOffer(
                          agencyImage: images[index],
                          agencyName: 'Luxury Travel Package',
                        );
                      },
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final agency = agencies[index];
                    return AgencyCard(
                      name: agency.name,
                      location: agency.location,
                      description: agency.description,
                      imageUrl: agency.imageUrl,
                      onTap: () => Get.to(AgencyDetailsScreen(agency: agency)),
                    );
                  },
                  childCount: agencies.length,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

