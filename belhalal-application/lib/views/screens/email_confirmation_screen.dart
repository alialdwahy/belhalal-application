import 'package:halal/constants/constants.dart';
import 'package:halal/views/screens/login.dart';
import 'package:halal/views/widgets/belhalal_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class EmailConfirmationScreen extends StatefulWidget {
  EmailConfirmationScreen({Key? key,this.confirmEmail}) : super(key: key);
  bool? confirmEmail = true;
  @override
  State<EmailConfirmationScreen> createState() =>
      _EmailConfirmationScreenState();
}

class _EmailConfirmationScreenState extends State<EmailConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Padding(
        padding: EdgeInsets.only(top: width / 5.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              BelhalaLogo(
                height: height,
                width: width,
                logoLabel: 'بالحلال',
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 7),
                height: height / 2.1,
                width: width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                     Text(
                      widget.confirmEmail==true?
                      'تم التحقق  ':
                      'عذرا  فشلت عملية التحقق ',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child:
                      widget.confirmEmail==true?
                          SvgPicture.asset('assets/images/emailConfirmed.svg'):
                          Image.asset('assets/images/sadFace.png'),
                    ),
                    SizedBox(
                      width: width/2.7,
                      child: TextButton(
                        style: ButtonStyle(
                            // fixedSize: MaterialStateProperty.all(
                            //   const Size.fromWidth(120),
                            // ),
                            elevation: MaterialStateProperty.all(2.0),
                            backgroundColor:
                                MaterialStateProperty.all(kPrimaryColor),
                            shadowColor:
                                MaterialStateProperty.all(Colors.black38),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)))),
                        onPressed: () {
                          Get.offAll(() => const LoginScreen());
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(1.0),
                          child: Center(
                            child: Text(
                              'تسجيل الدخول',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
