import 'package:flutter/material.dart';
import 'package:halal/constants/constants.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController? textEditingController;
  final TextInputType? keyboardType;
  final bool obscureText;
  final IconData? icon;
  double? width;
  bool? leftTextAlign =false;
  // ignore: prefer_typing_uninitialized_variables
  var iconOnTap;
  Function? validateFun;
  Function(String?)? onSaved;
  Function(String)? onChanged;
  final bool? isEnable;
  CustomTextField({
    Key? key,
    this.leftTextAlign,
    this.hint,
    this.textEditingController,
    this.keyboardType,
    this.icon,
    this.obscureText = false,
    this.onChanged,
    this.iconOnTap,
    this.width,
    this.validateFun,
    this.onSaved, this.isEnable = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      // height: 50,
      child: TextFormField(
        textAlign: leftTextAlign==false?TextAlign.right:TextAlign.left,
        obscureText: obscureText,
        controller: textEditingController,
        keyboardType: keyboardType,
        cursorColor: kPrimaryColor,
        readOnly: isEnable!,
        textDirection: leftTextAlign ==false? TextDirection.rtl:TextDirection.ltr,
        onSaved: onSaved,
        decoration: InputDecoration(
            errorStyle: const TextStyle(color: Colors.black),
            isDense: true,
            fillColor: Colors.white,
            filled: true,
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0),
              borderSide: const BorderSide(
                color: Colors.black,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                color: Colors.red[400]!,
              ),
            ),
            prefixIcon: GestureDetector(
              child: Icon(
                icon,
                color: kPrimaryColor,
                size: 20,
              ),
              onTap: iconOnTap,
            ),
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 15),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: kPrimaryColor)),
            focusColor: kPrimaryColor,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(
                color: kPrimaryColor,
              ),
            )),
        onChanged: onChanged,
        validator: (value) {
          return validateFun!(value);
        },
      ),
    );
  }
}
