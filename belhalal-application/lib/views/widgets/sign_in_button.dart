import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  final double width;
  final double height;
  final String? label;
  final Color? primaryColor;
  final Color? borderColor;
  final Color? labelcolor;
  final Function? ontop;
   const SignInButton({
    Key? key,
    required this.width,
    required this.height,
    required this.label,
    this.borderColor = Colors.white,
    this.labelcolor,
    this.primaryColor,
    this.ontop
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width / 2.5,
        height: height / 15,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              primary: primaryColor, // background
              side:  BorderSide(
                  color: borderColor!, width: .5) // foreground
              ),
          onPressed:()=> ontop!(),
          child: Text(
            '$label',
            style:TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: labelcolor,
            ),
          ),
        ));
  }
}
