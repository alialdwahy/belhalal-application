import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:halal/controllers/auth_controller.dart';
import 'package:halal/controllers/chat_controller.dart';
import 'package:halal/models/chat_room.dart';


class AllMessages extends StatefulWidget {
  const AllMessages({ Key? key }) : super(key: key);

  @override
  _AllMessagesState createState() => _AllMessagesState();
}

class _AllMessagesState extends State<AllMessages> {
 final ChatController _chatController = Get.put(ChatController());
 final AthController _authController = Get.put(AthController());
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
      stream: _chatController.getMyLastNewMessage(_authController.userId.value),
      builder: (BuildContext, AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> data){
        if (data.hasError) {
        } else if (data.hasData) {
          QuerySnapshot<Map<String,dynamic>> chatData = data.data!;
          List<ChatMessage> chats = chatData.docs.map((e) {
            Map<String,dynamic> map = e.data();
            return ChatMessage.fromJson(map);
          }).toList();
          return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (contex, index) {
                return InkWell(
                  onTap: () {
                    // PhoneRepository.repository.application =
                    //     applications[index];
                    //     Get.to(ApplicationInfoPage());
                  },
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.settings_applications_sharp),
                        title: Text(chats[index].senderName.toString()),
                        subtitle: Text(
                          chats[index].timeInHour.toString(),
                          style: TextStyle(color: Colors.blue[300]),
                        ),
                      ),
                     const Divider(),
                    ],
                  ),
                );
              });
        } else {
          return const Center(child: CircularProgressIndicator());
        }
        return const Center(child: Text("null"),);
      },
    );
  }
}

