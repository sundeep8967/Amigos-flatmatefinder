import 'user_preferences_model.dart';

class UserModel {
  final String uid;
  final String? name;
  final int? age;
  final String? gender;
  final String? role; // 'host' or 'seeker'
  final String? bio;
  final String? occupation;
  final String? profilePicture;
  final double? budget;
  final String? preferredGender;
  final String? preferredLocation;
  final DateTime? createdAt;
  final UserPreferencesModel? preferences;
  final List<String> verificationBadges;
  final double? rating;
  final int? reviewCount;
  final List<String> favoriteListings;
  final bool isVerified;

  UserModel({
    required this.uid,
    this.name,
    this.age,
    this.gender,
    this.role,
    this.bio,
    this.occupation,
    this.profilePicture,
    this.budget,
    this.preferredGender,
    this.preferredLocation,
    this.createdAt,
    this.preferences,
    this.verificationBadges = const [],
    this.rating,
    this.reviewCount,
    this.favoriteListings = const [],
    this.isVerified = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'age': age,
      'gender': gender,
      'role': role,
      'bio': bio,
      'occupation': occupation,
      'profilePicture': profilePicture,
      'budget': budget,
      'preferredGender': preferredGender,
      'preferredLocation': preferredLocation,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'preferences': preferences?.toMap(),
      'verificationBadges': verificationBadges,
      'rating': rating,
      'reviewCount': reviewCount,
      'favoriteListings': favoriteListings,
      'isVerified': isVerified,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'],
      age: map['age']?.toInt(),
      gender: map['gender'],
      role: map['role'],
      bio: map['bio'],
      occupation: map['occupation'],
      profilePicture: map['profilePicture'],
      budget: map['budget']?.toDouble(),
      preferredGender: map['preferredGender'],
      preferredLocation: map['preferredLocation'],
      createdAt: map['createdAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : null,
      preferences: map['preferences'] != null 
          ? UserPreferencesModel.fromMap(map['preferences'])
          : null,
      verificationBadges: List<String>.from(map['verificationBadges'] ?? []),
      rating: map['rating']?.toDouble(),
      reviewCount: map['reviewCount']?.toInt(),
      favoriteListings: List<String>.from(map['favoriteListings'] ?? []),
      isVerified: map['isVerified'] ?? false,
    );
  }

  UserModel copyWith({
    String? uid,
    String? name,
    int? age,
    String? gender,
    String? role,
    String? bio,
    String? occupation,
    String? profilePicture,
    double? budget,
    String? preferredGender,
    String? preferredLocation,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      role: role ?? this.role,
      bio: bio ?? this.bio,
      occupation: occupation ?? this.occupation,
      profilePicture: profilePicture ?? this.profilePicture,
      budget: budget ?? this.budget,
      preferredGender: preferredGender ?? this.preferredGender,
      preferredLocation: preferredLocation ?? this.preferredLocation,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}