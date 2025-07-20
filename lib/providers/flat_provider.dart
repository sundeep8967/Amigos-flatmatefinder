import 'package:flutter/material.dart';
import '../models/flat_model.dart';
import '../services/flat_service.dart';

class FlatProvider with ChangeNotifier {
  final FlatService _flatService = FlatService();
  
  List<FlatModel> _hostFlats = [];
  List<FlatModel> _availableFlats = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<FlatModel> get hostFlats => _hostFlats;
  List<FlatModel> get availableFlats => _availableFlats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Create flat listing
  Future<bool> createFlat(FlatModel flat) async {
    _setLoading(true);
    _error = null;
    
    try {
      final flatId = await _flatService.createFlat(flat);
      if (flatId != null) {
        // Add to host flats list
        final newFlat = flat.copyWith(id: flatId);
        _hostFlats.insert(0, newFlat);
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to create flat listing';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Load host flats
  Future<void> loadHostFlats(String hostId) async {
    _setLoading(true);
    _error = null;
    
    try {
      _hostFlats = await _flatService.getFlatsByHostId(hostId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Load available flats for seekers
  Future<void> loadAvailableFlats({
    String? genderPreference,
    double? maxRent,
    String? location,
  }) async {
    _setLoading(true);
    _error = null;
    
    try {
      _availableFlats = await _flatService.getActiveFlats(
        genderPreference: genderPreference,
        maxRent: maxRent,
        location: location,
      );
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Update flat
  Future<bool> updateFlat(String flatId, Map<String, dynamic> data) async {
    _setLoading(true);
    _error = null;
    
    try {
      final success = await _flatService.updateFlat(flatId, data);
      if (success) {
        // Update local list
        final index = _hostFlats.indexWhere((flat) => flat.id == flatId);
        if (index != -1) {
          // Reload the specific flat
          final updatedFlat = await _flatService.getFlatById(flatId);
          if (updatedFlat != null) {
            _hostFlats[index] = updatedFlat;
            notifyListeners();
          }
        }
        return true;
      } else {
        _error = 'Failed to update flat';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete flat
  Future<bool> deleteFlat(String flatId) async {
    _setLoading(true);
    _error = null;
    
    try {
      final success = await _flatService.deleteFlat(flatId);
      if (success) {
        _hostFlats.removeWhere((flat) => flat.id == flatId);
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to delete flat';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Toggle flat status
  Future<bool> toggleFlatStatus(String flatId, bool isActive) async {
    _setLoading(true);
    _error = null;
    
    try {
      final success = await _flatService.toggleFlatStatus(flatId, isActive);
      if (success) {
        final index = _hostFlats.indexWhere((flat) => flat.id == flatId);
        if (index != -1) {
          _hostFlats[index] = _hostFlats[index].copyWith(isActive: isActive);
          notifyListeners();
        }
        return true;
      } else {
        _error = 'Failed to update flat status';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
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