
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

import '../../../data/model/userModel.dart';
import '../../../notifinotification_services/bearer_token.dart';

class ChatController extends ChangeNotifier {
  final BearerToken bearerToken = BearerToken();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final TextEditingController textController = TextEditingController();

  Future<String> getOrCreateChatId(String userId, String otherUserId) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User is not authenticated.");
    }

    final chatsRef = _database.ref('chats');
    try {
      final chatsRef = FirebaseDatabase.instance.ref('chats');

      // Check if chat exists and both users have accepted the request
      final existingChatSnapshot = await chatsRef
          .orderByChild('participants')
          // .orderByChild('participants/$userId')
          .equalTo(true)
          .get();

      if (existingChatSnapshot.exists) {
        for (var chat in existingChatSnapshot.children) {
          final participantsValue = chat.child('participants').value;
          final chatRequestsValue = chat.child('requests').value;

          if (participantsValue == null || chatRequestsValue == null) {
            continue; // Skip if any required value is missing
          }

          final participants = Map<String, dynamic>.from(participantsValue as Map);
          final chatRequests = Map<String, dynamic>.from(chatRequestsValue as Map);

          if (participants[otherUserId] == true && chatRequests.values.contains("accepted")) {
            return chat.key!;
          }
        }
      }

      // Create a new chat if it doesn't exist
      final newChatRef = chatsRef.push();
      await newChatRef.set({
        'participants': {
          userId: true,
          otherUserId: true,
        },
      });
      return newChatRef.key!;
    } catch (e) {
      debugPrint("Error getOrCreateChatId: $e"); // Log the error for debugging purposes
      throw Exception("Failed getOrCreateChatId: ${e.toString()}");
    }
  }

// changes make in this function
  Future<void> sendMessage(String otherUserId) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User is not authenticated.");
    }

    // Retrieve current user ID (sender ID)
    final String userId = user.uid;

    debugPrint("Sender ID: $userId");
    debugPrint("Receiver ID: $otherUserId");

    try {
      // Generate a unique chat ID (could be based on sender and receiver IDs)
      final chatId = userId.compareTo(otherUserId) < 0 ? "$userId-$otherUserId" : "$otherUserId-$userId";

      // Reference to the chat node
      final chatRef = _database.ref('chats/$chatId');

      // Retrieve the receiver's FCM token
      final receiverRef = _database.ref('users/$otherUserId');
      final receiverSnapshot = await receiverRef.get();
      final receiverFcmToken = receiverSnapshot.child('fcmToken').value as String?;

      if (receiverFcmToken == null) {
        print("FCM token not found for receiver: $otherUserId");
      }

      // Retrieve the sender's FCM token
      final senderRef = _database.ref('users/$userId');
      final senderSnapshot = await senderRef.get();
      final senderFcmToken = senderSnapshot.child('fcmToken').value as String?;

      if (senderFcmToken == null) {
        print("FCM token not found for sender: $userId");
      }
      // Add participants information if not already present
      await chatRef.child('participants').set({
        userId: true,
        otherUserId: true,
      });

      // Prepare the message data
      final messageData = {
        'senderId': userId,
        'receiverId': otherUserId,
        'message': textController.text.trim(),
        // Use the input text from the TextEditingController
        'timestamp': ServerValue.timestamp,
      };

      // Send a notification
      await chatRef.child('messages').push().set(messageData);

      if (receiverFcmToken != null) {
        await bearerToken.sendNotification(
          title: "Message Sent to ${receiverSnapshot.child('name').value ?? 'Unknown'}",
          body: textController.text.trim(),
          fcmToken: receiverFcmToken,
        );
      }

      debugPrint("Sender FCM Token: $senderFcmToken");
      debugPrint("Receiver FCM Token: $receiverFcmToken");

      textController.clear();
      //
      // Add the message under the 'messages' node
      final messagesRef = chatRef.child('messages');
      await messagesRef.push().set(messageData);

      print("Message sent successfully!");
    } catch (e) {
      print("Error sending message: $e");
      throw Exception("Failed to send message: $e");
    }
  }

  Stream<List<Map<String, dynamic>>> getMessages(String otherUserId) {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User is not authenticated.");
    }

    // Generate the unique chat ID based on sender and receiver IDs
    final String userId = user.uid;

    debugPrint("Sender ID: $userId");
    debugPrint("Receiver ID: $otherUserId");

    final chatId = userId.compareTo(otherUserId) < 0 ? "$userId-$otherUserId" : "$otherUserId-$userId";

    // Reference to the 'messages' node in the specific chat
    final messagesRef = _database.ref('chats/$chatId/messages');
    // final messagesRef = _database.ref('chats/$chatId');
    // Listen to changes in the 'messages' node
    return messagesRef.onValue.map((event) {
      final messages = <Map<String, dynamic>>[];

      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);

        data.forEach((key, value) {
          final message = Map<String, dynamic>.from(value as Map);
          messages.add({
            'messageId': key, // Include the message ID for reference
            ...message,
          });
        });
      }

      // Sort messages by timestamp to display in chronological order
      messages.sort((a, b) => (a['timestamp'] as int).compareTo(b['timestamp'] as int));
      return messages;
    });
  }

  Future<List<Map<String, dynamic>>> fetchChatUsers() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return [];
    }

    final userId = currentUser.uid;
    final chatsRef = FirebaseDatabase.instance.ref('chats');

    final chatUsers = <Map<String, dynamic>>[];

    final snapshot = await chatsRef.once();
    if (snapshot.snapshot.value != null) {
      final chats = Map<String, dynamic>.from(snapshot.snapshot.value as Map);
      chats.forEach((chatId, chatData) {
        if (chatId.contains(userId)) {
          final participants = (chatData['participants'] as Map).keys.toList();
          final otherUserId = participants.firstWhere((id) => id != userId, orElse: () => null);

          if (otherUserId != null) {
            chatUsers.add({
              'chatId': chatId,
              'userId': otherUserId,
              'recentMessage': chatData['messages']?.values?.last['message'],
              'timestamp': chatData['messages']?.values?.last['timestamp'],
            });
          }
        }
      });
    }

    return chatUsers;
  }

  /// Fetch First msg in chat
  Future<Map<String, dynamic>?> getRecentMessage(String otherUserId) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User is not authenticated.");
    }

    final String userId = user.uid;
    final chatId = userId.compareTo(otherUserId) < 0 ? "$userId-$otherUserId" : "$otherUserId-$userId";

    final messagesRef = _database.ref('chats/$chatId/messages');
    final recentMessageSnapshot = await messagesRef.orderByChild('timestamp').limitToLast(1).get();

    if (recentMessageSnapshot.exists) {
      final data = Map<String, dynamic>.from(recentMessageSnapshot.value as Map<dynamic, dynamic>);
      final recentMessageKey = data.keys.first;
      return {
        'messageId': recentMessageKey,
        ...data[recentMessageKey],
      };
    }

    return null;
  }

  Future<String> getUserByName(String userId) async {
    final userRef = _database.ref('users/$userId');
    final userSnapshot = await userRef.get();

    if (userSnapshot.exists) {
      final userData = Map<String, dynamic>.from(userSnapshot.value as Map);
      final user = UserModel.fromJson(userData);
      return user.name ?? 'unknown';
      // return userData['name'] ?? 'Unknown';
    }
    return 'Unknown';
  }

  Future<void> updateFCMToken(String userId) async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    final token = await _firebaseMessaging.getToken();

    if (token != null) {
      final userRef = FirebaseDatabase.instance.ref('users/$userId');
      await userRef.update({'fcmToken': token});
    }
  }
}
