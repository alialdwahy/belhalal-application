import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class BelhalaLogo extends StatelessWidget {
   BelhalaLogo({
    Key? key,
    required this.height,
    required this.width,
    this.logoLabel,
  }) : super(key: key);
  final double height;
  final double width;
  String? logoLabel;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: SizedBox(
            height: 50,
            width: 50,
            child: SvgPicture.asset('assets/images/bl7alal-logo.svg'),
          ),
        ),
         Text(
          logoLabel==null?'ملف الزواج'
          :logoLabel!,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ],
    );
  }
}
