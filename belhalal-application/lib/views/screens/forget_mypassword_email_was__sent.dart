import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:halal/constants/constants.dart';
import 'package:halal/views/screens/login.dart';
import 'package:halal/views/widgets/belhalal_logo.dart';

class ForgetMyPassEmail extends StatelessWidget {
  const ForgetMyPassEmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BelhalaLogo(
                height: height,
                width: width,
                logoLabel: 'بالحلال',
              ),
                const SizedBox(
                  height: 20,
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
                      const Text(
                        '''تم ارسال بريد الكتروني لإعادة
 تعيين كلمة المرور''',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: SvgPicture.asset(
                            'assets/images/emailConfirmed.svg'),
                      ),
                      TextButton(
                        style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(
                              const Size.fromWidth(120),
                            ),
                            elevation: MaterialStateProperty.all(2.0),
                            backgroundColor:
                                MaterialStateProperty.all(kPrimaryColor),
                            shadowColor:
                                MaterialStateProperty.all(Colors.black38),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(20.0)))),
                        onPressed: () {
                          Get.offAll(const LoginScreen());
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(1.0),
                          child: Center(
                            child: Text(
                              'الرجـوع',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
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
        ));
  }
}
