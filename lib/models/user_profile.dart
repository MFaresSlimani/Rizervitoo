class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? imageUrl;
  final String? phoneNumber;
  final bool isBusinessOwner;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.imageUrl,
    this.phoneNumber,
    required this.isBusinessOwner,
  });

  // copyWith method to create a new instance with updated values
  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? imageUrl,
    String? phoneNumber,
    bool? isBusinessOwner,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isBusinessOwner: isBusinessOwner ?? this.isBusinessOwner,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      imageUrl: json['image_url'],
      phoneNumber: json['phone_number'],
      isBusinessOwner: json['isBusinessOwner'] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'image_url': imageUrl,
      'phone_number': phoneNumber,
      'isBusinessOwner': isBusinessOwner,
    };
  }
}
