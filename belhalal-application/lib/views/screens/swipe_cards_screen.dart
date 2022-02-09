// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import 'package:halal/controllers/app_controller.dart';
// import 'package:halal/controllers/auth_controller.dart';
// import 'package:halal/controllers/user_controller.dart';
// import 'package:halal/models/person.dart';
// import 'package:halal/views/screens/people_who_look_like_you.dart';
// import 'package:halal/views/screens/user_info.dart';
// import 'package:swipe_cards/swipe_cards.dart';

// class SwipeCardsScreen extends StatefulWidget {
//   const SwipeCardsScreen({Key? key}) : super(key: key);
//   @override
//   _SwipeCardsScreenState createState() => _SwipeCardsScreenState();
// }

// class _SwipeCardsScreenState extends State<SwipeCardsScreen> {
//  final  AthController _athController = Get.put(AthController());
//  final  UserController _userController = Get.put(UserController());
//   final  AppController _appController = Get.put(AppController());

//   getUsers() async {
//     EasyLoading.show(status: "Loading..");
//     await _appController.getUsers();
//     EasyLoading.dismiss();
//   }

//   @override
//   void initState() {
//     getUsers();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     return Scaffold(
//         // ignore: avoid_unnecessary_containers
//         body: Container(
//       child: Column(
//         children: [
//           Expanded(
//             flex: 1,
//             child: SizedBox(
//               height: height / 1.05,
//               width: width / 1.0005,
//               child: Obx(
//                 () => SwipeCards(
//                   matchEngine: _appController.matchEngine.value,
//                   itemBuilder: (BuildContext context, int index) {
//                     return Padding(
//                       padding: const EdgeInsets.only(top: 12.0),
//                       child: Stack(
//                         children: [
//                           _appController.myUsers[index].imageUrl != ""
//                               ? Container(
//                                   decoration: ShapeDecoration(
//                                     color: const Color(0xFFFEF9EB),
//                                     image: DecorationImage(
//                                         image: NetworkImage(_appController
//                                             .myUsers[index].imageUrl!),
//                                         fit: BoxFit.cover),
//                                     shape: const RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.only(
//                                           topLeft: Radius.circular(30.0),
//                                           topRight: Radius.circular(30)),
//                                     ),
//                                   ),
//                                   width: double.infinity,
//                                   alignment: Alignment.center,
//                                 )
//                               : Container(
//                                   decoration: const ShapeDecoration(
//                                     color: Colors.lightBlue,
//                                     image: DecorationImage(
//                                         // image: AssetImage("assets/images/person.png"),
//                                         image: AssetImage(
//                                             "assets/images/person.png"),
//                                         fit: BoxFit.contain),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.only(
//                                           topLeft: Radius.circular(30.0),
//                                           topRight: Radius.circular(30)),
//                                     ),
//                                   ),
//                                   width: double.infinity,
//                                   alignment: Alignment.center,
//                                 ),
//                           Align(
//                             alignment: Alignment.center,
//                             child: Padding(
//                               padding: const EdgeInsets.only(bottom: 60.0),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   Container(
//                                     color: Colors.transparent,
//                                     child: Padding(
//                                       padding:
//                                           const EdgeInsets.only(right: 50.0),
//                                       child: Column(
//                                         children: [
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.end,
//                                             children: [
//                                               Text(
//                                                   ' ${_appController.myUsers[index].name}  ',
//                                                   style: const TextStyle(
//                                                     color: Colors.white,
//                                                   )),
//                                               const Text('   الاسم',
//                                                   style: TextStyle(
//                                                     color: Colors.white,
//                                                   )),
//                                             ],
//                                           ),
//                                           const SizedBox(
//                                             height: 5,
//                                           ),
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.end,
//                                             children: [
//                                               Text(
//                                                   '  ${_appController.myUsers[index].age} ',
//                                                   style: const TextStyle(
//                                                     color: Colors.white,
//                                                   )),
//                                               const Text('   العمر',
//                                                   style: TextStyle(
//                                                     color: Colors.white,
//                                                   )),
//                                             ],
//                                           ),
//                                           const SizedBox(
//                                             height: 5,
//                                           ),
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.end,
//                                             children: [
//                                               GestureDetector(
//                                                   onTap: () {
//                                                     Get.to(UserInfo(
//                                                         myUser: _appController
//                                                             .myUsers[index]));
//                                                   },
//                                                   child: const Text(
//                                                       '  اضغط هنا ',
//                                                       style: TextStyle(
//                                                           color: Colors.white,
//                                                           fontWeight: FontWeight
//                                                               .bold))),
//                                               const Text('  لمعرفة المزيد ',
//                                                   style: TextStyle(
//                                                     color: Colors.white,
//                                                   )),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceEvenly,
//                                     children: [
//                                       IconButton(
//                                         onPressed: () {
//                                           MyPerson person = MyPerson(
//                                               id: _appController
//                                                   .myUsers[index].id,
//                                               imagePath: _appController
//                                                   .myUsers[index].imageUrl,
//                                               name: _appController
//                                                   .myUsers[index].name);
//                                           _userController.blockPeople(
//                                               _athController.userId.value,
//                                               person);
//                                           // add user to block list
//                                         },
//                                         icon: const Icon(Icons.cancel,
//                                             color: Colors.red, size: 50),
//                                       ),
//                                       IconButton(
//                                         onPressed: () {
//                                           Get.to(const PeopleLooksLikeYou());
//                                         },
//                                         icon: const Icon(
//                                             Icons.star_purple500_sharp,
//                                             color: Colors.yellow,
//                                             size: 50),
//                                       ),
//                                       IconButton(
//                                         onPressed: () {
//                                           MyPerson person = MyPerson(
//                                               id: _appController
//                                                   .myUsers[index].id,
//                                               imagePath: _appController
//                                                   .myUsers[index].imageUrl,
//                                               name: _appController
//                                                   .myUsers[index].name);
//                                           _userController.LikedForPeople(
//                                               _athController.userId.value,
//                                               person);
//                                           // Get.to(LikeListTabBar());
//                                         },
//                                         icon: const Icon(Icons.favorite,
//                                             color: Colors.green, size: 50),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
                       
                       
//                         ],//TODO:
//                       ),
//                     );
//                   },
//                   onStackFinished: () {
//                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                       content: Text("سيتم إضافة باقي الأعضاء قريبا"),
//                       duration: Duration(milliseconds: 700),
//                     ));
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ));
//   }
// }

// class Content {
//   final String? text;
//   final Color? color;
//   Content({this.text, this.color});
// }
