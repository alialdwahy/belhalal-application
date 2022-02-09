import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:halal/chat/Screens/chat_screen.dart';
import 'package:halal/chat/widgets/message_pic_view.dart';
import 'package:halal/constants/constants.dart';
import 'package:halal/controllers/auth_controller.dart';
import 'package:halal/controllers/chat_controller.dart';
import 'package:halal/controllers/subscription_controller.dart';
import 'package:halal/controllers/user_controller.dart';
import 'package:halal/models/chat_room.dart';
import 'package:halal/models/person.dart';
import 'package:halal/models/user.dart';
import 'package:halal/utils/firebase_utils.dart';
import 'package:halal/views/screens/home_page.dart';
import 'package:logger/logger.dart';

// ignore: must_be_immutable
class UserInfo extends StatefulWidget {
  MyUser? myUser;

  UserInfo({Key? key, this.myUser}) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  TextStyle style1 = const TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
  final UserController _userController = Get.put(UserController());
  final AthController _authController = Get.put(AthController());
  final ChatController _chatConreoler = Get.put(ChatController());
  final SubscriptionController _subscriptionController =
      Get.put(SubscriptionController());
  bool? isBloked = false;
  bool? isLiked = false;

  ///check if i did blocked for this person or not
  isUserInMyBlockedUsers(String personId) async {
    isBloked = await _userController.isUserInMyBlockedBeople(
        _authController.userId.value, personId);
   // setState(() {});
  }

  isUserInMyLikesUsers(String personId) async {
    isLiked = await _userController.isUserInMyLikedBeople(
        _authController.userId.value, personId);
    setState(() {});
  }

  addRoom(String senderId, String myUserId, MyPerson person) async {
    await _chatConreoler.addRoom(ChatRoom(
      users: [senderId, myUserId],
    ));
    await _subscriptionController
        .increaseCurrentSupNumber(_authController.userId.value);
    Get.to(ChatScreen(
      person: person,
    ));
  }

  goToChatRoom(String senderId, String myUserId, MyPerson person) async {
    await _chatConreoler.getRoomIdByUser(senderId, myUserId);
    if (_chatConreoler.currentRoom.value != "") {
      Get.to(ChatScreen(person: person));
    } else {
      if (_userController.myUser.value.gendervalue == 'امراة' &&
          _subscriptionController.freeSubScription.value == true) {
        addRoom(senderId, myUserId, person);
      } else {
        if(isHide){
          addRoom(senderId, myUserId, person);
        }else{
          (_subscriptionController.mySubscription.value.currentSubNumber! <
              _subscriptionController.mySubscription.value.maxSubNumber!)
              ? addRoom(senderId, myUserId, person)
              : Get.snackbar("ناسف ", "الرجاء تجديد الاشتراك");
        }
      }
    }
  }

  checkIfUserSubscriptionExpired() async {
    await _subscriptionController
        .checkIfUserHaveFreeSubscription(_authController.userId.value);
  }

