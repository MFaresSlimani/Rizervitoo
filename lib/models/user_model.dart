class UserNotification {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool read;

  UserNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.read = false,
  });

  factory UserNotification.fromJson(Map<String, dynamic> json) {
    return UserNotification(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      createdAt: DateTime.parse(json['createdAt']),
      read: json['read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'createdAt': createdAt.toIso8601String(),
    'read': read,
  };
}

class UserModel {
  final String id;
  String name;
  final String email;
  String? imageUrl;
  String? phoneNumber;
  bool isBusinessOwner;
  List<String> savedProperties;
  List<UserNotification> notifications;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.imageUrl,
    this.phoneNumber,
    required this.isBusinessOwner,
    List<String>? savedProperties,
    List<UserNotification>? notifications,
  }) : savedProperties = savedProperties ?? [],
      notifications = notifications ?? [];

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? imageUrl,
    String? phoneNumber,
    bool? isBusinessOwner,
    List<String>? savedProperties,
    List<UserNotification>? notifications,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isBusinessOwner: isBusinessOwner ?? this.isBusinessOwner,
      savedProperties: savedProperties ?? List<String>.from(this.savedProperties),
      notifications: notifications ?? List<UserNotification>.from(this.notifications),
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      imageUrl: json['image_url'],
      phoneNumber: json['phone_number'],
      isBusinessOwner: json['isBusinessOwner'] ?? false,
      savedProperties: (json['savedProperties'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      notifications: (json['notifications'] as List<dynamic>?)
              ?.map((e) => UserNotification.fromJson(e as Map<String, dynamic>))
              .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'image_url': imageUrl,
      'phone_number': phoneNumber,
      'isBusinessOwner': isBusinessOwner,
      'savedProperties': savedProperties,
      'notifications': notifications.map((n) => n.toJson()).toList(),
    };
    return data;
  }
}
