import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../chat_screen/chat_screen.dart';
import '../../../chat_screen/chat_vm/chat_screen_vm.dart';
import '../../home_screen_vm.dart';
import 'package:provider/provider.dart';

class AllChats extends StatelessWidget {
  const AllChats({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Provider.of<HomeController>(context);
    final ChatController chatController = Provider.of<ChatController>(context);
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: chatController.fetchChatUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No chats found."));
        }

        final chatUsers = snapshot.data!;

        return ListView.builder(
          itemCount: chatUsers.length,
          itemBuilder: (context, index) {
            final chatUser = chatUsers[index];
            final otherUserId = chatUser['userId'];
            final recentMessage = chatUser['recentMessage'] ?? 'No messages yet.';
            final timestamp = chatUser['timestamp'] as int?;
            final formattedTime = timestamp != null
                ? DateTime.fromMillisecondsSinceEpoch(timestamp)
                : null;

            return FutureBuilder<String>(
              future: homeController.fetchRequesterName(otherUserId),
              builder: (context, snapshot) {
                final userName = snapshot.data ?? "Unknown";

                return InkWell(
                  onTap: () async {
                    final currentUserId = homeController.currentUser?.userId;
                    if (currentUserId == null) {
                      return;
                    }

                    final chatId = await chatController.getOrCreateChatId(
                      currentUserId,
                      otherUserId,
                    );

                    if (chatId != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            userId: currentUserId,
                            otherUserId: otherUserId,
                            chatId: chatId,
                          ),
                        ),
                      );
                    }
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: Text(userName.isNotEmpty ? userName[0] : "?"),
                    ),
                    title: Text(
                      userName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(recentMessage),
                    trailing: Text(
                      formattedTime != null
                          ? "${formattedTime.hour}:${formattedTime.minute}"
                          : "Unknown Time",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
  }
