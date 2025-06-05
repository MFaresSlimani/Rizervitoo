class AgencyModel {
  final String id;
  final String ownerId;
  final String name;
  final String location;
  final String description;
  final String imageUrl;
  final String phoneNumber;

  AgencyModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.location,
    required this.description,
    required this.imageUrl,
    required this.phoneNumber,
  });

  factory AgencyModel.fromJson(Map<String, dynamic> json) => AgencyModel(
        id: json['id'],
        ownerId: json['owner_id'],
        name: json['name'],
        location: json['location'],
        description: json['description'],
        imageUrl: json['image_url'],
        phoneNumber: json['phone_number'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'owner_id': ownerId,
        'name': name,
        'location': location,
        'description': description,
        'image_url': imageUrl,
        'phone_number': phoneNumber,
      };
}