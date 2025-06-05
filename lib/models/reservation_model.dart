class ReservationModel {
  final String id;
  final String propertyId;
  final String userId;
  final String startDate;
  final String endDate;
  final String? additionalInfo;
  final String? createdAt;
  final String? updatedAt;
  final bool? isAproved;
  final bool? isCanceled;

  ReservationModel({
    required this.id,
    required this.propertyId,
    required this.userId,
    required this.startDate,
    required this.endDate,
    this.additionalInfo,
    required this.createdAt,
    this.updatedAt,
    required this.isAproved,
    required this.isCanceled,
  });

  ReservationModel copyWith({
    String? id,
    String? propertyId,
    String? userId,
    String? startDate,
    String? endDate,
    String? additionalInfo,
    String? createdAt,
    String? updatedAt,
    bool? isAproved,
    bool? isCanceled,
  }) {
    return ReservationModel(
      id: id ?? this.id,
      propertyId: propertyId ?? this.propertyId,
      userId: userId ?? this.userId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isAproved: isAproved ?? this.isAproved,
      isCanceled: isCanceled ?? this.isCanceled,
    );
  }
  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['id'],
      propertyId: json['property_id'],
      userId: json['user_id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      additionalInfo: json['additional_info'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isAproved: json['is_aproved'] ?? false,
      isCanceled: json['is_canceled'] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'property_id': propertyId,
      'user_id': userId,
      'start_date': startDate,
      'end_date': endDate,
      'additional_info': additionalInfo,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_aproved': isAproved,
      'is_canceled': isCanceled,
    };
  }
}