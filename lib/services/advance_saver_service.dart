import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/advance_saver_model.dart';

class AdvanceSaverService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'advanceSaverListings';

  // Create advance saver listing
  Future<String?> createListing(AdvanceSaverModel listing) async {
    try {
      // print('Creating advance saver listing...');
      final docRef = await _firestore.collection(_collection).add(listing.toMap());
      // print('Advance saver listing created with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      // print('Error creating advance saver listing: $e');
      rethrow;
    }
  }

  // Get all open listings
  Future<List<AdvanceSaverModel>> getOpenListings() async {
    try {
      // print('Fetching open advance saver listings...');
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('status', isEqualTo: 'open')
          .where('exitDate', isGreaterThan: DateTime.now().millisecondsSinceEpoch)
          .orderBy('exitDate')
          .orderBy('createdAt', descending: true)
          .get();

      final listings = querySnapshot.docs
          .map((doc) => AdvanceSaverModel.fromMap(doc.data(), documentId: doc.id))
          .toList();

      // print('Found ${listings.length} open advance saver listings');
      return listings;
    } catch (e) {
      // print('Error fetching advance saver listings: $e');
      return [];
    }
  }

  // Get listings by user (for exiting user)
  Future<List<AdvanceSaverModel>> getUserListings(String userId) async {
    try {
      // print('Fetching advance saver listings for user: $userId');
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      final listings = querySnapshot.docs
          .map((doc) => AdvanceSaverModel.fromMap(doc.data(), documentId: doc.id))
          .toList();

      // print('Found ${listings.length} advance saver listings for user');
      return listings;
    } catch (e) {
      // print('Error fetching user advance saver listings: $e');
      return [];
    }
  }

  // Get listing by ID
  Future<AdvanceSaverModel?> getListingById(String listingId) async {
    try {
      // print('Fetching advance saver listing: $listingId');
      final doc = await _firestore.collection(_collection).doc(listingId).get();
      
      if (doc.exists) {
        final listing = AdvanceSaverModel.fromMap(doc.data()!, documentId: doc.id);
        // print('Found advance saver listing: ${listing.title}');
        return listing;
      }
      return null;
    } catch (e) {
      // print('Error fetching advance saver listing: $e');
      return null;
    }
  }

  // Update listing status
  Future<bool> updateListingStatus(String listingId, String status, {String? matchedUserId}) async {
    try {
      // print('Updating advance saver listing status: $listingId to $status');
      final updateData = {
        'status': status,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      };

      if (matchedUserId != null) {
        updateData['matchedUserId'] = matchedUserId;
      }

      await _firestore.collection(_collection).doc(listingId).update(updateData);
      // print('Advance saver listing status updated successfully');
      return true;
    } catch (e) {
      // print('Error updating advance saver listing status: $e');
      return false;
    }
  }

  // Delete listing
  Future<bool> deleteListing(String listingId) async {
    try {
      // print('Deleting advance saver listing: $listingId');
      await _firestore.collection(_collection).doc(listingId).delete();
      // print('Advance saver listing deleted successfully');
      return true;
    } catch (e) {
      // print('Error deleting advance saver listing: $e');
      return false;
    }
  }

  // Search listings with filters
  Future<List<AdvanceSaverModel>> searchListings({
    String? location,
    String? genderPreference,
    double? maxRent,
    bool? urgentOnly,
  }) async {
    try {
      // print('Searching advance saver listings with filters...');
      Query query = _firestore
          .collection(_collection)
          .where('status', isEqualTo: 'open')
          .where('exitDate', isGreaterThan: DateTime.now().millisecondsSinceEpoch);

      if (location != null && location.isNotEmpty) {
        query = query.where('location', isGreaterThanOrEqualTo: location)
                    .where('location', isLessThan: location + 'z');
      }

      if (genderPreference != null && genderPreference.isNotEmpty) {
        query = query.where('genderPreference', isEqualTo: genderPreference);
      }

      if (maxRent != null) {
        query = query.where('rent', isLessThanOrEqualTo: maxRent);
      }

      final querySnapshot = await query
          .orderBy('exitDate')
          .orderBy('createdAt', descending: true)
          .get();

      List<AdvanceSaverModel> listings = querySnapshot.docs
          .map((doc) => AdvanceSaverModel.fromMap(doc.data() as Map<String, dynamic>, documentId: doc.id))
          .toList();

      // Filter for urgent only if specified
      if (urgentOnly == true) {
        listings = listings.where((listing) => listing.isUrgent).toList();
      }

      // print('Found ${listings.length} advance saver listings matching filters');
      return listings;
    } catch (e) {
      // print('Error searching advance saver listings: $e');
      return [];
    }
  }

  // Get urgent listings (leaving within 15 days)
  Future<List<AdvanceSaverModel>> getUrgentListings() async {
    try {
      // print('Fetching urgent advance saver listings...');
      final urgentDate = DateTime.now().add(const Duration(days: 15));
      
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('status', isEqualTo: 'open')
          .where('exitDate', isLessThanOrEqualTo: urgentDate.millisecondsSinceEpoch)
          .where('exitDate', isGreaterThan: DateTime.now().millisecondsSinceEpoch)
          .orderBy('exitDate')
          .get();

      final listings = querySnapshot.docs
          .map((doc) => AdvanceSaverModel.fromMap(doc.data(), documentId: doc.id))
          .toList();

      // print('Found ${listings.length} urgent advance saver listings');
      return listings;
    } catch (e) {
      // print('Error fetching urgent advance saver listings: $e');
      return [];
    }
  }

  // Auto-expire listings (to be called periodically)
  Future<void> expireOldListings() async {
    try {
      // print('Expiring old advance saver listings...');
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('status', isEqualTo: 'open')
          .where('exitDate', isLessThan: DateTime.now().millisecondsSinceEpoch)
          .get();

      final batch = _firestore.batch();
      for (final doc in querySnapshot.docs) {
        batch.update(doc.reference, {
          'status': 'expired',
          'updatedAt': DateTime.now().millisecondsSinceEpoch,
        });
      }

      await batch.commit();
      // print('Expired ${querySnapshot.docs.length} old advance saver listings');
    } catch (e) {
      // print('Error expiring old advance saver listings: $e');
    }
  }
}