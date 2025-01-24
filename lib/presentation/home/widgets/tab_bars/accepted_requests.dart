
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/genric_button.dart';
import '../../../chat_screen/chat_screen.dart';
import '../../../chat_screen/chat_vm/chat_screen_vm.dart';
import '../../../../data/model/userModel.dart';
import '../../home_screen_vm.dart';

class AcceptedRequests extends StatelessWidget {
  const AcceptedRequests({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Provider.of<HomeController>(context);
    return Consumer<HomeController>(
      builder: (context, provider, child) {
        return ListView.builder(
            itemCount: provider.acceptRequests.length,
            itemBuilder: (context, index) {
              final Requests requests = homeController.acceptRequests[index];
              return FutureBuilder<String>(
                future: provider.fetchRequesterName(requests.requestedBy ?? ""),
                builder: (context, snapshots) {
                  final requestname = snapshots.data ?? 'Unknown';

                  return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        child: Text(requestname[0]),
                      ),
                      title: Text(requestname ?? "", style: TextStyle(fontWeight: FontWeight.bold)),
                      // subtitle: Text(message),
                      trailing: GenricButton(
                        text: 'Chat With...',
                        onTap: () async {
                          final currentUserId = homeController.currentUser?.userId;
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
                      ));
                },
              );

              // final
            });
      },
    );
  }
}
