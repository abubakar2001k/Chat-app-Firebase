
import 'package:chat_application/presentation/home/widgets/tab_bars/accepted_requests.dart';
import 'package:chat_application/presentation/home/widgets/tab_bars/all_chats.dart';
import 'package:chat_application/presentation/home/widgets/tab_bars/all_users.dart';
import 'package:chat_application/presentation/home/widgets/tab_bars/pending_requests.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_screen_vm.dart';


class Homeduble extends StatefulWidget {
  const Homeduble({super.key});

  @override
  State<Homeduble> createState() => _HomedubleState();
}

class _HomedubleState extends State<Homeduble> {
         // Homeduble

  @override
  void initState() {
    // TODO: implement initState
    debugPrint("Home init called");
    final HomeController homeController = Provider.of<HomeController>(context, listen: false);
    homeController.fetchCurrentUser();
    homeController.acceptRequests;

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    final HomeController homeController = Provider.of<HomeController>(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: Text(
                  homeController.currentUser?.name?.isNotEmpty ?? false
                      ? homeController.currentUser!.name![0]
                      : 'A',
                  style: const TextStyle(
                    color: Colors.purpleAccent,
                  ),

                ),
              ),
              SizedBox(width: MediaQuery
                  .of(context)
                  .size
                  .width * .04,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    homeController.currentUser?.name ?? "Hello,",
                    // "Hello, Johan",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    homeController.currentUser?.email ?? "email@email.com",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

            ],
          ),
          backgroundColor: Colors.purpleAccent.shade200,
          elevation: 0,
          bottom:
          TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.purpleAccent,
            unselectedLabelColor: Colors.white,
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            indicatorPadding: EdgeInsets.symmetric(horizontal: .01, vertical: 6.0),
            // indicatorPadding: EdgeInsets.zero,
            tabs: const [
              Tab(text: "All Chats"),
              Tab(text: "All Users"),
              Tab(text: "Pending"),
              Tab(text: "Accepted"),
            ],
          ),
          actions: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .06,
              width: MediaQuery.of(context).size.width * .06,
              child: InkWell(
                onTap: () {
                  homeController.logout(context: context);
                },
                child: const Icon(Icons.logout,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: const TabBarView(
          children: [
           AllChats(),
            AllUsers(),
            PendingRequests(),
            AcceptedRequests(),
          ],
        ),
      ),
    );
  }
}
