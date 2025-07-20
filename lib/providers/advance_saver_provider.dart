import 'package:flutter/material.dart';
import '../models/advance_saver_model.dart';
import '../services/advance_saver_service.dart';

class AdvanceSaverProvider with ChangeNotifier {
  final AdvanceSaverService _advanceSaverService = AdvanceSaverService();
  
  List<AdvanceSaverModel> _listings = [];
  List<AdvanceSaverModel> _userListings = [];
  List<AdvanceSaverModel> _urgentListings = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<AdvanceSaverModel> get listings => _listings;
  List<AdvanceSaverModel> get userListings => _userListings;
  List<AdvanceSaverModel> get urgentListings => _urgentListings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Create listing
  Future<bool> createListing(AdvanceSaverModel listing) async {
    _setLoading(true);
    _error = null;
    
    try {
      final listingId = await _advanceSaverService.createListing(listing);
      if (listingId != null) {
        final newListing = listing.copyWith(id: listingId);
        _userListings.insert(0, newListing);
        _listings.insert(0, newListing);
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to create listing';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Load all open listings
  Future<void> loadOpenListings() async {
    _setLoading(true);
    _error = null;
    
    try {
      _listings = await _advanceSaverService.getOpenListings();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Load user's listings
  Future<void> loadUserListings(String userId) async {
    _setLoading(true);
    _error = null;
    
    try {
      _userListings = await _advanceSaverService.getUserListings(userId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Load urgent listings
  Future<void> loadUrgentListings() async {
    _setLoading(true);
    _error = null;
    
    try {
      _urgentListings = await _advanceSaverService.getUrgentListings();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Search listings
  Future<List<AdvanceSaverModel>> searchListings({
    String? location,
    String? genderPreference,
    double? maxRent,
    bool? urgentOnly,
  }) async {
    _setLoading(true);
    _error = null;
    
    try {
      final results = await _advanceSaverService.searchListings(
        location: location,
        genderPreference: genderPreference,
        maxRent: maxRent,
        urgentOnly: urgentOnly,
      );
      return results;
    } catch (e) {
      _error = e.toString();
      return [];
    } finally {
      _setLoading(false);
    }
  }

  // Match with a listing (for seekers)
  Future<bool> requestToReplace(String listingId, String seekerId) async {
    _setLoading(true);
    _error = null;
    
    try {
      final success = await _advanceSaverService.updateListingStatus(
        listingId, 
        'matched', 
        matchedUserId: seekerId,
      );
      
      if (success) {
        // Update local lists
        _updateListingInLists(listingId, 'matched', seekerId);
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to request replacement';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Cancel listing
  Future<bool> cancelListing(String listingId) async {
    _setLoading(true);
    _error = null;
    
    try {
      final success = await _advanceSaverService.deleteListing(listingId);
      
      if (success) {
        // Remove from local lists
        _listings.removeWhere((listing) => listing.id == listingId);
        _userListings.removeWhere((listing) => listing.id == listingId);
        _urgentListings.removeWhere((listing) => listing.id == listingId);
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to cancel listing';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get listing by ID
  Future<AdvanceSaverModel?> getListingById(String listingId) async {
    try {
      return await _advanceSaverService.getListingById(listingId);
    } catch (e) {
      _error = e.toString();
      return null;
    }
  }

  // Helper method to update listing in all lists
  void _updateListingInLists(String listingId, String status, String? matchedUserId) {
    for (int i = 0; i < _listings.length; i++) {
      if (_listings[i].id == listingId) {
        _listings[i] = _listings[i].copyWith(
          status: status,
          matchedUserId: matchedUserId,
          updatedAt: DateTime.now(),
        );
        break;
      }
    }
    
    for (int i = 0; i < _userListings.length; i++) {
      if (_userListings[i].id == listingId) {
        _userListings[i] = _userListings[i].copyWith(
          status: status,
          matchedUserId: matchedUserId,
          updatedAt: DateTime.now(),
        );
        break;
      }
    }
    
    for (int i = 0; i < _urgentListings.length; i++) {
      if (_urgentListings[i].id == listingId) {
        _urgentListings[i] = _urgentListings[i].copyWith(
          status: status,
          matchedUserId: matchedUserId,
          updatedAt: DateTime.now(),
        );
        break;
      }
    }
  }

  // Expire old listings
  Future<void> expireOldListings() async {
    try {
      await _advanceSaverService.expireOldListings();
      // Refresh listings after expiring
      await loadOpenListings();
    } catch (e) {
      _error = e.toString();
    }
  }

  // Filter methods
  List<AdvanceSaverModel> get noDepositListings => 
      _listings.where((listing) => listing.refundableDeposit == 0).toList();

  List<AdvanceSaverModel> get immediateListings => 
      _listings.where((listing) => listing.daysUntilExit <= 7).toList();

  List<AdvanceSaverModel> filterByGender(String gender) =>
      _listings.where((listing) => 
          listing.genderPreference.toLowerCase() == gender.toLowerCase() ||
          listing.genderPreference.toLowerCase() == 'any'
      ).toList();

  List<AdvanceSaverModel> filterByRent(double maxRent) =>
      _listings.where((listing) => listing.rent <= maxRent).toList();

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Get statistics
  Map<String, int> get statistics {
    return {
      'totalListings': _listings.length,
      'urgentListings': _listings.where((l) => l.isUrgent).length,
      'noDepositListings': _listings.where((l) => l.refundableDeposit == 0).length,
      'matchedListings': _listings.where((l) => l.isMatched).length,
    };
  }
}