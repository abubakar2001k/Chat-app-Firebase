
import 'package:chat_application/presentation/login/login_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/genric_button.dart';
import '../../widgets/genric_text_form_field.dart';

class LoginPage extends StatelessWidget {
   LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar:  AppBar(title: Text("LoginPage"),),
        body: SingleChildScrollView(
          child:  Consumer<LoginController>(
            builder: (context, controller , child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text("Login ", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,

                    ),),
                  ),
                  SizedBox(height: MediaQuery
                      .of(context)
                      .size
                      .height * .1),
                  GenricTextFormField(
                    controller: controller.emailController,
                    textLabel: 'Email',
                    sufixicon: Icon(Icons.email),
                  ),
                  SizedBox(height: MediaQuery
                      .of(context)
                      .size
                      .height * .04),
                   GenricTextFormField(
                    controller: controller.passwordController,
                    textLabel: 'Password',
                    isObscure: controller.isObscure,

                    sufixicon: InkWell(
                      onTap:
                        controller.visiblity,
                        child: Icon(
                          controller.isObscure
                            ? Icons.visibility_off
                          : Icons.remove_red_eye
                        )),
                  ),
                  SizedBox(height: MediaQuery
                      .of(context)
                      .size
                      .height * .04),
                  GenricButton(
                    text: "Login",
                    onTap: () {
                      controller.signInWithEmailPassword(context);

                    },
                  ),
                  if(controller.isLoading)
                  const Center(
                    child: LinearProgressIndicator(),
                  ),
                  SizedBox(height: MediaQuery
                      .of(context)
                      .size
                      .height * .04),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/signup')
                      ;
                    },
                    child: Text("Not yet Registerd! Sign Up ", style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 20,

                    ),),
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
