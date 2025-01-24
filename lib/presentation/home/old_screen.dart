// import 'package:chat_application/chat/chat_screen.dart';
// import 'package:chat_application/genric/genric_button.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../chat/chat_screen_vm.dart';
// import '../signin/userModel.dart';
// import 'home_screen_vm.dart';
//
// class HomeScreen extends StatelessWidget {
//   HomeScreen({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final HomeController homeController = Provider.of<HomeController>(context);
//     // homeController.fetchCurrentUser();
//     // Use Consumer to listen to changes in HomeController
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//             automaticallyImplyLeading: false,
//             backgroundColor: Colors.white,
//             title: Text(
//               "User List",
//               style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade900, fontSize: 20),
//             ),
//             actions: [
//               Padding(
//                 padding: EdgeInsets.only(right: 18),
//                 child: SizedBox(
//                   height: MediaQuery.of(context).size.height * .06,
//                   width: MediaQuery.of(context).size.width * .06,
//                   child: InkWell(
//                     onTap: () {
//                       homeController.logout(context: context);
//                     },
//                     child: const Icon(Icons.logout),
//                   ),
//                 ),
//               ),
//             ]),
//         // body: Consumer<HomeController>(
//         //   builder: (context, controllerp, child) {
//         //     return
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             InkWell(
//                 onTap: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => Homeduble()));
//                 },
//                 child: Text(homeController.currentUser?.name ?? 'Abu bakar')),
//             Text(homeController.currentUser?.email ?? 'Abu bakar'),
//             Expanded(
//               child: Consumer<HomeController>(
//                 builder: (context, provider, child) {
//                   return ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     // Enable horizontal scrolling
//                     padding: EdgeInsets.symmetric(horizontal: 10),
//                     shrinkWrap: true,
//                     physics: const ScrollPhysics(),
//                     itemCount: homeController.pendingRequests.length,
//                     itemBuilder: (context, index) {
//                       final Requests request = homeController.pendingRequests[index];
//                       return FutureBuilder<String>(
//                         future: homeController.fetchRequesterName(request.requestedBy ?? ''),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState == ConnectionState.waiting) {
//                             return Center(child: CircularProgressIndicator());
//                           } else if (snapshot.hasError) {
//                             return Text('Error fetching requester name');
//                           } else if (snapshot.hasData) {
//                             String requesterName = snapshot.data ?? 'Unknown';
//                             return Consumer<HomeController>(
//                               builder: (context, controller, child) {
//                                 return Card(
//                                   margin: EdgeInsets.symmetric(horizontal: 8),
//                                   // Adjust spacing for horizontal layout
//                                   elevation: 2,
//                                   child: Container(
//                                     width: MediaQuery.of(context).size.width * 0.8,
//                                     // width: 300,
//                                     color: Colors.greenAccent.shade100,
//                                     // height: 100,
//                                     // height: 300,// Set a fixed width for horizontal items
//                                     child: ListTile(
//                                       title: Text(requesterName),
//                                       subtitle: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Text(request.timestamp ?? ''),
//                                           request.status?.contains("accepted") ?? false
//                                               ? GenricButton(
//                                                   text: 'Chat With...',
//                                                   onTap: () async {
//                                                     final currentUserId = homeController.currentUser?.userId;
//                                                     if (currentUserId == null) {
//                                                       return;
//                                                     }
//                                                     final chatController = ChatController();
//                                                     final chatId = await chatController.getOrCreateChatId(
//                                                       currentUserId,
//                                                       request.requestedBy ?? '',
//                                                     );
//                                                     if (chatId != null) {
//                                                       Navigator.push(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                           builder: (context) => ChatScreen(
//                                                             userId: currentUserId,
//                                                             otherUserId: request.requestedBy ?? '',
//                                                             chatId: chatId,
//                                                           ),
//                                                         ),
//                                                       );
//                                                     }
//                                                   },
//                                                 )
//                                               : GenricButton(
//                                                   text: "Accept Request",
//                                                   onTap: () {
//                                                     final userId = request.requestedBy ?? '';
//                                                     controller.acceptRequest(UserModel(userId: userId));
//                                                   },
//                                                 ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             );
//                           } else {
//                             return Text('No data available');
//                           }
//                         },
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//
//             //
//             SizedBox(
//               height: MediaQuery.of(context).size.height * .01,
//             ),
//
//             // Wrap ListView.builder with Expanded to give it constrained height
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Text("All Users "),
//                     SizedBox(
//                       height: 400,
//                       child: Consumer<HomeController>(
//                         builder: (context, homeprovider, child) {
//                           return ListView.builder(
//                             scrollDirection: Axis.horizontal,
//                             padding: const EdgeInsets.symmetric(horizontal: 10),
//                             shrinkWrap: true,
//                             physics: const ScrollPhysics(),
//                             itemCount: homeprovider.users.length,
//                             itemBuilder: (context, index) {
//                               print("User list length: ${homeprovider.users.length}");
//
//                               UserModel userModel = homeprovider.users[index];
//
//                               return Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Card(
//                                   color: Colors.amber.shade200,
//                                   margin: const EdgeInsets.symmetric(vertical: 8),
//                                   elevation: 2,
//                                   child: Column(
//                                     children: [
//                                       Container(
//                                         width: 300,
//                                         color: Colors.amber.shade200,
//                                         child: ListTile(
//                                           title: Text(userModel.name ?? "No Name"),
//                                           subtitle: Text(userModel.email ?? "No Email"), // Add other properties here as needed
//                                         ),
//                                       ),
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                         children: [
//                                           Consumer<HomeController>(builder: (context, provider, child) {
//                                             String buttonText = provider.requestStatus[userModel.userId] ?? "Send A Request";
//                                             return GenricButton(
//                                                 text: buttonText,
//                                                 onTap: buttonText == "Pending" || buttonText == "Sending..."
//                                                     ? null // Disable button when request is in progress or pending
//                                                     // : () => provider.userRequest,
//                                                     : () => provider.userRequest(userModel));
//                                           }),
//                                           // GenricButton(
//                                           //   onTap: () async {
//                                           //     controllerp.userRequest(userModel);
//                                           //   },
//                                           // ),
//
//                                           SizedBox(
//                                             width: MediaQuery.of(context).size.width * .02,
//                                           ),
//                                         ],
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ), //   },
//               // ),
//             ),
//           ],
//         ),
//         //   },
//         // ),
//       ),
//     );
//   }
// }
