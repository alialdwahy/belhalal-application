import 'dart:async';
import 'package:belhalal_update/screen/account/login_page.dart';
import 'package:belhalal_update/screen/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final userdate = GetStorage();

  @override
  void initState() {
    // TODO: implement initState
    //here determine the number of seconds for splash screen
    super.initState();
    userdate.writeIfNull('isLogged', false);
    Future.delayed(Duration(seconds: 3), () async {
      //call function here
      checkiflogged();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          //image backgraound here
          image: DecorationImage(
            image: AssetImage("assets/images/belhahalSplash.png"),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }

//this is the function transfer to the other widget
  void checkiflogged() {
    userdate.read('isLogged')


        ?     Get.offAll(() =>  HomePage())

        : Get.offAll(() => Login());
  }
}
