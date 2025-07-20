import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/request_model.dart';

class RequestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new request
  Future<String?> createRequest(RequestModel request) async {
    try {
      final docRef = await _firestore.collection('requests').add(request.toMap());
      return docRef.id;
    } catch (e) {
      // print('Error creating request: $e');
      return null;
    }
  }

  // Update request status
  Future<bool> updateRequestStatus(String requestId, String status) async {
    try {
      await _firestore.collection('requests').doc(requestId).update({
        'status': status,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });
      return true;
    } catch (e) {
      // print('Error updating request status: $e');
      return false;
    }
  }

  // Get requests for a specific flat
  Future<List<RequestModel>> getRequestsForFlat(String flatId) async {
    try {
      final querySnapshot = await _firestore
          .collection('requests')
          .where('flatId', isEqualTo: flatId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => RequestModel.fromMap(doc.data(), documentId: doc.id))
          .toList();
    } catch (e) {
      // print('Error getting requests for flat: $e');
      return [];
    }
  }

  // Get requests by host ID
  Future<List<RequestModel>> getRequestsByHostId(String hostId) async {
    try {
      final querySnapshot = await _firestore
          .collection('requests')
          .where('hostId', isEqualTo: hostId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => RequestModel.fromMap(doc.data(), documentId: doc.id))
          .toList();
    } catch (e) {
      // print('Error getting requests by host: $e');
      return [];
    }
  }

  // Get requests by seeker ID
  Future<List<RequestModel>> getRequestsBySeekerId(String seekerId) async {
    try {
      final querySnapshot = await _firestore
          .collection('requests')
          .where('seekerId', isEqualTo: seekerId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => RequestModel.fromMap(doc.data(), documentId: doc.id))
          .toList();
    } catch (e) {
      // print('Error getting requests by seeker: $e');
      return [];
    }
  }

  // Check if seeker has already requested for a flat
  Future<bool> hasRequestedForFlat(String seekerId, String flatId) async {
    try {
      final querySnapshot = await _firestore
          .collection('requests')
          .where('seekerId', isEqualTo: seekerId)
          .where('flatId', isEqualTo: flatId)
          .where('status', whereIn: ['pending', 'accepted'])
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      // print('Error checking existing request: $e');
      return false;
    }
  }

  // Get pending requests count for host
  Future<int> getPendingRequestsCount(String hostId) async {
    try {
      final querySnapshot = await _firestore
          .collection('requests')
          .where('hostId', isEqualTo: hostId)
          .where('status', isEqualTo: 'pending')
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      // print('Error getting pending requests count: $e');
      return 0;
    }
  }

  // Delete request
  Future<bool> deleteRequest(String requestId) async {
    try {
      await _firestore.collection('requests').doc(requestId).delete();
      return true;
    } catch (e) {
      // print('Error deleting request: $e');
      return false;
    }
  }

  // Stream of requests for real-time updates
  Stream<List<RequestModel>> getRequestsStream(String hostId) {
    return _firestore
        .collection('requests')
        .where('hostId', isEqualTo: hostId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RequestModel.fromMap(doc.data(), documentId: doc.id))
            .toList());
  }
}