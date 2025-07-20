import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/flat_model.dart';

class FlatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new flat listing
  Future<String?> createFlat(FlatModel flat) async {
    try {
      final docRef = await _firestore.collection('flats').add(flat.toMap());
      return docRef.id;
    } catch (e) {
      // print('Error creating flat: $e');
      return null;
    }
  }

  // Update flat listing
  Future<bool> updateFlat(String flatId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('flats').doc(flatId).update({
        ...data,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });
      return true;
    } catch (e) {
      // print('Error updating flat: $e');
      return false;
    }
  }

  // Get flat by ID
  Future<FlatModel?> getFlatById(String flatId) async {
    try {
      final doc = await _firestore.collection('flats').doc(flatId).get();
      if (doc.exists) {
        return FlatModel.fromMap(doc.data()!, documentId: doc.id);
      }
      return null;
    } catch (e) {
      // print('Error getting flat: $e');
      return null;
    }
  }

  // Get flats by host ID
  Future<List<FlatModel>> getFlatsByHostId(String hostId) async {
    try {
      final querySnapshot = await _firestore
          .collection('flats')
          .where('hostId', isEqualTo: hostId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => FlatModel.fromMap(doc.data(), documentId: doc.id))
          .toList();
    } catch (e) {
      // print('Error getting host flats: $e');
      return [];
    }
  }

  // Get all active flats for seekers
  Future<List<FlatModel>> getActiveFlats({
    String? genderPreference,
    double? maxRent,
    String? location,
  }) async {
    try {
      Query query = _firestore
          .collection('flats')
          .where('isActive', isEqualTo: true)
          .where('availableSpots', isGreaterThan: 0);

      if (genderPreference != null && genderPreference != 'No Preference') {
        query = query.where('genderPreference', whereIn: [genderPreference, 'No Preference']);
      }

      if (maxRent != null) {
        query = query.where('rentPerHead', isLessThanOrEqualTo: maxRent);
      }

      final querySnapshot = await query
          .orderBy('createdAt', descending: true)
          .get();

      List<FlatModel> flats = querySnapshot.docs
          .map((doc) => FlatModel.fromMap(doc.data() as Map<String, dynamic>, documentId: doc.id))
          .toList();

      // Filter by location if specified (client-side filtering for partial matches)
      if (location != null && location.isNotEmpty) {
        flats = flats.where((flat) => 
          flat.location.toLowerCase().contains(location.toLowerCase())
        ).toList();
      }

      return flats;
    } catch (e) {
      // print('Error getting active flats: $e');
      return [];
    }
  }

  // Delete flat
  Future<bool> deleteFlat(String flatId) async {
    try {
      await _firestore.collection('flats').doc(flatId).delete();
      return true;
    } catch (e) {
      // print('Error deleting flat: $e');
      return false;
    }
  }

  // Toggle flat active status
  Future<bool> toggleFlatStatus(String flatId, bool isActive) async {
    try {
      await _firestore.collection('flats').doc(flatId).update({
        'isActive': isActive,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });
      return true;
    } catch (e) {
      // print('Error toggling flat status: $e');
      return false;
    }
  }
}