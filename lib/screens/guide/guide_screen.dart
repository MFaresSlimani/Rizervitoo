import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/guide_controller.dart';
import '../../models/guide_place.dart';
import 'place_details.dart';

class GuideScreen extends StatelessWidget {
  GuideScreen({super.key});

  final guideController = Get.put(GuideController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('travel_guide'.tr),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Horizontal list of Wilayas
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 80,
              child: Obx(() {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: guideController.wilayas.length,
                  itemBuilder: (context, index) {
                    final wilaya = guideController.wilayas[index];
                    final image = wilaya.places.isNotEmpty
                        ? wilaya.places[0].imageUrl
                        : 'https://via.placeholder.com/150';

                    return GestureDetector(
                      onTap: () {
                        guideController.selectWilaya(wilaya.wilaya);
                      },
                      child: Container(
                        width: 150,
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: NetworkImage(image),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.4),
                              BlendMode.darken,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            wilaya.wilaya,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),

          const SizedBox(height: 16),

          // List of touristic places for the selected Wilaya
          Expanded(
            child: Obx(() {
              final selectedWilaya = guideController.selectedWilaya.value;
              final selectedPlaces = selectedWilaya == null
                  ? []
                  : guideController.wilayas
                      .firstWhere(
                        (wilaya) => wilaya.wilaya == selectedWilaya,
                        orElse: () => GuideWilaya(wilaya: '', places: []),
                      )
                      .places;

              return ListView.builder(
                itemCount: selectedPlaces.length,
                itemBuilder: (context, index) {
                  final place = selectedPlaces[index];
                  return TouristicSite(
                    picture: place.imageUrl,
                    title: place.name,
                    description: place.description,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class TouristicSite extends StatelessWidget {
  const TouristicSite({
    super.key,
    required this.picture,
    required this.title,
    required this.description,
  });

  final String picture;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListTile(
          onTap: () {
            Get.to(
              PlaceDetails(
                imageUrl: picture,
                title: title,
                description: description,
              ),
              transition: Transition.rightToLeft,
            );
          },
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              picture,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.broken_image,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
          title: Text(
            title.length > 20 ? '${title.substring(0, 20)}...' : title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            description.length > 50
                ? '${description.substring(0, 50)}...'
                : description,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ),
    );
  }
}
