import 'package:flutter/material.dart';

import '../../widgets/agency_card.dart';
import '../../widgets/agency_offer.dart';

class AgenciesScreen extends StatelessWidget {
  const AgenciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          // Simulate a refresh action
          await Future.delayed(const Duration(seconds: 2));
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
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
                  agencyName:  'Luxury Travel Package',
                );
                },
              ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return AgencyCard(
                    name: 'Luxury Agency ${index + 1}',
                    location: 'Location ${index + 1}',
                    description:
                        'This is a premium agency offering top-notch services.',
                    imageUrl:
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQIQL-rAUKKK8rQ1uvTFZRarj550tMxJGzJkQ&s', // Replace with actual image URLs
                  );
                },
                childCount: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

