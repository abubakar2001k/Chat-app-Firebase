
import 'package:chat_application/presentation/spalch_screen/spalch_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplachScreen extends StatefulWidget {
  const SplachScreen({super.key});

  @override
  State<SplachScreen> createState() => _SplachScreenState();
}

class _SplachScreenState extends State<SplachScreen> {
  @override
  Widget build(BuildContext context) {
    Future.microtask(() =>
        Provider.of<SplachController>(context, listen: false).checkLoginState(context));
    return  SafeArea(
          child:
          Scaffold(
            body: Stack(
              children: [
                Container(
                  margin:EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.1),
                  padding: const EdgeInsets.only(
                    top:50, left: 20,  right: 30
                  ),
                  height:MediaQuery.of(context).size.height ,
                  width:MediaQuery.of(context).size.width ,
                  decoration:  BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [
                          Colors.blue,
                          Colors.blue,
                          // Colors.blue,
                          Colors.greenAccent,
                          Colors.blue,
                          Colors.blue,
                          // Colors.blue,
                        ]
                    ),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.elliptical(MediaQuery.of(context).size.width ,150)
                    )
                  ),
                ),
                Center(
                  child: InkWell(
                onTap: () {
                Navigator.pushReplacementNamed(context, '/login page');

                },
                    child: Container(
                      height: 250,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(40),
                          bottomLeft: Radius.circular(40),
                        ),
                        boxShadow: [BoxShadow(
                          color: Colors.black.withOpacity(.5),
                          offset: Offset(2, 3),
                          blurRadius: 10,
                        ) ]
                      ), child:  const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Text("Welcome to Chat App",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),

          )
      );
  }
}
