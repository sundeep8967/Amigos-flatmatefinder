import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class FavoritesProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  List<String> _favoriteListings = [];
  bool _isLoading = false;
  String? _error;

  List<String> get favoriteListings => _favoriteListings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load user's favorite listings
  Future<void> loadFavorites(String userId) async {
    _setLoading(true);
    _error = null;
    
    try {
      final user = await _authService.getUserDocument(userId);
      if (user != null) {
        _favoriteListings = user.favoriteListings;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Add listing to favorites
  Future<bool> addToFavorites(String userId, String listingId) async {
    _error = null;
    
    try {
      if (!_favoriteListings.contains(listingId)) {
        _favoriteListings.add(listingId);
        notifyListeners();
        
        final success = await _authService.updateUserDocument(userId, {
          'favoriteListings': _favoriteListings,
        });
        
        if (!success) {
          // Revert on failure
          _favoriteListings.remove(listingId);
          notifyListeners();
          _error = 'Failed to add to favorites';
          return false;
        }
        
        return true;
      }
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  // Remove listing from favorites
  Future<bool> removeFromFavorites(String userId, String listingId) async {
    _error = null;
    
    try {
      if (_favoriteListings.contains(listingId)) {
        _favoriteListings.remove(listingId);
        notifyListeners();
        
        final success = await _authService.updateUserDocument(userId, {
          'favoriteListings': _favoriteListings,
        });
        
        if (!success) {
          // Revert on failure
          _favoriteListings.add(listingId);
          notifyListeners();
          _error = 'Failed to remove from favorites';
          return false;
        }
        
        return true;
      }
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  // Toggle favorite status
  Future<bool> toggleFavorite(String userId, String listingId) async {
    if (_favoriteListings.contains(listingId)) {
      return await removeFromFavorites(userId, listingId);
    } else {
      return await addToFavorites(userId, listingId);
    }
  }

  // Check if listing is favorited
  bool isFavorite(String listingId) {
    return _favoriteListings.contains(listingId);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}