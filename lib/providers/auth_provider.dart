import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _user;
  UserModel? _userModel;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get user => _user;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    // Listen to auth state changes
    _authService.authStateChanges.listen((User? user) async {
      _user = user;
      if (user != null) {
        await _loadUserModel();
      } else {
        _userModel = null;
      }
      notifyListeners();
    });
  }

  // Load user model from Firestore
  Future<void> _loadUserModel() async {
    if (_user != null) {
      _userModel = await _authService.getUserDocument(_user!.uid);
      notifyListeners();
    }
  }

  // Sign in anonymously
  Future<bool> signInAnonymously() async {
    _setLoading(true);
    _error = null;
    
    try {
      final result = await _authService.signInAnonymously();
      if (result != null) {
        _user = result.user;
        return true;
      } else {
        _error = 'Failed to sign in';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update user data
  Future<bool> updateUserData(Map<String, dynamic> data) async {
    if (_user == null) return false;
    
    _setLoading(true);
    _error = null;
    
    try {
      final success = await _authService.updateUserDocument(_user!.uid, data);
      if (success) {
        await _loadUserModel();
        return true;
      } else {
        _error = 'Failed to update user data';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Create initial user document
  Future<bool> createUserDocument({
    required String gender,
    required String role,
  }) async {
    if (_user == null) return false;
    
    _setLoading(true);
    _error = null;
    
    try {
      final userModel = UserModel(
        uid: _user!.uid,
        gender: gender,
        role: role,
        createdAt: DateTime.now(),
      );
      
      final success = await _authService.createUserDocument(userModel);
      if (success) {
        _userModel = userModel;
        return true;
      } else {
        _error = 'Failed to create user profile';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    _userModel = null;
    notifyListeners();
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