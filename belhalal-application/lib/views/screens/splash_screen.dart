import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:halal/controllers/app_controller.dart';
import 'package:halal/controllers/auth_controller.dart';
import 'package:halal/controllers/subscription_controller.dart';
import 'package:halal/controllers/user_controller.dart';
import 'package:halal/views/screens/bloked_account.dart';
import 'package:halal/views/screens/home_page.dart';
import 'package:halal/views/screens/login.dart';
import 'package:logger/logger.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AthController authController = Get.put(AthController());
  final UserController userController = Get.put(UserController());
  final AppController _appController = Get.put(AppController());
  final SubscriptionController _subscriptionController =
      Get.put(SubscriptionController());

  @override
  void initState() {
    Timer(const Duration(seconds: 3), () async {
      await authController.getUserIdFromLocalStorage();
      try {
        if(authController.userId.value != "") {
                      await userController.getUserInfo(authController.userId.value);
                      await userController.getUsercomplaints(authController.userId.value);
                      await userController.getPeopleIBlocked(authController.userId.value);
                      await _appController.getUsers();
                      await _subscriptionController.getMySubscription(authController.userId.value);
                      userController.myComplaint.value.count! <= 3
                          ? Get.offAll(Home(selectedIndex:0,))
                          : Get.offAll(const BlockedAcount());

            }else {Get.offAll(const LoginScreen());}
      } catch (e) {
        print(e);
        Get.offAll(const LoginScreen());
      }

    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/belhahalSplash.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
