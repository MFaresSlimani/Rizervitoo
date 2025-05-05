import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/guide_controller.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({Key? key}) : super(key: key);

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  final guideController = Get.put(GuideController());

  final List<String> wilayas = [
    'Medea',
    'Algiers',
    'Oran',
    'Bejaia',
    'Tlemcen',
    'Tipaza'
  ];
  final List<String> wilayaImages = [
    'https://i.ytimg.com/vi/G3oms-NxqaI/maxresdefault.jpg',
    'https://liveandletsfly.com/wp-content/uploads/2022/11/24-Hours-Algiers-1.jpeg',
    'https://www.algerie-monde.com/villes/oran/cathedrale-sacre-coeur-oran.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNpEwQmMbj4vZGLma2qO6fpA8NlG1PObJ3JQ&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShT1-_kO-VMsuAKP_bf3bx__tGMsmxkexAEg&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQoTQ6svoaRQIZDuo7hExjjkC_VQbSIA2zF2g&s',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Touristic Guide'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Horizontal list of Wilayas
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: wilayas.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      guideController.selectWilaya(wilayas[index]);
                    },
                    child: Container(
                      width: 150,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: NetworkImage(wilayaImages[index]),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.4),
                            BlendMode.darken,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          wilayas[index],
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
              ),
            ),
          ),

          const SizedBox(height: 16),

          // List of touristic places for the selected Wilaya
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Obx(() {
                  return TouristicSite(
                    guideController: guideController,
                    title: '${guideController.selectedWilaya.value} Touristic Site ${index + 1}',
                    description: 'Description of Touristic Site ${index + 1}',
                    picture:
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT1sC3B1aLZTcX9u5-pXGHxP9FfXOlLcWZgBg&s',
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TouristicSite extends StatelessWidget {
  const TouristicSite({
    super.key,
    required this.guideController,
    required this.picture,
    required this.title,
    required this.description,
  });

  final GuideController guideController;
  final String picture;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            picture,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
