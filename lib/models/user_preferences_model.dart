class UserPreferencesModel {
  final String? cleanlinessLevel; // 'very_clean', 'clean', 'moderate', 'relaxed'
  final String? smokingPreference; // 'non_smoker', 'occasional', 'regular', 'no_preference'
  final String? petPreference; // 'love_pets', 'okay_with_pets', 'no_pets', 'allergic'
  final String? socialLevel; // 'very_social', 'social', 'moderate', 'private'
  final String? workSchedule; // 'day_shift', 'night_shift', 'flexible', 'work_from_home'
  final String? partyFrequency; // 'never', 'rarely', 'sometimes', 'often'
  final String? guestPolicy; // 'no_guests', 'occasional', 'frequent', 'no_preference'
  final String? musicPreference; // 'quiet', 'moderate', 'loud', 'no_preference'
  final List<String> interests;
  final List<String> dealBreakers;
  final DateTime? moveInDate;
  final DateTime? moveOutDate;
  final bool isFlexibleWithDates;

  UserPreferencesModel({
    this.cleanlinessLevel,
    this.smokingPreference,
    this.petPreference,
    this.socialLevel,
    this.workSchedule,
    this.partyFrequency,
    this.guestPolicy,
    this.musicPreference,
    this.interests = const [],
    this.dealBreakers = const [],
    this.moveInDate,
    this.moveOutDate,
    this.isFlexibleWithDates = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'cleanlinessLevel': cleanlinessLevel,
      'smokingPreference': smokingPreference,
      'petPreference': petPreference,
      'socialLevel': socialLevel,
      'workSchedule': workSchedule,
      'partyFrequency': partyFrequency,
      'guestPolicy': guestPolicy,
      'musicPreference': musicPreference,
      'interests': interests,
      'dealBreakers': dealBreakers,
      'moveInDate': moveInDate?.millisecondsSinceEpoch,
      'moveOutDate': moveOutDate?.millisecondsSinceEpoch,
      'isFlexibleWithDates': isFlexibleWithDates,
    };
  }

  factory UserPreferencesModel.fromMap(Map<String, dynamic> map) {
    return UserPreferencesModel(
      cleanlinessLevel: map['cleanlinessLevel'],
      smokingPreference: map['smokingPreference'],
      petPreference: map['petPreference'],
      socialLevel: map['socialLevel'],
      workSchedule: map['workSchedule'],
      partyFrequency: map['partyFrequency'],
      guestPolicy: map['guestPolicy'],
      musicPreference: map['musicPreference'],
      interests: List<String>.from(map['interests'] ?? []),
      dealBreakers: List<String>.from(map['dealBreakers'] ?? []),
      moveInDate: map['moveInDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['moveInDate'])
          : null,
      moveOutDate: map['moveOutDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['moveOutDate'])
          : null,
      isFlexibleWithDates: map['isFlexibleWithDates'] ?? true,
    );
  }

  UserPreferencesModel copyWith({
    String? cleanlinessLevel,
    String? smokingPreference,
    String? petPreference,
    String? socialLevel,
    String? workSchedule,
    String? partyFrequency,
    String? guestPolicy,
    String? musicPreference,
    List<String>? interests,
    List<String>? dealBreakers,
    DateTime? moveInDate,
    DateTime? moveOutDate,
    bool? isFlexibleWithDates,
  }) {
    return UserPreferencesModel(
      cleanlinessLevel: cleanlinessLevel ?? this.cleanlinessLevel,
      smokingPreference: smokingPreference ?? this.smokingPreference,
      petPreference: petPreference ?? this.petPreference,
      socialLevel: socialLevel ?? this.socialLevel,
      workSchedule: workSchedule ?? this.workSchedule,
      partyFrequency: partyFrequency ?? this.partyFrequency,
      guestPolicy: guestPolicy ?? this.guestPolicy,
      musicPreference: musicPreference ?? this.musicPreference,
      interests: interests ?? this.interests,
      dealBreakers: dealBreakers ?? this.dealBreakers,
      moveInDate: moveInDate ?? this.moveInDate,
      moveOutDate: moveOutDate ?? this.moveOutDate,
      isFlexibleWithDates: isFlexibleWithDates ?? this.isFlexibleWithDates,
    );
  }

  // Calculate compatibility score with another user (0-100)
  double calculateCompatibilityScore(UserPreferencesModel other) {
    double score = 0;
    int factors = 0;

    // Cleanliness compatibility
    if (cleanlinessLevel != null && other.cleanlinessLevel != null) {
      score += _getCompatibilityScore(cleanlinessLevel!, other.cleanlinessLevel!, [
        'very_clean', 'clean', 'moderate', 'relaxed'
      ]);
      factors++;
    }

    // Smoking compatibility
    if (smokingPreference != null && other.smokingPreference != null) {
      if (smokingPreference == other.smokingPreference) {
        score += 100;
      } else if (smokingPreference == 'no_preference' || other.smokingPreference == 'no_preference') {
        score += 70;
      } else {
        score += 30;
      }
      factors++;
    }

    // Pet compatibility
    if (petPreference != null && other.petPreference != null) {
      if (petPreference == 'allergic' && other.petPreference == 'love_pets') {
        score += 0; // Complete incompatibility
      } else if (petPreference == other.petPreference) {
        score += 100;
      } else {
        score += 60;
      }
      factors++;
    }

    // Social level compatibility
    if (socialLevel != null && other.socialLevel != null) {
      score += _getCompatibilityScore(socialLevel!, other.socialLevel!, [
        'very_social', 'social', 'moderate', 'private'
      ]);
      factors++;
    }

    // Interest overlap
    if (interests.isNotEmpty && other.interests.isNotEmpty) {
      final commonInterests = interests.where((interest) => other.interests.contains(interest)).length;
      final totalInterests = (interests.length + other.interests.length) / 2;
      score += (commonInterests / totalInterests) * 100;
      factors++;
    }

    // Deal breaker check
    bool hasDealBreakers = false;
    for (String dealBreaker in dealBreakers) {
      if (other.interests.contains(dealBreaker) || 
          other.dealBreakers.contains(dealBreaker)) {
        hasDealBreakers = true;
        break;
      }
    }

    if (hasDealBreakers) {
      score *= 0.5; // Reduce score by 50% if deal breakers exist
    }

    return factors > 0 ? score / factors : 0;
  }

  double _getCompatibilityScore(String value1, String value2, List<String> scale) {
    final index1 = scale.indexOf(value1);
    final index2 = scale.indexOf(value2);
    
    if (index1 == -1 || index2 == -1) return 50; // Default score
    
    final difference = (index1 - index2).abs();
    final maxDifference = scale.length - 1;
    
    return ((maxDifference - difference) / maxDifference) * 100;
  }
}