import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


Widget buildChatItem(String name, String message, String time) {
  return ListTile(
    leading: CircleAvatar(
      backgroundColor: Colors.grey[300],
      child: Text(name[0]),
    ),
    title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
    subtitle: Text(message),
    trailing: Text(time, style: TextStyle(color: Colors.grey)),
  );
}













//
//
// Widget PendingRequest(BuildContext context) {
//   final HomeController homeController = Provider.of<HomeController>(context);
//   return ListView.builder(
//       itemCount: homeController.pendingRequests.length,
//       itemBuilder: (context, index) {
//         final Requests requests = homeController.pendingRequests[index];
//         return FutureBuilder<String>(
//           future: homeController.fetchRequesterName(requests.requestedBy ?? ""),
//           builder: (context, snapshots) {
//             final requestname = snapshots.data ?? 'Unknown';
//
//             return ListTile(
//               leading: CircleAvatar(
//                 backgroundColor: Colors.grey[300],
//                 child: Text(requestname[0]),
//               ),
//               // title: Text(req),
//               title: Text(requestname ?? "",
//                   style: TextStyle(fontWeight: FontWeight.bold)),
//               // subtitle: Text(message),
//               trailing: requests.status?.contains("accepted") ?? false
//                   ? GenricButton(
//                 text: 'Chat With...',
//                 onTap: () async {
//                   final currentUserId =
//                       homeController.currentUser?.userId;
//                   if (currentUserId == null) {
//                     return;
//                   }
//                   final chatController = ChatController();
//                   final chatId = await chatController.getOrCreateChatId(
//                     currentUserId,
//                     requests.requestedBy ?? '',
//                   );
//                   if (chatId != null) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ChatScreen(
//                           userId: currentUserId,
//                           otherUserId: requests.requestedBy ?? '',
//                           chatId: chatId,
//                         ),
//                       ),
//                     );
//                   }
//                 },
//               )
//                   : GenricButton(
//                 text: "Accept Request",
//                 onTap: () {
//                   final userId = requests.requestedBy ?? '';
//                   homeController.acceptRequest(UserModel(userId: userId));
//                 },
//               ),
//             );
//           },
//         );
//
//         // final
//       });
// }