  bool isHide = false;
  @override
  void initState() {
    checkIfUserSubscriptionExpired();
    isUserInMyBlockedUsers(widget.myUser!.id.toString());
    isUserInMyLikesUsers(widget.myUser!.id.toString());
    super.initState();
    Logger().d("profile user ${widget.myUser?.toJson()}");
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if(Platform.isIOS) {
      FirebaseRef.instance.isHideWallet().then((value) {
        isHide = value;
        setState(() {});
      });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leading: GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: widget.myUser!.imageUrl!.length > 3
            ? GestureDetector(
              onTap: () {
                          Get.to(() => MessagePicView(
                                messageSrc: widget.myUser!.imageUrl!,
                              ));
                        },
              child: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(widget.myUser!.imageUrl!),
                ),
            )
            : const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/images/belhahaIcon.png'),
              ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ملف الزواج',
                  style: style1,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: height / 1.9,
              width: width / 1.4,
              child: Padding(
                padding: const EdgeInsets.only(top: 12.0,right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 20,
                          child: Text(
                            "${widget.myUser!.name}",
                            textAlign: TextAlign.right,
                          ),
                        ),
                        const SizedBox(
                          width: 70,
                        ),
                        SizedBox(
                          height: 30,
                          width: 80,
                          child: Text(
                            'الاسم',
                            textAlign: TextAlign.right,
                            style: style1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 20,
                          child: Text(
                            "${widget.myUser!.age}",
                            textAlign: TextAlign.right,
                          ),
                        ),
                        const SizedBox(
                          width: 70,
                        ),
                        SizedBox(
                          height: 30,
                          width: 80,
                          child: Text(
                            'العمر',
                            textAlign: TextAlign.right,
                            style: style1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 25,
                          child: Text(
                            "${widget.myUser!.country}",
                            textAlign: TextAlign.right,
                          ),
                        ),
                        const SizedBox(
                          width: 65,
                        ),
                        SizedBox(
                          height: 30,
                          width: 80,
                          child: Text(
                            'البلد',
                            textAlign: TextAlign.right,
                            style: style1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 20,
                          child: Text(
                            "${widget.myUser!.long}",
                            textAlign: TextAlign.right,
                          ),
                        ),
                        const SizedBox(
                          width: 70,
                        ),
                        SizedBox(
                          height: 30,
                          width: 80,
                          child: Text(
                            'الطول',
                            textAlign: TextAlign.right,
                            style: style1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 20,
                          child: Text(
                            "${widget.myUser!.weight}",
                            textAlign: TextAlign.right,
                          ),
                        ),
                        const SizedBox(
                          width: 70,
                        ),
                        SizedBox(
                          height: 30,
                          width: 80,
                          child: Text(
                            'الوزن',
                            textAlign: TextAlign.right,
                            style: style1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 20,
                          child: Text(
                            "${widget.myUser!.skinColor}",
                            textAlign: TextAlign.right,
                          ),
                        ),
                        const SizedBox(
                          width: 70,
                        ),
                        SizedBox(
                          height: 30,
                          width: 80,
                          child: Text(
                            'لون البشرة',
                            textAlign: TextAlign.right,
                            style: style1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 20,
                          child: Text(
                            "${widget.myUser!.job}",
                            textAlign: TextAlign.right,
                          ),
                        ),
                        const SizedBox(
                          width: 70,
                        ),
                        SizedBox(
                          height: 30,
                          width: 80,
                          child: Text(
                            'المهنة',
                            textAlign: TextAlign.right,
                            style: style1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 20,
                          child: Text(
                            "${widget.myUser!.marriedTypeValue}",
                            textAlign: TextAlign.right,
                          ),
                        ),
                        const SizedBox(
                          width: 70,
                        ),
                        SizedBox(
                          height: 30,
                          width: 80,
                          child: Text(
                            'نوع الزواج',
                            textAlign: TextAlign.right,
                            style: style1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                isBloked != true
                    ? IconButton(
                        icon: const Icon(
                          Icons.cancel,
                          size: 40,
                        ),
                        color: Colors.red,
                        onPressed: () async {
                          _userController.doDisLikeForPeople(
                              _authController.userId.value, widget.myUser!.id!);
                          _userController.blockPeople(
                              _authController.userId.value,
                              MyPerson(
                                  id: widget.myUser!.id,
                                  name: widget.myUser!.name,
                                  imagePath: widget.myUser!.imageUrl,
                                  token:  widget.myUser!.token,
                                  ));
                          await _userController
                              .getPeopleIBlocked(_authController.userId.value);

                          Get.offAll(Home(
                            selectedIndex: 0,
                          ));
                        },
                      )
                    : Container(),
                const SizedBox(
                  width: 20,
                ),
                TextButton(
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(2.0),
                      backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                      shadowColor: MaterialStateProperty.all(Colors.black38),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)))),
                  onPressed: () async {
                    await _subscriptionController
                        .getMySubscription(_authController.userId.value);
                    goToChatRoom(
                        _authController.userId.value,
                        widget.myUser!.id!,
                        MyPerson(
                            id: widget.myUser!.id,
                            name: widget.myUser!.name,
                            imagePath: widget.myUser!.imageUrl,
                            token: widget.myUser?.token.toString()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'بدء المحادثة',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        Icon(
                          Icons.chat_outlined,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                isLiked != true
                    ? IconButton(
                        icon: const Icon(
                          Icons.favorite,
                          size: 40,
                        ),
                        color: Colors.green,
                        onPressed: () {
                          _userController.doDisBlockedForPeople(
                              _authController.userId.value, widget.myUser!.id!);
                          _userController.LikedForPeople(
                              _authController.userId.value,
                              MyPerson(
                                  id: widget.myUser!.id,
                                  name: widget.myUser!.name,
                                  imagePath: widget.myUser!.imageUrl,
                                  token:  widget.myUser!.token,
                                  ));
                          Get.offAll(Home(
                            selectedIndex: 0,
                          ));
                        },
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
