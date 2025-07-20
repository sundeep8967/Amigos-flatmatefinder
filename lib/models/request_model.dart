class RequestModel {
  final String? id;
  final String flatId;
  final String seekerId;
  final String hostId;
  final String status; // 'pending', 'accepted', 'rejected'
  final String? message;
  final DateTime createdAt;
  final DateTime? updatedAt;

  RequestModel({
    this.id,
    required this.flatId,
    required this.seekerId,
    required this.hostId,
    this.status = 'pending',
    this.message,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'flatId': flatId,
      'seekerId': seekerId,
      'hostId': hostId,
      'status': status,
      'message': message,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory RequestModel.fromMap(Map<String, dynamic> map, {String? documentId}) {
    return RequestModel(
      id: documentId ?? map['id'],
      flatId: map['flatId'] ?? '',
      seekerId: map['seekerId'] ?? '',
      hostId: map['hostId'] ?? '',
      status: map['status'] ?? 'pending',
      message: map['message'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: map['updatedAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'])
          : null,
    );
  }

  RequestModel copyWith({
    String? id,
    String? flatId,
    String? seekerId,
    String? hostId,
    String? status,
    String? message,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RequestModel(
      id: id ?? this.id,
      flatId: flatId ?? this.flatId,
      seekerId: seekerId ?? this.seekerId,
      hostId: hostId ?? this.hostId,
      status: status ?? this.status,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}