// Widget allUsers(BuildContext context) {
//   // final HomeController homeController = Provider.of<HomeController>(context);
//   return Consumer<HomeController>(builder: (context, provider, child) {
//     return ListView.builder(
//       itemCount: provider.users.length,
//       itemBuilder: (context, index) {
//         UserModel userModel = provider.users[index];
//
//         return ListTile(
//             leading: CircleAvatar(
//               backgroundColor: Colors.grey[300],
//               child: Text(userModel.name![0]),
//             ),
//             title: Text(userModel.name ?? "",
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             subtitle: Text(userModel.email ?? "",
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             trailing: Consumer<HomeController>(
//               builder: (context, provider, child) {
//                 String buttonText = provider.requestStatus[userModel.userId] ??
//                     "Send A Request";
//                 return GenricButton(
//                     text: buttonText,
//                     onTap: buttonText == "Pending" || buttonText == "Sending..."
//                         ? null // Disable button when request is in progress or pending
//                     // : () => provider.userRequest,
//                         : () => provider.userRequest(userModel));
//               },
//             ));
//       },
//     );
//
//     // final
//   });
// }

//
// Widget AccpetedRequest(BuildContext context) {
//   final HomeController homeController = Provider.of<HomeController>(context);
//   return Consumer<HomeController>(
//     builder: (context, provider, child) {
//       return ListView.builder(
//           itemCount: provider.acceptRequests.length,
//           itemBuilder: (context, index) {
//             final Requests requests = homeController.acceptRequests[index];
//             return FutureBuilder<String>(
//               future: provider.fetchRequesterName(requests.requestedBy ?? ""),
//               builder: (context, snapshots) {
//                 final requestname = snapshots.data ?? 'Unknown';
//
//                 return ListTile(
//                     leading: CircleAvatar(
//                       backgroundColor: Colors.grey[300],
//                       child: Text(requestname[0]),
//                     ),
//                     title: Text(requestname ?? "",
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                     // subtitle: Text(message),
//                     trailing: GenricButton(
//                       text: 'Chat With...',
//                       onTap: () async {
//                         final currentUserId =
//                             homeController.currentUser?.userId;
//                         if (currentUserId == null) {
//                           return;
//                         }
//                         final chatController = ChatController();
//                         final chatId = await chatController.getOrCreateChatId(
//                           currentUserId,
//                           requests.requestedBy ?? '',
//                         );
//                         if (chatId != null) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ChatScreen(
//                                 userId: currentUserId,
//                                 otherUserId: requests.requestedBy ?? '',
//                                 chatId: chatId,
//                               ),
//                             ),
//                           );
//                         }
//                       },
//                     ));
//               },
//             );
//
//             // final
//           });
//     },
//   );
// }

//
// Widget Allchat(BuildContext context) {
//   final HomeController homeController = Provider.of<HomeController>(context);
//   final ChatController chatController = Provider.of<ChatController>(context);
//   return Consumer<HomeController>(
//       builder: (context, provider, child) {
//         return ListView.builder(
//             itemCount: provider.acceptRequests.length,
//             itemBuilder: (context, index) {
//               final Requests requests = homeController.acceptRequests[index];
//               print("Total Chats $provider.acceptRequests.length");
//               return FutureBuilder<String>(
//                 future: provider.fetchRequesterName(requests.requestedBy ?? ""),
//                 builder: (context, snapshots) {
//                   final requestname = snapshots.data ?? 'Unknown';
//
//                   return FutureBuilder<Map<String, dynamic>?>(
//                     future: provider.fetchRecentMessage(
//                         requests.requestedBy ?? ""),
//                     builder: (context, messageSnapshot) {
//                       final recentMessage = messageSnapshot.data?['message'] ??
//                           'Hello!..';
//                       final timestamp = messageSnapshot.data?['timestamp'] as int?;
//                       final formattedTime = timestamp != null
//                           ? DateTime.fromMillisecondsSinceEpoch(timestamp)
//                           : null;
//
//                       return InkWell(
//                         onTap: () async {
//                           final currentUserId = homeController.currentUser?.userId;
//                           if (currentUserId == null) {
//                             return;
//                           }
//                           final chatId = await chatController.getOrCreateChatId(
//                             currentUserId,
//                             requests.requestedBy ?? '',
//                           );
//                           if (chatId != null) {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     ChatScreen(
//                                       userId: currentUserId,
//                                       otherUserId: requests.requestedBy ?? '',
//                                       chatId: chatId,
//                                     ),
//                               ),
//                             );
//                           }
//                         },
//                         child: ListTile(
//                           leading: CircleAvatar(
//                             backgroundColor: Colors.grey[300],
//                             child: Text(requestname[0]),
//                           ),
//                           title: Text(requestname,
//                               style: TextStyle(fontWeight: FontWeight.bold)),
//                           subtitle: Text(recentMessage),
//                           trailing: Text(
//                             formattedTime != null
//                                 ? "${formattedTime.hour}:${formattedTime.minute}"
//                                 : "Unknown Time",
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               );
//             }
//         );
//       }
//   );
// }
// Widget Allchat(BuildContext context) {
//   final HomeController homeController = Provider.of<HomeController>(context);
//   final ChatController chatController = Provider.of<ChatController>(context);
//
//   return FutureBuilder<List<Map<String, dynamic>>>(
//     future: chatController.fetchChatUsers(),
//     builder: (context, snapshot) {
//       if (snapshot.connectionState == ConnectionState.waiting) {
//         return Center(child: CircularProgressIndicator());
//       }
//
//       if (!snapshot.hasData || snapshot.data!.isEmpty) {
//         return Center(child: Text("No chats found."));
//       }
//
//       final chatUsers = snapshot.data!;
//
//       return ListView.builder(
//         itemCount: chatUsers.length,
//         itemBuilder: (context, index) {
//           final chatUser = chatUsers[index];
//           final otherUserId = chatUser['userId'];
//           final recentMessage = chatUser['recentMessage'] ?? 'No messages yet.';
//           final timestamp = chatUser['timestamp'] as int?;
//           final formattedTime = timestamp != null
//               ? DateTime.fromMillisecondsSinceEpoch(timestamp)
//               : null;
//
//           return FutureBuilder<String>(
//             future: homeController.fetchRequesterName(otherUserId),
//             builder: (context, snapshot) {
//               final userName = snapshot.data ?? "Unknown";
//
//               return InkWell(
//                 onTap: () async {
//                   final currentUserId = homeController.currentUser?.userId;
//                   if (currentUserId == null) {
//                     return;
//                   }
//
//                   final chatId = await chatController.getOrCreateChatId(
//                     currentUserId,
//                     otherUserId,
//                   );
//
//                   if (chatId != null) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ChatScreen(
//                           userId: currentUserId,
//                           otherUserId: otherUserId,
//                           chatId: chatId,
//                         ),
//                       ),
//                     );
//                   }
//                 },
//                 child: ListTile(
//                   leading: CircleAvatar(
//                     backgroundColor: Colors.grey[300],
//                     child: Text(userName.isNotEmpty ? userName[0] : "?"),
//                   ),
//                   title: Text(
//                     userName,
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text(recentMessage),
//                   trailing: Text(
//                     formattedTime != null
//                         ? "${formattedTime.hour}:${formattedTime.minute}"
//                         : "Unknown Time",
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       );
//     },
//   );
// }


