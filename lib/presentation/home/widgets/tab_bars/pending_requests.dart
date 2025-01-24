import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/genric_button.dart';
import '../../../chat_screen/chat_screen.dart';
import '../../../chat_screen/chat_vm/chat_screen_vm.dart';
import '../../../../data/model/userModel.dart';
import '../../home_screen_vm.dart';
import 'package:provider/provider.dart';


class PendingRequests extends StatelessWidget {
  const PendingRequests({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Provider.of<HomeController>(context);
    return ListView.builder(
        itemCount: homeController.pendingRequests.length,
        itemBuilder: (context, index) {
          final Requests requests = homeController.pendingRequests[index];
          return FutureBuilder<String>(
            future: homeController.fetchRequesterName(requests.requestedBy ?? ""),
            builder: (context, snapshots) {
              final requestname = snapshots.data ?? 'Unknown';
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Text(requestname[0]),
                ),
                // title: Text(req),
                title: Text(requestname ?? "",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                // subtitle: Text(message),
                trailing: requests.status?.contains("accepted") ?? false
                    ? GenricButton(
                  text: 'Chat With...',
                  onTap: () async {
                    final currentUserId =
                        homeController.currentUser?.userId;
                    if (currentUserId == null) {
                      return;
                    }
                    final chatController = ChatController();
                    final chatId = await chatController.getOrCreateChatId(
                      currentUserId,
                      requests.requestedBy ?? '',
                    );
                    if (chatId != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            userId: currentUserId,
                            otherUserId: requests.requestedBy ?? '',
                            chatId: chatId,
                          ),
                        ),
                      );
                    }
                  },
                )
                    : GenricButton(
                  text: "Accept Request",
                  onTap: () {
                    final userId = requests.requestedBy ?? '';
                    homeController.acceptRequest(UserModel(userId: userId));
                  },
                ),
              );
            },
          );

          // final
        });

  }
}
