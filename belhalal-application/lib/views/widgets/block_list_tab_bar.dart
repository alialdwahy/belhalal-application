import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:halal/constants/constants.dart';
import 'package:halal/controllers/app_controller.dart';
import 'package:halal/controllers/auth_controller.dart';
import 'package:halal/controllers/user_controller.dart';
import 'package:halal/models/person.dart';
import 'package:halal/models/user.dart';
import 'package:halal/views/screens/user_info.dart';

class BlockListTabBar extends StatefulWidget {
  const BlockListTabBar({Key? key}) : super(key: key);

  @override
  _BlockListTabBarState createState() => _BlockListTabBarState();
}

class _BlockListTabBarState extends State<BlockListTabBar> {
  final UserController _userConreoler = Get.put(UserController());
  final AthController _authConreoler = Get.put(AthController());
  final AppController _appController = Get.put(AppController());

  List<MyPerson> peopleIBlocked = <MyPerson>[];
  @override
  void initState() {
    getPeopleIBlocked();
    super.initState();
  }

  getPeopleIBlocked() async {
    EasyLoading.show(status: "... جاري التحميل");
    List<MyPerson> blockedPersons =
        await _userConreoler.getPeopleIBlocked(_authConreoler.userId.value);
    if (blockedPersons.isNotEmpty) {
         blockedPersons.forEach((element)async  {
        MyUser pers = await _userConreoler.getSpecificUserinfo(element.id!);
        if (pers !=null) {
         peopleIBlocked.add(MyPerson(id:pers.id ,imagePath:pers.imageUrl ,name:pers.name ));
           setState(() {});
        }
      });
    }
    setState(() {});
    EasyLoading.dismiss();
  }

  doDisBlockedForPerson(String disLikedPersonId) async {
    EasyLoading.show(status: "... جاري التحميل");
    await _userConreoler.doDisBlockedForPeople(
        _authConreoler.userId.value, disLikedPersonId);
    peopleIBlocked = [];
    peopleIBlocked.addAll(
        await _userConreoler.getPeopleIBlocked(_authConreoler.userId.value));
    setState(() {});
    EasyLoading.dismiss();
  }
  Future<MyUser?> getMyUser(String id) async{
    MyUser? myUser = await _userConreoler.getSpecificUserinfo(id);
    return myUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth:0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children:  [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
              onPressed: ()=>Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back,color:Colors.black,size: 25,),
                      ),
            ),
             const SizedBox(
              width: 50,
            ),
            const Icon(
              Icons.cancel_sharp,
              color: Colors.red,
            ),
            const SizedBox(
              width: 5,
            ),
            const Text(
              'قائمة المحظورين',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: peopleIBlocked.isNotEmpty
          ? ListView.builder(
              itemCount: peopleIBlocked.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: ()async {
                    MyUser? user= await getMyUser(peopleIBlocked[index].id!);
                    Get.to(() =>
                        UserInfo(myUser: user));
                  },
                  child: ListTile(
                    shape: const Border(
                      top: BorderSide(color: Colors.grey, width: 1),
                    ),
                    title: Text(peopleIBlocked[index].name ?? ""),
                    leading: peopleIBlocked[index].imagePath!.length > 250
                        ? CircleAvatar(
                            radius: 22,
                            backgroundImage: MemoryImage(base64Decode(
                                peopleIBlocked[index].imagePath!)),
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
                          child: const Text("إلغاء الحظر"),
                          value: 1,
                          onTap: () {
                            doDisBlockedForPerson(
                                peopleIBlocked[index].id.toString());
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

class Person {
  String? name;
  String? imagePath;
  Person(this.name, this.imagePath);
}
