import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:halal/constants/constants.dart';
import 'package:halal/controllers/app_controller.dart';
import 'package:halal/controllers/auth_controller.dart';
import 'package:halal/controllers/user_controller.dart';
import 'package:halal/models/person.dart';
import 'package:halal/models/user.dart';
import 'package:halal/views/screens/user_info.dart';

class LikeListTabBar extends StatefulWidget {
  const LikeListTabBar({Key? key}) : super(key: key);

  @override
  _LikeListTabBarState createState() => _LikeListTabBarState();
}

class _LikeListTabBarState extends State<LikeListTabBar> {
  final UserController _userConreoler = Get.put(UserController());
  final AthController _authConreoler = Get.put(AthController());
  final AppController _appController = Get.put(AppController());
  List<MyPerson> peopleILiked = <MyPerson>[];
  // MyUser? myUser;
  // bool isTrue = true;
  @override
  void initState() {
    getPeopleILiked();
    super.initState();
  }

  getPeopleILiked() async {
    EasyLoading.show(status: "... جاري التحميل");
    List<MyPerson> persons =
        await _userConreoler.getPeopleIlike(_authConreoler.userId.value);
    if (persons.isNotEmpty) {
      persons.forEach((element) async {
        MyUser pers = await _userConreoler.getSpecificUserinfo(element.id!);
        if (pers != null) {
          peopleILiked.add(
              MyPerson(id: pers.id, imagePath: pers.imageUrl, name: pers.name));
          setState(() {});
        }
      });
    }
    setState(() {});
    EasyLoading.dismiss();
  }

  doDisLikeForPerson(String disLikedPersonId) async {
    EasyLoading.show(status: "... جاري التحميل");
    await _userConreoler.doDisLikeForPeople(
        _authConreoler.userId.value, disLikedPersonId);
    peopleILiked = [];
    peopleILiked.addAll(
        await _userConreoler.getPeopleIlike(_authConreoler.userId.value));
    setState(() {});
    EasyLoading.dismiss();
  }

  Future<MyUser?> getMyUser(String id) async {
    MyUser? myUser = await _userConreoler.getSpecificUserinfo(id);
    return myUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 25,
                ),
              ),
            ),
            const SizedBox(
              width: 50,
            ),
            const Icon(
              Icons.favorite,
              color: Colors.green,
            ),
            const SizedBox(
              width: 5,
            ),
            const Text(
              'قائمة أعجبني',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: peopleILiked.isNotEmpty
          ? ListView.builder(
              itemCount: peopleILiked.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    MyUser? user = await getMyUser(peopleILiked[index].id!);
                    Get.to(() => UserInfo(myUser: user));
                  },
                  child: ListTile(
                    shape: const Border(
                      top: BorderSide(color: Colors.grey, width: 1),
                    ),
                    title: Text('${peopleILiked[index].name}'),
                    leading: peopleILiked[index].imagePath!.length > 250
                        ? CircleAvatar(
                            radius: 22,
                            backgroundImage: MemoryImage(base64Decode(
                                peopleILiked[index].imagePath! )),
                          )
                        : const CircleAvatar(
                            radius: 22,
                            backgroundImage:
                                AssetImage('assets/images/belhahaIcon.png'),
                          ),
                    trailing: PopupMenuButton(
                      icon: const Icon(Icons.more_horiz),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: const Text("إلغاء الإعجاب"),
                          value: 1,
                          onTap: () {
                            doDisLikeForPerson(
                                peopleILiked[index].id.toString());
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Scaffold(
              // ignore: avoid_unnecessary_containers
              body: Container(
                child: const Center(child: Text("لا يوجد بيانات")),
              ),
            ),
    );
  }
}