//
// Widget buildChatListbb(BuildContext context) {
//   // final HomeController homeController = Provider.of<HomeController>(context);
//   return Consumer<HomeController>(
//     builder: (context, provider, child) {
//       return ListView.builder(
//         itemCount: provider.pendingRequests.length,
//         itemBuilder: (context, index) {
//           final Requests request = provider.pendingRequests[index];
//           return FutureBuilder<String>(
//               future: provider.fetchRequesterName(request.requestedBy ?? ''),
//               builder: (context, snapshot) {
//                 String requesterName = snapshot.data ?? 'Unknown';
//                 return InkWell(
//                     onTap: () async {
//                       final currentUserId = provider.currentUser?.userId;
//                       if (currentUserId == null) {
//                         return;
//                       }
//                       final chatController = ChatController();
//                       final chatId = await chatController.getOrCreateChatId(
//                         currentUserId,
//                         request.requestedBy ?? '',
//                       );
//                       if (chatId != null) {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => ChatScreen(
//                               userId: currentUserId,
//                               otherUserId: request.requestedBy ?? '',
//                               chatId: chatId,
//                             ),
//                           ),
//                         );
//                       }
//                     },
//                     child: buildChatItem(
//                         requesterName, "Ok, Let me check", "09:58 AM"));
//               });
//         },
//       );
//     },
//   );
// }
//
// Widget AccpetedRequest(BuildContext context) {
//   final HomeController homeController = Provider.of<HomeController>(context);
//   return Consumer<HomeController>(
//     builder: (context, provider, child) {
//       return ListView.builder(
//           itemCount: provider.acceptRequests.length,
//           itemBuilder: (context, index) {
//             final Requests requests = homeController.acceptRequests[index];
//             return FutureBuilder<String>(
//               future: provider.fetchRequesterName(requests.requestedBy ?? ""),
//               builder: (context, snapshots) {
//                 final requestname = snapshots.data ?? 'Unknown';
//
//                 return ListTile(
//                     leading: CircleAvatar(
//                       backgroundColor: Colors.grey[300],
//                       child: Text(requestname[0]),
//                     ),
//                     title: Text(requestname ?? "",
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                     // subtitle: Text(message),
//                     trailing: GenricButton(
//                       text: 'Chat With...',
//                       onTap: () async {
//                         final currentUserId =
//                             homeController.currentUser?.userId;
//                         if (currentUserId == null) {
//                           return;
//                         }
//                         final chatController = ChatController();
//                         final chatId = await chatController.getOrCreateChatId(
//                           currentUserId,
//                           requests.requestedBy ?? '',
//                         );
//                         if (chatId != null) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ChatScreen(
//                                 userId: currentUserId,
//                                 otherUserId: requests.requestedBy ?? '',
//                                 chatId: chatId,
//                               ),
//                             ),
//                           );
//                         }
//                       },
//                     ));
//               },
//             );
//
//             // final
//           });
//     },
//   );
// }

