import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create or get existing chat between two users
  Future<String?> createOrGetChat(String user1Id, String user2Id) async {
    try {
      // Check if chat already exists
      final existingChat = await _firestore
          .collection('chats')
          .where('participants', arrayContains: user1Id)
          .get();

      for (var doc in existingChat.docs) {
        final participants = List<String>.from(doc.data()['participants']);
        if (participants.contains(user2Id)) {
          return doc.id;
        }
      }

      // Create new chat
      final chatData = ChatModel(
        participants: [user1Id, user2Id],
        createdAt: DateTime.now(),
      );

      final docRef = await _firestore.collection('chats').add(chatData.toMap());
      return docRef.id;
    } catch (e) {
      // print('Error creating/getting chat: $e');
      return null;
    }
  }

  // Send a message
  Future<bool> sendMessage({
    required String chatId,
    required String senderId,
    required String message,
    String type = 'text',
  }) async {
    try {
      final messageData = MessageModel(
        chatId: chatId,
        senderId: senderId,
        message: message,
        timestamp: DateTime.now(),
        type: type,
      );

      // Add message to subcollection
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(messageData.toMap());

      // Update chat with last message info
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': message,
        'lastMessageTime': DateTime.now().millisecondsSinceEpoch,
        'lastMessageSenderId': senderId,
      });

      return true;
    } catch (e) {
      // print('Error sending message: $e');
      return false;
    }
  }

  // Get user's chats
  Stream<List<ChatModel>> getUserChats(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatModel.fromMap(doc.data(), documentId: doc.id))
            .toList());
  }

  // Get messages for a chat
  Stream<List<MessageModel>> getChatMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromMap(doc.data(), documentId: doc.id))
            .toList());
  }

  // Mark messages as read
  Future<bool> markMessagesAsRead(String chatId, String userId) async {
    try {
      final unreadMessages = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .where('senderId', isNotEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      final batch = _firestore.batch();
      for (var doc in unreadMessages.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      await batch.commit();
      return true;
    } catch (e) {
      // print('Error marking messages as read: $e');
      return false;
    }
  }

  // Get unread message count for a chat
  Future<int> getUnreadCount(String chatId, String userId) async {
    try {
      final unreadMessages = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .where('senderId', isNotEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      return unreadMessages.docs.length;
    } catch (e) {
      // print('Error getting unread count: $e');
      return 0;
    }
  }

  // Delete a chat
  Future<bool> deleteChat(String chatId) async {
    try {
      // Delete all messages first
      final messages = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .get();

      final batch = _firestore.batch();
      for (var doc in messages.docs) {
        batch.delete(doc.reference);
      }

      // Delete the chat document
      batch.delete(_firestore.collection('chats').doc(chatId));

      await batch.commit();
      return true;
    } catch (e) {
      // print('Error deleting chat: $e');
      return false;
    }
  }

  // Create system message (for match notifications)
  Future<bool> createSystemMessage({
    required String chatId,
    required String message,
  }) async {
    try {
      final messageData = MessageModel(
        chatId: chatId,
        senderId: 'system',
        message: message,
        timestamp: DateTime.now(),
        type: 'system',
        isRead: true,
      );

      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(messageData.toMap());

      return true;
    } catch (e) {
      // print('Error creating system message: $e');
      return false;
    }
  }
}