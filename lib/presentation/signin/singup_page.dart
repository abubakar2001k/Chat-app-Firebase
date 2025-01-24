
import 'package:chat_application/presentation/signin/signup_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/genric_button.dart';
import '../../widgets/genric_text_form_field.dart';




class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    final SignUpController controller =
    Provider.of<SignUpController>(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Consumer<SignUpController>(
            builder: (context, controller, child) {
              return Column(
                children: [
                  const Text("Sign Up ", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.blue,

                  ),),
                  SizedBox(height: MediaQuery
                      .of(context)
                      .size
                      .height * .04),
                  GenricTextFormField(
                    controller: controller.nameController,
                    textLabel: 'Name',
                    sufixicon: Icon(Icons.person),
                  ),
                  SizedBox(height: MediaQuery
                      .of(context)
                      .size
                      .height * .04),
                  GenricTextFormField(
                      controller: controller.userIdController,
                      textLabel: 'User Id',
                      sufixicon: const Icon(Icons.numbers),
                      keybordType: TextInputType.number),
                  SizedBox(height: MediaQuery
                      .of(context)
                      .size
                      .height * .04),
                  GenricTextFormField(
                    controller: controller.emailController,
                    textLabel: 'Email',
                    sufixicon: const Icon(Icons.email),
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
                  GenricTextFormField(
                    controller: controller.conformPasswordController,
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
                    text: "SignUp",
                    onTap: () async {
                      await controller.signUp(context);
                    },
                  ),
                  SizedBox(height: MediaQuery
                      .of(context)
                      .size
                      .height * .04),
                  if(controller.isLoading)
                    const Center(
                      child: LinearProgressIndicator(),
                    ),
                  SizedBox(height: MediaQuery.of(context).size.height * .04),

                  InkWell(
                    onTap:() {
                      Navigator.pushNamed(context, '/login_page')
                      ;},
                    child: const Text("Already Sin Up, Login  ", style: TextStyle(
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
