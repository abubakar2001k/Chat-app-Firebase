import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GenricButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onTap;
  const GenricButton({super.key, this.text, this.onTap });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:  MediaQuery.of(context).size.height * .07,
      width: MediaQuery.of(context).size.width * .4,
      child: ElevatedButton(
          onPressed: onTap,
              style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
            backgroundColor: Colors.purpleAccent,
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7)
                )
          ),
          child: Text( text!)
          ),
    );
  }
}