// Widget Allchat(BuildContext context) {
//   final HomeController homeController = Provider.of<HomeController>(context);
//   final ChatController chatController = Provider.of<ChatController>(context);
//   return Consumer<HomeController>(
//     builder: (context, provider, child) {
//       return ListView.builder(
//         itemCount: provider.acceptRequests.length,
//         itemBuilder: (context, index) {
//           final Requests requests = homeController.acceptRequests[index];
//           return FutureBuilder<String>(
//               future: provider.fetchRequesterName(requests.requestedBy ?? ""),
//               builder: (context, snapshots) {
//                 final requestname = snapshots.data ?? 'Unknown';
//
//                 // Logic for fetching firest or resent message
//                 return FutureBuilder<Map<String, dynamic>?>(
//                   future: chatController
//                       .getRecentMessage(requests.requestedBy ?? ""),
//                   builder: (context, messageSnapshot) {
//                     final recentMessage =
//                         messageSnapshot.data?['message'] ?? '';
//                     final timestamp =
//                         messageSnapshot.data?['timestamp'] as int?;
//                     final formattedTime = timestamp != null
//                         ? DateTime.fromMillisecondsSinceEpoch(timestamp)
//                         : null;
//
//                     return InkWell(
//                       onTap: () async {
//                         final currentUserId =
//                             homeController.currentUser?.userId;
//                         if (currentUserId == null) {
//                           return;
//                         }
//                         final chatController = ChatController();
//                         final chatId = await chatController.getOrCreateChatId(
//                           currentUserId,
//                           requests.requestedBy ?? '',
//                         );
//                         if (chatId != null) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ChatScreen(
//                                 userId: currentUserId,
//                                 otherUserId: requests.requestedBy ?? '',
//                                 chatId: chatId,
//                               ),
//                             ),
//                           );
//                         }
//                       },
//                       child: ListTile(
//                         leading: CircleAvatar(
//                           backgroundColor: Colors.grey[300],
//                           child: Text(requestname[0]),
//                         ),
//                         title: Text(requestname ?? "",
//                             style: TextStyle(fontWeight: FontWeight.bold)),
//                         subtitle: Text(recentMessage ?? "Hello!.."),
//                         // trailing: Text("20:22 AM", style: TextStyle(color: Colors.grey)),
//                         trailing: Text(
//                           formattedTime != null
//                               ? "${formattedTime.hour}:${formattedTime.minute}"
//                               : "Unknown Time",
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//
//                 // final
//               });
//         },
//       );
//     },
//   );
// }
//
// Widget Allchat(BuildContext context) {
//   final HomeController homeController = Provider.of<HomeController>(context);
//   final ChatController chatController = Provider.of<ChatController>(context);
//   return Consumer<HomeController>(
//     builder: (context, provider, child) {
//       return ListView.builder(
//         itemCount: provider.acceptRequests.length,
//         itemBuilder: (context, index) {
//           final Requests requests = homeController.acceptRequests[index];
//           return FutureBuilder<String>(
//               future: provider.fetchRequesterName(requests.requestedBy ?? ""),
//               builder: (context, snapshots) {
//                 final requestname = snapshots.data ?? 'Unknown';
//
//                 // Logic for fetching firest or resent message
//                 return FutureBuilder<Map<String, dynamic>?>(
//                   future: chatController
//                       .getRecentMessage(requests.requestedBy ?? ""),
//                   builder: (context, messageSnapshot) {
//                     final recentMessage =
//                         messageSnapshot.data?['message'] ?? '';
//                     final timestamp =
//                     messageSnapshot.data?['timestamp'] as int?;
//                     final formattedTime = timestamp != null
//                         ? DateTime.fromMillisecondsSinceEpoch(timestamp)
//                         : null;
//
//                     return InkWell(
//                       onTap: () async {
//                         final currentUserId =
//                             homeController.currentUser?.userId;
//                         if (currentUserId == null) {
//                           return;
//                         }
//                         final chatController = ChatController();
//                         final chatId = await chatController.getOrCreateChatId(
//                           currentUserId,
//                           requests.requestedBy ?? '',
//                         );
//                         if (chatId != null) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ChatScreen(
//                                 userId: currentUserId,
//                                 otherUserId: requests.requestedBy ?? '',
//                                 chatId: chatId,
//                               ),
//                             ),
//                           );
//                         }
//                       },
//                       child: ListTile(
//                         leading: CircleAvatar(
//                           backgroundColor: Colors.grey[300],
//                           child: Text(requestname[0]),
//                         ),
//                         title: Text(requestname ?? "",
//                             style: TextStyle(fontWeight: FontWeight.bold)),
//                         subtitle: Text(recentMessage ?? "Hello!.."),
//                         // trailing: Text("20:22 AM", style: TextStyle(color: Colors.grey)),
//                         trailing: Text(
//                           formattedTime != null
//                               ? "${formattedTime.hour}:${formattedTime.minute}"
//                               : "Unknown Time",
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//
//                 // final
//               });
//         },
//       );
//     },
//   );
// }
//
// Widget PendingRequest(BuildContext context) {
//   final HomeController homeController = Provider.of<HomeController>(context);
//   return ListView.builder(
//       itemCount: homeController.pendingRequests.length,
//       itemBuilder: (context, index) {
//         final Requests requests = homeController.pendingRequests[index];
//         return FutureBuilder<String>(
//           future: homeController.fetchRequesterName(requests.requestedBy ?? ""),
//           builder: (context, snapshots) {
//             final requestname = snapshots.data ?? 'Unknown';
//
//             return ListTile(
//               leading: CircleAvatar(
//                 backgroundColor: Colors.grey[300],
//                 child: Text(requestname[0]),
//               ),
//               // title: Text(req),
//               title: Text(requestname ?? "",
//                   style: TextStyle(fontWeight: FontWeight.bold)),
//               // subtitle: Text(message),
//               trailing: requests.status?.contains("accepted") ?? false
//                   ? GenricButton(
//                       text: 'Chat With...',
//                       onTap: () async {
//                         final currentUserId =
//                             homeController.currentUser?.userId;
//                         if (currentUserId == null) {
//                           return;
//                         }
//                         final chatController = ChatController();
//                         final chatId = await chatController.getOrCreateChatId(
//                           currentUserId,
//                           requests.requestedBy ?? '',
//                         );
//                         if (chatId != null) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ChatScreen(
//                                 userId: currentUserId,
//                                 otherUserId: requests.requestedBy ?? '',
//                                 chatId: chatId,
//                               ),
//                             ),
//                           );
//                         }
//                       },
//                     )
//                   : GenricButton(
//                       text: "Accept Request",
//                       onTap: () {
//                         final userId = requests.requestedBy ?? '';
//                         homeController.acceptRequest(UserModel(userId: userId));
//                       },
//                     ),
//             );
//           },
//         );
//
//         // final
//       });
// }
// Widget Allchat(BuildContext context) {
//   final HomeController homeController = Provider.of<HomeController>(context);
//   final ChatController chatController = Provider.of<ChatController>(context);
//   return Consumer<HomeController>(
//       builder: (context, provider, child) {
//     return ListView.builder(
//         itemCount: provider.acceptRequests.length,
//         itemBuilder: (context, index) {
//           final Requests requests = homeController.acceptRequests[index];
//           return FutureBuilder<String>(
//             future: provider.fetchRequesterName(requests.requestedBy ?? ""),
//             builder: (context, snapshots) {
//               final requestname = snapshots.data ?? 'Unknown';
//
//               return FutureBuilder<Map<String, dynamic>?>(
//                 future: provider.fetchRecentMessage(
//                     requests.requestedBy ?? ""),
//                 builder: (context, messageSnapshot) {
//                   final recentMessage = messageSnapshot.data?['message'] ??
//                       'Hello!..';
//                   final timestamp = messageSnapshot.data?['timestamp'] as int?;
//                   final formattedTime = timestamp != null
//                       ? DateTime.fromMillisecondsSinceEpoch(timestamp)
//                       : null;
//
//                   return InkWell(
//                     onTap: () async {
//                       final currentUserId = homeController.currentUser?.userId;
//                       if (currentUserId == null) {
//                         return;
//                       }
//                       final chatId = await chatController.getOrCreateChatId(
//                         currentUserId,
//                         requests.requestedBy ?? '',
//                       );
//                       if (chatId != null) {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 ChatScreen(
//                                   userId: currentUserId,
//                                   otherUserId: requests.requestedBy ?? '',
//                                   chatId: chatId,
//                                 ),
//                           ),
//                         );
//                       }
//                     },
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundColor: Colors.grey[300],
//                         child: Text(requestname[0]),
//                       ),
//                       title: Text(requestname,
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                       subtitle: Text(recentMessage),
//                       trailing: Text(
//                         formattedTime != null
//                             ? "${formattedTime.hour}:${formattedTime.minute}"
//                             : "Unknown Time",
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         }
//     );
//       }
//   );
//       }
// Widget allUsers(BuildContext context) {
//   final HomeController homeController = Provider.of<HomeController>(context);
//   return Consumer<HomeController>(builder: (context, provider, child) {
//     return ListView.builder(
//       itemCount: provider.users.length,
//       itemBuilder: (context, index) {
//         UserModel userModel = provider.users[index];
//
//         return ListTile(
//             leading: CircleAvatar(
//               backgroundColor: Colors.grey[300],
//               child: Text(userModel.name![0]),
//             ),
//             title: Text(userModel.name ?? "",
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             subtitle: Text(userModel.email ?? "",
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             trailing: Consumer<HomeController>(
//               builder: (context, provider, child) {
//                 String buttonText = provider.requestStatus[userModel.userId] ??
//                     "Send A Request";
//                 return GenricButton(
//                     text: buttonText,
//                     onTap: buttonText == "Pending" || buttonText == "Sending..."
//                         ? null // Disable button when request is in progress or pending
//                         // : () => provider.userRequest,
//                         : () => provider.userRequest(userModel));
//               },
//             ));
//       },
//     );
//
//     // final
//   });
// }
