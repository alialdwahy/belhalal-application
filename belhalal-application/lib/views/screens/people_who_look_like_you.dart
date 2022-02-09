import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/instance_manager.dart';
import 'package:halal/constants/constants.dart';
import 'package:halal/controllers/auth_controller.dart';
import 'package:halal/controllers/subscription_controller.dart';
import 'package:halal/controllers/user_controller.dart';
import 'package:halal/models/user.dart';
import 'package:halal/views/screens/user_info.dart';
import 'package:get/get.dart';

class PeopleLooksLikeYou extends StatefulWidget {
  const PeopleLooksLikeYou({Key? key}) : super(key: key);

  @override
  _PeopleLooksLikeYouState createState() => _PeopleLooksLikeYouState();
}

class _PeopleLooksLikeYouState extends State<PeopleLooksLikeYou> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(
                width: 3,
              ),
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: kPrimaryColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(
                width: 15,
              ),
              const Text(
                'أشخاص توافقوا معك ',
                style: TextStyle(color: Colors.black, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                width: 15,
              ),
              Icon(Icons.star_purple500_sharp,
                  color: Colors.yellow[700], size: 50),
              const SizedBox(
                width: 3,
              ),
            ],
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.amber[50],
        width: double.infinity,
        height: height / 1.001,
        child: const GalaryViewImage(),
      ),
    );
  }
}

class GalaryViewImage extends StatefulWidget {
  const GalaryViewImage({Key? key}) : super(key: key);

  @override
  State<GalaryViewImage> createState() => _GalaryViewImageState();
}

class _GalaryViewImageState extends State<GalaryViewImage> {
  final AthController _athController = Get.put(AthController());
  final UserController _userController = Get.put(UserController());
  final SubscriptionController _subscriptionController =
      Get.put(SubscriptionController());
  List<MyUser>? myUsers = [];

  getUserLooksLikeYou() async {
    EasyLoading.show(status: "Loading..");
    await _subscriptionController
        .getMySubscription(_athController.userId.value);
    myUsers = await _userController.getUserLooksLikeYou(
        _athController.userId.value,
        _userController.myUser.value.age!,
        _subscriptionController.mySubscription.value.subType!);
    setState(() {});
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    getUserLooksLikeYou();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(top: 25, left: 20.0, right: 20.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.6,
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: myUsers!.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Get.to(UserInfo(
                myUser: myUsers![index],
              ));
            },
            child: myUsers![index].imageUrl!.length > 3
                ? Container(
                    height: height / 3,
                    width: width / 2.5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(myUsers![index].imageUrl!),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  )
                : Container(
                    height: height / 3,
                    width: width / 2.5,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/images/belhahaIcon.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    )),
          );
        },
      ),
    );
  }
}
