import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:halal/chat/Screens/chat_home_screen.dart';
import 'package:halal/constants/constants.dart';
import 'package:halal/controllers/auth_controller.dart';
import 'package:halal/controllers/chat_controller.dart';
import 'package:halal/controllers/subscription_controller.dart';
import 'package:halal/controllers/user_controller.dart';
import 'package:halal/models/chat_room.dart';
import 'package:halal/views/screens/new_image_slider.dart';
import 'package:halal/views/screens/profile_screen.dart';
import 'package:halal/views/screens/search.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  int? selectedIndex = 0;
  Home({Key? key, this.selectedIndex}) : super(key: key);

  @override
  State<Home> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<Home> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final SubscriptionController _subscriptionController =
      Get.put(SubscriptionController());
  final AthController _athController = Get.put(AthController());
  final UserController _userController = Get.put(UserController());

  final List<Widget> _widgetOptions = <Widget>[
    const CarouselDemo(),
    const SearchScreen(),
    const ChatHomeScreen(),
    const Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }

  checkIfUserSubscriptionExpired() async {
    await _subscriptionController
        .checkIfUserHaveFreeSubscription(_athController.userId.value);
    if (_userController.myUser.value.gendervalue!.length == "امراة".length &&
        _subscriptionController.freeSubScription.value == true) {
      _widgetOptions[1] = const SearchScreen();
      setState(() {});
    } else {
      _widgetOptions[1] = _subscriptionController.isExpired.value == true
          // ignore: avoid_unnecessary_containers
          ? Container(
              child: const Center(child: Text("Your supscription Expired")),
            )
          : const SearchScreen();
      setState(() {});
    }
  }
  final ChatController _chatController = Get.put(ChatController());

  @override
  void initState() {
    //checkIfUserSubscriptionExpired();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(widget.selectedIndex!),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items:  <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),

          BottomNavigationBarItem(
            icon: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream:  _chatController.getMyLastNewMessage(_athController.userId.value),
              builder: (context,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasError) {
                  return const Icon(Icons.messenger_outline_sharp);
                } else if (snapshot.hasData) {
                  QuerySnapshot<Map<String, dynamic>> chatData = snapshot.data!;
                  List<ChatMessage> chats = chatData.docs.map((e) {
                    Map<String, dynamic> map = e.data();
                    ChatMessage ms = ChatMessage.fromJson(map);
                    return ms;
                  }).toList();
                  var list = chats.where((element) => element.unread != false)
                      .toList();
                  if (list.isEmpty) {
                    return const Icon(Icons.messenger_outline_sharp);
                  } else {
                    return Badge(badgeContent: Text(
                      "${list.length}", style: const TextStyle(color: Colors
                        .white),),
                        child: const Icon(Icons.messenger_outline_sharp));
                  }
                }
                return const Icon(Icons.messenger_outline_sharp);
              }
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        currentIndex: widget.selectedIndex!,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.blueGrey[400],
        onTap: _onItemTapped,
      ),
    );
 
  }
}
