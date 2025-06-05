class AgencyOffer {
  final String id;
  final String agencyId;
  final String title;
  final double price;
  final String wilaya;
  final String description;

  AgencyOffer({
    required this.id,
    required this.agencyId,
    required this.title,
    required this.price,
    required this.wilaya,
    required this.description,
  });

  factory AgencyOffer.fromJson(Map<String, dynamic> json) => AgencyOffer(
        id: json['id'],
        agencyId: json['agency_id'],
        title: json['title'],
        price: (json['price'] as num).toDouble(),
        wilaya: json['wilaya'],
        description: json['description'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'agency_id': agencyId,
        'title': title,
        'price': price,
        'wilaya': wilaya,
        'description': description,
      };
}