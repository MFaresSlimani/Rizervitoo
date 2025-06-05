class GuidePlace {
  final String name;
  final String imageUrl;
  final String description;

  GuidePlace({required this.name, required this.imageUrl, required this.description});

  factory GuidePlace.fromJson(Map<String, dynamic> json) {
    return GuidePlace(
      name: json['name'],
      imageUrl: json['imageUrl'],
      description: json['description'],
    );
  }
}

class GuideWilaya {
  final String wilaya;
  final List<GuidePlace> places;

  GuideWilaya({required this.wilaya, required this.places});

  factory GuideWilaya.fromJson(Map<String, dynamic> json) {
    return GuideWilaya(
      wilaya: json['wilaya'],
      places: (json['places'] as List)
          .map((placeJson) => GuidePlace.fromJson(placeJson))
          .toList(),
    );
  }
}
