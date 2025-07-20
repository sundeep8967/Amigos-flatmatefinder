class AdvanceSaverModel {
  final String? id;
  final String userId; // exiting user
  final String flatId;
  final String title;
  final String description;
  final double rent;
  final double refundableDeposit;
  final DateTime exitDate;
  final String genderPreference;
  final String roomDescription;
  final List<String> roomImages;
  final String location;
  final String status; // 'open', 'matched', 'expired'
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? matchedUserId; // user who will replace
  final bool isUrgent; // if exit date is within 15 days
  final List<String> flatmateIds; // remaining flatmates

  AdvanceSaverModel({
    this.id,
    required this.userId,
    required this.flatId,
    required this.title,
    required this.description,
    required this.rent,
    required this.refundableDeposit,
    required this.exitDate,
    required this.genderPreference,
    required this.roomDescription,
    this.roomImages = const [],
    required this.location,
    this.status = 'open',
    required this.createdAt,
    this.updatedAt,
    this.matchedUserId,
    this.isUrgent = false,
    this.flatmateIds = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'flatId': flatId,
      'title': title,
      'description': description,
      'rent': rent,
      'refundableDeposit': refundableDeposit,
      'exitDate': exitDate.millisecondsSinceEpoch,
      'genderPreference': genderPreference,
      'roomDescription': roomDescription,
      'roomImages': roomImages,
      'location': location,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'matchedUserId': matchedUserId,
      'isUrgent': isUrgent,
      'flatmateIds': flatmateIds,
    };
  }

  factory AdvanceSaverModel.fromMap(Map<String, dynamic> map, {String? documentId}) {
    final exitDate = DateTime.fromMillisecondsSinceEpoch(map['exitDate']);
    final now = DateTime.now();
    final isUrgent = exitDate.difference(now).inDays <= 15;

    return AdvanceSaverModel(
      id: documentId ?? map['id'],
      userId: map['userId'] ?? '',
      flatId: map['flatId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      rent: map['rent']?.toDouble() ?? 0.0,
      refundableDeposit: map['refundableDeposit']?.toDouble() ?? 0.0,
      exitDate: exitDate,
      genderPreference: map['genderPreference'] ?? '',
      roomDescription: map['roomDescription'] ?? '',
      roomImages: List<String>.from(map['roomImages'] ?? []),
      location: map['location'] ?? '',
      status: map['status'] ?? 'open',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: map['updatedAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'])
          : null,
      matchedUserId: map['matchedUserId'],
      isUrgent: isUrgent,
      flatmateIds: List<String>.from(map['flatmateIds'] ?? []),
    );
  }

  AdvanceSaverModel copyWith({
    String? id,
    String? userId,
    String? flatId,
    String? title,
    String? description,
    double? rent,
    double? refundableDeposit,
    DateTime? exitDate,
    String? genderPreference,
    String? roomDescription,
    List<String>? roomImages,
    String? location,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? matchedUserId,
    bool? isUrgent,
    List<String>? flatmateIds,
  }) {
    return AdvanceSaverModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      flatId: flatId ?? this.flatId,
      title: title ?? this.title,
      description: description ?? this.description,
      rent: rent ?? this.rent,
      refundableDeposit: refundableDeposit ?? this.refundableDeposit,
      exitDate: exitDate ?? this.exitDate,
      genderPreference: genderPreference ?? this.genderPreference,
      roomDescription: roomDescription ?? this.roomDescription,
      roomImages: roomImages ?? this.roomImages,
      location: location ?? this.location,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      matchedUserId: matchedUserId ?? this.matchedUserId,
      isUrgent: isUrgent ?? this.isUrgent,
      flatmateIds: flatmateIds ?? this.flatmateIds,
    );
  }

  // Helper getters
  bool get isExpired => DateTime.now().isAfter(exitDate);
  bool get isMatched => status == 'matched';
  bool get isOpen => status == 'open';
  
  int get daysUntilExit => exitDate.difference(DateTime.now()).inDays;
  
  String get urgencyTag {
    if (isExpired) return 'EXPIRED';
    if (daysUntilExit <= 7) return 'URGENT';
    if (daysUntilExit <= 15) return 'LEAVING SOON';
    return 'AVAILABLE';
  }
}