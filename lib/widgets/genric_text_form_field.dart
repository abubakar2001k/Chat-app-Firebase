import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GenricTextFormField extends StatelessWidget {
  final String? textLabel;
  final Widget? sufixicon;
  final bool? isObscure;
  final  TextInputType? keybordType;
final String? Function(String?)? validater;
 final TextEditingController? controller;
  const GenricTextFormField({super.key, this.controller,
    this.sufixicon, this.textLabel, this.isObscure, this.validater, this.keybordType});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height:  MediaQuery.of(context).size.height * .07,
        width: MediaQuery.of(context).size.width * .9,

        child: TextFormField(
          keyboardType: keybordType,
          controller: controller,
          obscureText: isObscure ?? false,
          decoration:InputDecoration(
            labelText: textLabel ,

            suffixIcon: sufixicon,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.horizontal(),
              borderSide: BorderSide(
                color: Colors.black,
              )
            )
          ),
        ),
      ),
    );
  }
}
