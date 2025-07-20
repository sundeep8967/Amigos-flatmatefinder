import 'package:flutter/material.dart';
import '../models/request_model.dart';
import '../services/request_service.dart';
import '../services/chat_service.dart';

class RequestProvider with ChangeNotifier {
  final RequestService _requestService = RequestService();
  final ChatService _chatService = ChatService();
  
  List<RequestModel> _hostRequests = [];
  List<RequestModel> _seekerRequests = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<RequestModel> get hostRequests => _hostRequests;
  List<RequestModel> get seekerRequests => _seekerRequests;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Create request
  Future<bool> createRequest({
    required String flatId,
    required String seekerId,
    required String hostId,
    String? message,
  }) async {
    _setLoading(true);
    _error = null;
    
    try {
      // Check if already requested
      final hasRequested = await _requestService.hasRequestedForFlat(seekerId, flatId);
      if (hasRequested) {
        _error = 'You have already requested for this flat';
        return false;
      }

      final request = RequestModel(
        flatId: flatId,
        seekerId: seekerId,
        hostId: hostId,
        message: message,
        createdAt: DateTime.now(),
      );
      
      final requestId = await _requestService.createRequest(request);
      if (requestId != null) {
        // Add to seeker requests list
        final newRequest = request.copyWith(id: requestId);
        _seekerRequests.insert(0, newRequest);
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to send request';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update request status
  Future<bool> updateRequestStatus(String requestId, String status) async {
    _setLoading(true);
    _error = null;
    
    try {
      final success = await _requestService.updateRequestStatus(requestId, status);
      if (success) {
        // Update local lists
        final hostIndex = _hostRequests.indexWhere((req) => req.id == requestId);
        RequestModel? updatedRequest;
        
        if (hostIndex != -1) {
          updatedRequest = _hostRequests[hostIndex].copyWith(
            status: status,
            updatedAt: DateTime.now(),
          );
          _hostRequests[hostIndex] = updatedRequest;
        }
        
        final seekerIndex = _seekerRequests.indexWhere((req) => req.id == requestId);
        if (seekerIndex != -1) {
          if (updatedRequest == null) {
            updatedRequest = _seekerRequests[seekerIndex].copyWith(
              status: status,
              updatedAt: DateTime.now(),
            );
          }
          _seekerRequests[seekerIndex] = updatedRequest;
        }
        
        // If request is accepted, create a chat
        if (status == 'accepted' && updatedRequest != null) {
          await _createMatchChat(updatedRequest);
        }
        
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to update request status';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Create chat when request is accepted
  Future<void> _createMatchChat(RequestModel request) async {
    try {
      final chatId = await _chatService.createOrGetChat(
        request.hostId,
        request.seekerId,
      );
      
      if (chatId != null) {
        // Create system message about the match
        await _chatService.createSystemMessage(
          chatId: chatId,
          message: 'You\'ve been matched! Start chatting to get to know each other.',
        );
      }
    } catch (e) {
      // print('Error creating match chat: $e');
    }
  }

  // Load host requests
  Future<void> loadHostRequests(String hostId) async {
    _setLoading(true);
    _error = null;
    
    try {
      _hostRequests = await _requestService.getRequestsByHostId(hostId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Load seeker requests
  Future<void> loadSeekerRequests(String seekerId) async {
    _setLoading(true);
    _error = null;
    
    try {
      _seekerRequests = await _requestService.getRequestsBySeekerId(seekerId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Check if seeker has requested for flat
  Future<bool> hasRequestedForFlat(String seekerId, String flatId) async {
    try {
      return await _requestService.hasRequestedForFlat(seekerId, flatId);
    } catch (e) {
      return false;
    }
  }

  // Get pending requests count
  Future<int> getPendingRequestsCount(String hostId) async {
    try {
      return await _requestService.getPendingRequestsCount(hostId);
    } catch (e) {
      return 0;
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