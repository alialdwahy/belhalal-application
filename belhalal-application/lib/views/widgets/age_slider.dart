import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AgeSlider extends StatelessWidget {
  double age = 21;
  Color thumbColor;
  Color activeColor;
  Color inactiveColor;
  Color textColor;
  Function(double)? onChange;

AgeSlider({Key? key, 
    required this.age,
    required this.thumbColor,
    required this.activeColor,
    required this.inactiveColor,
    required this.textColor,
     this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              valueIndicatorColor: Colors.blueGrey,
              thumbColor: thumbColor,
            ),
            child: Slider(
              max: 70,
              min: 21,
              divisions: 49,
              label: age.round().toString(),
              value: age,
              onChanged: onChange,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
            ),
          ),
        ),
        Text(
          ': العمر',
          style: TextStyle(
              fontSize: 18,
              color: textColor,
              fontWeight: FontWeight.w300),
        ),
      ],
    );
  }
}
