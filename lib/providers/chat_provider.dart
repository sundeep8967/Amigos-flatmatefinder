import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import '../services/chat_service.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();
  
  List<ChatModel> _chats = [];
  List<MessageModel> _currentChatMessages = [];
  bool _isLoading = false;
  String? _error;
  String? _currentChatId;

  // Getters
  List<ChatModel> get chats => _chats;
  List<MessageModel> get currentChatMessages => _currentChatMessages;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get currentChatId => _currentChatId;

  // Create or get chat
  Future<String?> createOrGetChat(String user1Id, String user2Id) async {
    _setLoading(true);
    _error = null;
    
    try {
      final chatId = await _chatService.createOrGetChat(user1Id, user2Id);
      if (chatId != null) {
        _currentChatId = chatId;
        return chatId;
      } else {
        _error = 'Failed to create chat';
        return null;
      }
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Send message
  Future<bool> sendMessage({
    required String chatId,
    required String senderId,
    required String message,
    String type = 'text',
  }) async {
    _error = null;
    
    try {
      final success = await _chatService.sendMessage(
        chatId: chatId,
        senderId: senderId,
        message: message,
        type: type,
      );
      
      if (!success) {
        _error = 'Failed to send message';
      }
      
      return success;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  // Load user chats
  void loadUserChats(String userId) {
    _chatService.getUserChats(userId).listen(
      (chats) {
        _chats = chats;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  // Load chat messages
  void loadChatMessages(String chatId) {
    _currentChatId = chatId;
    _chatService.getChatMessages(chatId).listen(
      (messages) {
        _currentChatMessages = messages;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  // Mark messages as read
  Future<bool> markMessagesAsRead(String chatId, String userId) async {
    try {
      return await _chatService.markMessagesAsRead(chatId, userId);
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  // Get unread count
  Future<int> getUnreadCount(String chatId, String userId) async {
    try {
      return await _chatService.getUnreadCount(chatId, userId);
    } catch (e) {
      return 0;
    }
  }

  // Create system message
  Future<bool> createSystemMessage({
    required String chatId,
    required String message,
  }) async {
    try {
      return await _chatService.createSystemMessage(
        chatId: chatId,
        message: message,
      );
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  // Clear current chat
  void clearCurrentChat() {
    _currentChatId = null;
    _currentChatMessages.clear();
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