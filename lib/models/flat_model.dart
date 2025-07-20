class FlatModel {
  final String? id;
  final String hostId;
  final String title;
  final String description;
  final String flatType;
  final double rentPerHead;
  final String location;
  final double? latitude;
  final double? longitude;
  final List<String> amenities;
  final List<String> images;
  final String genderPreference;
  final int availableSpots;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  FlatModel({
    this.id,
    required this.hostId,
    required this.title,
    required this.description,
    required this.flatType,
    required this.rentPerHead,
    required this.location,
    this.latitude,
    this.longitude,
    required this.amenities,
    required this.images,
    required this.genderPreference,
    required this.availableSpots,
    this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hostId': hostId,
      'title': title,
      'description': description,
      'flatType': flatType,
      'rentPerHead': rentPerHead,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'amenities': amenities,
      'images': images,
      'genderPreference': genderPreference,
      'availableSpots': availableSpots,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'isActive': isActive,
    };
  }

  factory FlatModel.fromMap(Map<String, dynamic> map, {String? documentId}) {
    return FlatModel(
      id: documentId ?? map['id'],
      hostId: map['hostId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      flatType: map['flatType'] ?? '',
      rentPerHead: map['rentPerHead']?.toDouble() ?? 0.0,
      location: map['location'] ?? '',
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      amenities: List<String>.from(map['amenities'] ?? []),
      images: List<String>.from(map['images'] ?? []),
      genderPreference: map['genderPreference'] ?? '',
      availableSpots: map['availableSpots']?.toInt() ?? 1,
      createdAt: map['createdAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'])
          : null,
      isActive: map['isActive'] ?? true,
    );
  }

  FlatModel copyWith({
    String? id,
    String? hostId,
    String? title,
    String? description,
    String? flatType,
    double? rentPerHead,
    String? location,
    double? latitude,
    double? longitude,
    List<String>? amenities,
    List<String>? images,
    String? genderPreference,
    int? availableSpots,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return FlatModel(
      id: id ?? this.id,
      hostId: hostId ?? this.hostId,
      title: title ?? this.title,
      description: description ?? this.description,
      flatType: flatType ?? this.flatType,
      rentPerHead: rentPerHead ?? this.rentPerHead,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      amenities: amenities ?? this.amenities,
      images: images ?? this.images,
      genderPreference: genderPreference ?? this.genderPreference,
      availableSpots: availableSpots ?? this.availableSpots,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}