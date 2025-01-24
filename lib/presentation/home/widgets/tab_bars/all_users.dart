
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/model/userModel.dart';
import '../../../../widgets/genric_button.dart';
import '../../home_screen_vm.dart';


class AllUsers extends StatelessWidget {
  const AllUsers({super.key});

  @override
  Widget build(BuildContext context) {
      // final HomeController homeController = Provider.of<HomeController>(context);
      return Consumer<HomeController>(builder: (context, provider, child) {
        return ListView.builder(
          itemCount: provider.users.length,
          itemBuilder: (context, index) {
            UserModel userModel = provider.users[index];

            return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Text(userModel.name![0]),
                ),
                title: Text(userModel.name ?? "",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(userModel.email ?? "",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Consumer<HomeController>(
                  builder: (context, provider, child) {
                    String buttonText = provider.requestStatus[userModel.userId] ??
                        "Send A Request";
                    return GenricButton(
                        text: buttonText,
                        onTap: buttonText == "Pending" || buttonText == "Sending..."
                            ? null // Disable button when request is in progress or pending
                        // : () => provider.userRequest,
                            : () => provider.userRequest(userModel));
                  },
                ));
          },
        );

        // final
      });
    }
  }
