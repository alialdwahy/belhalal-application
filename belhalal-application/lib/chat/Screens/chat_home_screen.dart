// ignore: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:halal/chat/widgets/favorait_contact.dart';
import 'package:halal/chat/widgets/recent_chats.dart';
import 'package:halal/constants/constants.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({Key? key}) : super(key: key);

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
       centerTitle:true,
       automaticallyImplyLeading :false,
       backgroundColor: kPrimaryColor,
       elevation: 0,
       title: Row(
         mainAxisAlignment: MainAxisAlignment.center,
         children: const[
            Icon(Icons.favorite,color:Colors.green,size: 22),
            SizedBox(width: 5,),
            Text(
              'الأشخاص المفضلين',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
         ],
       ),
      ),
      body: Column(
        children: <Widget>[   
          const FavoraitContact(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top:8.0,right: 5,left: 5),
              child: Container(
                decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Theme.of(context).accentColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    )),
                child: Column(
                  children:const [ 
                      Text(
                        'المحادثات',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                     RecentChats(),
                  ]  
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
