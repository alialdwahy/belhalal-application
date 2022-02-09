// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:halal/chat/Screens/chat_screen.dart';
import 'package:halal/controllers/app_controller.dart';
import 'package:halal/controllers/auth_controller.dart';
import 'package:halal/controllers/chat_controller.dart';
import 'package:halal/controllers/email_message_controller.dart';
import 'package:halal/controllers/user_controller.dart';
import 'package:halal/models/chat_room.dart';
import 'package:get/get.dart';
import 'package:halal/models/person.dart';
import 'package:logger/logger.dart';

class RecentChats extends StatefulWidget {
  const RecentChats({Key? key}) : super(key: key);

  @override
  State<RecentChats> createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  final AthController _athController = Get.put(AthController());
  final ChatController _chatController = Get.put(ChatController());
  final UserController _userController = Get.put(UserController());
  final AppController _appController = Get.put(AppController());
  final EmailMessageController _emailMessageController =
      Get.put(EmailMessageController());
  @override
  void initState() {
    _chatController.getMyLastNewMessage(_athController.userId.value);
    super.initState();
  }

  blockUser(MyPerson myPerson) async {
    await _userController.doDisLikeForPeople(
        _athController.userId.value, myPerson.id!);
    await _userController.blockPeople(_athController.userId.value, myPerson);
    await _chatController.deleteMessageFromMyNewMessageLis(
        _athController.userId.value, myPerson.id!);
  }

  deleteUserMessageFromMyNewMessageList(String senderId) {
    _chatController.deleteMessageFromMyNewMessageLis(
        _athController.userId.value, senderId);
  }

  getUserInfo(String userId) async {
    return await _userController.getSpecificUserinfo(userId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _chatController.getMyLastNewMessage(_athController.userId.value),
        // ignore: avoid_types_as_parameter_names
        builder: (BuildContext, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> data) {
          if (data.hasError) {
          } else if (data.hasData) {
            QuerySnapshot<Map<String, dynamic>> chatData = data.data!;
            List<ChatMessage> chats = chatData.docs.map((e) {
              Map<String, dynamic> map = e.data();
              ChatMessage ms = ChatMessage.fromJson(map);
              return ms;
            }).toList();
            chats.sort();
            return Expanded(
              child: Container(
                decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Theme.of(context).accentColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    )),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  child: ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, int index) {
                      final ChatMessage chat = chats[index];
                     // Logger().d("message model ${chats[index].toJson()}");
                          
                      return GestureDetector(
                        onTap: () async {
                          if (chat.unread == true) {
                            await _chatController.updateUnreadMessageStatuse(
                                chat.senderId.toString(),
                                _athController.userId.value);
                          }

                          await _chatController.getRoomIdByUser(
                              chat.senderId.toString(),
                              _athController.userId.value);
                              
                          try {
                            Logger().d(chat.toJson());
                            Get.to(ChatScreen(
                              person: MyPerson(
                                  id: chat.senderId,
                                  imagePath: chat.senderImageUrl,
                                  name: chat.senderName,
                                  token:chat.token //chat.token this send notification for sinder itself
                                    /*"${_appController.myUsers.where((p) => p.id == "${chat.senderId}").first.token}"*/,
                                    ),
                            ));
                          } on Exception catch (e) {
                            // TODO 
                            print("error when go to chat room from recent chat" '$e');
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 2.0, right: 5.0, left: 5.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 1.0, vertical: 7.0),
                            decoration: BoxDecoration(
                                color: chat.unread!
                                    ? const Color(0xFFFFEFEE)
                                    : Colors.white,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                )),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                chat.senderImageUrl!.length > 3
                                    ? CircleAvatar(
                                        radius: 28.0,
                                        backgroundImage: NetworkImage(
                                            chat.senderImageUrl!.toString()),
                                      )
                                    : const CircleAvatar(
                                        radius: 28.0,
                                        backgroundImage: AssetImage(
                                            "assets/images/belhahaIcon.png"),
                                      ),
                                const SizedBox(
                                  width: 15.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chat.senderName!,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *0.46,
                                      child: Text("${chat.lastMessage??chat.message??"قل مرحبا"}",
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                ),
                                // const SizedBox(
                                //   width: 10,
                                // ),
                                Column(
                                  children: [
                                    Text(
                                      chat.timeInHour.toString(),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    chat.unread!
                                        ? Container(
                                            alignment: Alignment.center,
                                            width: 40,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(50)),
                                            ),
                                            child: const Text(
                                              'NEW',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        : const Text(''),
                                  ],
                                ),
                                PopupMenuButton(
                                  color: Colors.blueGrey[50],
                                  elevation: 10,
                                  iconSize: 5,
                                  icon: const Icon(
                                    Icons.more_horiz,
                                    color: Colors.grey,
                                    size: 25,
                                  ),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: const Text("حـظـر",
                                          textAlign: TextAlign.center),
                                      value: 1,
                                      onTap: () {
                                        blockUser(MyPerson(
                                            id: chat.senderId,
                                            imagePath: chat.senderImageUrl,
                                            name: chat.senderName));
                                      },
                                    ),
                                    PopupMenuItem(
                                      child: const Text("مـسـح",
                                          textAlign: TextAlign.center),
                                      value: 2,
                                      onTap: () {
                                        deleteUserMessageFromMyNewMessageList(
                                            chat.senderId!);
                                      },
                                    ),
                                    PopupMenuItem(
                                      child: const Text("شكوى",
                                          textAlign: TextAlign.center),
                                      value: 3,
                                      onTap: () async {
                                        await _emailMessageController
                                            .sendEmailOfComplain(
                                                _userController
                                                    .myUser.value.name!,
                                                chat.senderName!);
                                        await _userController
                                            .complaintAginestUserUser(
                                                chat.senderId!);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          }
          return const Center(
            child: Text("لايوجد محادثات أو لم تستقبل أي رد حتى الآن "),
          );
        });
  }
}
