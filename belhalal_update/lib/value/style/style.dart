import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';


class Style {
  BoxDecoration boxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 3,
          blurRadius: 4,
          offset: Offset(0, 1), // changes position of shadow
        ),
      ],
    );
  }


  BoxDecoration botton(){


   return BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10));
  }

  BoxDecoration multiWidget() {
    return BoxDecoration(
      // borderRadius: BorderRadius.circular(30),

      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 3,
          blurRadius: 4,
          offset: Offset(0, 1), // changes position of shadow
        ),
      ],
    );
  }

  BoxDecoration contactDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      // image: DecorationImage(
      //   image: AssetImage('image/contact.png'),

      // ),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 3,
          blurRadius: 4,
          offset: Offset(0, 1), // changes position of shadow
        ),
      ],
    );
  }

  BoxDecoration RegistrationbboxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 3,
          blurRadius: 4,
          offset: Offset(0, 1), // changes position of shadow
        ),
      ],
    );
  }

  BoxDecoration dropdownRegistrationBoxDecoration() {
    return BoxDecoration(
        color: HexColor("#e4e4e4"),
        border: Border.all(color: HexColor("#e4e4e4"), width: 0),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 4, offset: Offset(0.0, 0.1))
        ]);
  }

  BoxDecoration profileBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.grey,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 3,
          blurRadius: 4,
          offset: Offset(0, 1), // changes position of shadow
        ),
      ],
    );
  }

  BoxDecoration statusBoxDecoration(Color color) {
    return BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 4,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(20));
  }

  TextStyle headerStyle() {
    return TextStyle(
      fontWeight: FontWeight.w400,
      color: Colors.black87,
    );
  }

  TextStyle contactHeaderStyle() {
    return TextStyle(fontWeight: FontWeight.w800, color: Colors.black87);
  }

  TextStyle titleStyle() {
    return TextStyle(
      fontWeight: FontWeight.w300,
      color: Colors.black54,
    );
  }

  TextStyle styleDropDown() {
    return TextStyle(
      color: Colors.black54,
      fontSize: 14,
    );
  }

  TextStyle styleHeader() {
    return TextStyle(
      fontWeight: FontWeight.w400,
      color: Colors.black87,
    );
  }

  TextStyle styleTitle() {
    return TextStyle(
      fontWeight: FontWeight.w300,
      color: Colors.black54,
    );
  }

  TextStyle styleTitlePrenum() {
    return TextStyle(
      fontWeight: FontWeight.w900,
      color: Colors.redAccent,
    );
  }
}
