
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat_vm/chat_screen_vm.dart';

class ChatScreen extends StatelessWidget {
  final String userId;
  final String otherUserId;
  final String chatId;

  ChatScreen(
      {required this.userId, required this.otherUserId, required this.chatId});

  @override
  Widget build(BuildContext context) {
    final chatController = Provider.of<ChatController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: FutureBuilder<String>(
            future: chatController.getUserByName(otherUserId),
            builder: (context, snapshots) {
              if (snapshots.connectionState == ConnectionState.waiting) {
                return const Text('Loading...');
              } else {
                final userName = snapshots.data ?? 'Unknown ';
                return Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: Text(userName.isNotEmpty ? userName[0] : "?"),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * .02,),
                    Text('$userName'),
                  ],
                );
              }
            }),
        // title: Text('Chat with $otherUserId'),
      ),
      body: FutureBuilder<String>(
        future: chatController.getOrCreateChatId(userId, otherUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(child: Text('Failed to initialize chat.'));
          }

          final chatId = snapshot.data!;
          return Container(
            color: Colors.brown.shade50,
            child: Column(
              children: [
                // Chat Messages List
                Expanded(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: chatController.getMessages(otherUserId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No messages yet.'));
                      }

                      final messages = snapshot.data!;
                      return ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final content = message['message'] as String? ??
                              '[No Content]'; // Fallback
                          final senderId = message['senderId'] as String? ??
                              '[Unknown Sender]'; // Fallback
                          final isCurrentUser = senderId == userId;

                          return FutureBuilder<String>(
                              // future: chatController.getUserByName(userId),
                              future: chatController.getUserByName(senderId),
                              builder: (context, nanmesnapshot) {
                                if (nanmesnapshot.hasError) {
                                  return const Text('Error in the Loading name');
                                } else {
                                  final senderName =
                                      nanmesnapshot.data ?? 'Unknown-users';
                                  final isCurrectUser = senderId == userId;
                                  // final isCurrentUser = senderId == userId;

                                  return Align(
                                    alignment: isCurrentUser
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 8),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isCurrentUser
                                            ? Colors.blue[100]
                                            // : Colors.grey[300],
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            content,
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              });
                        },
                      );
                    },
                  ),
                ),
                // Message Input Field
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: chatController.textController,
                          decoration:  InputDecoration(
                            hintText: 'Type a message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          onSubmitted: (value) async {
                            await chatController.sendMessage(otherUserId);
                          },
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.send,
                          color: Colors.grey.shade700,
                          ),
                          onPressed: () async {
                            // await chatController.sendMessage( UserModel(userId: otherUserId));
                            await chatController.sendMessage(otherUserId);
                          }),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
