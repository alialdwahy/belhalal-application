import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:halal/chat/widgets/message_pic_view.dart';
import 'package:halal/chat/widgets/view_pic_before_send.dart';
import 'package:halal/constants/constants.dart';
import 'package:halal/controllers/auth_controller.dart';
import 'package:halal/controllers/chat_controller.dart';
import 'package:halal/controllers/user_controller.dart';
import 'package:halal/fcm/app_fcm.dart';
import 'package:halal/models/chat_room.dart';
import 'package:halal/models/person.dart';
import 'package:halal/views/screens/user_info.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../puch_notification.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  late MyPerson? person;
  ChatScreen({Key? key, this.person}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final AthController _athController = Get.put(AthController());
  final _userController = Get.put(UserController());
  final ChatController _chatController = Get.put(ChatController());
  final TextEditingController _messageController = TextEditingController();
  // final ScrollController _scrollController = ScrollController();
  late final ScrollController     _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  var imagePath;

  buildMesage(message, isMe, context) {
    double _width = MediaQuery.of(context).size.width;
    Column column = Column(
      children: [
        Container(
            padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
            child: Align(
              alignment: isMe ? Alignment.topRight : Alignment.topLeft,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: _width / 1.5,
                ),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isMe ? const Color(0xFFFFEFEE) : Colors.blueGrey[100],
                  borderRadius: isMe
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(25.0),
                          bottomLeft: Radius.circular(15.0),
                        )
                      : const BorderRadius.only(
                          topRight: Radius.circular(15.0),
                          bottomRight: Radius.circular(15.0),
                          bottomLeft: Radius.circular(25.0),
                        ),
                ),
                child: message.isPic == true
                    ? GestureDetector(
                        onTap: () {
                          Get.to(() => MessagePicView(
                                messageSrc: '${message.messagePic}',
                              ));
                        },
                        child: Image.network(
                          message.messagePic!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Padding(
                      padding: const EdgeInsets.all(0.5),

                        child: Text(
                            message.message!,
                            maxLines: 100,
                            softWrap: true,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 0.5,
                            ),
                          ),

                    ),
              ),
            )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: isMe ? Alignment.topRight : Alignment.topLeft,
            child: Text(
              (message.timeInHour.toString() == ('null'))
                  ? ''
                  :DateFormat().add_jm().format(DateFormat("hh:mm a").parse(message.timeInHour.toString() ,true).toLocal()).toString()  ,
              style: const TextStyle(
                color: Colors.blueGrey,
                fontSize: 10.0,
                fontWeight: FontWeight.normal,
              ),
              textAlign: isMe ? TextAlign.end : TextAlign.start,
            ),
          ),
        )
      ],
    );
    return column;
  }

  sendMessage({String? newMessage}) async {
    bool isPic = false;
    String imageUrl = "";
    if (_image != null) {
      EasyLoading.show(status: "جاري الارسال..");
      imageUrl = await _chatController.uploadImageChat(_image!);
      _image = null;
      isPic = true;
    }
    ChatMessage mes = ChatMessage(
        message: newMessage ?? "",
        senderId: _athController.userId.value,
        senderName: _userController.myUser.value.name,
        senderImageUrl: _userController.myUser.value.imageUrl,
        timeInMilisecond: DateTime.now().microsecondsSinceEpoch,
        timeInHour: DateFormat('jm').format(DateTime.now().toUtc()),
        messagePic: imageUrl,
        isPic: isPic,
        token:widget.person?.token,
        lastMessage: isPic ? "تم ارسال مرفق":newMessage ?? "${_messageController.text}"
        );
    await _chatController.addMessageByRoomId(
        _chatController.currentRoom.value, mes);
    EasyLoading.dismiss();
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.bounceInOut);
    _messageController.text = '';
    _chatController.addMessageToMyNewMessage(widget.person!.id!, mes , person:widget.person);
    //TODO:
    Logger().d("msg_token${widget.person?.token}");
    PushNotification.instance.sendNotification(
        title: _userController.myUser.value.name,
        body: mes.message ?? 'صورة جديدة',
        to: "${widget.person?.token}",
        mapData: {
          "type": "chat",
          "id": _athController.userId.value,
          "imagePath":"${widget.person?.imagePath}",
          "name":"${widget.person?.name}",
          "token":"${widget.person?.token}",
          "click_action": "OPEN_CHAT_PAGE",
        });
    setState(() {});
  }

  _imgFromCamera() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
      imagePath = File(image!.path);
    });
    await Get.to(() => ViewPicBeforeSend(image: imagePath, send: sendMessage));
  }

  _imgFromGallery() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = image;
      imagePath = File(image!.path);
    });
    await Get.to(() => ViewPicBeforeSend(
          image: imagePath,
          send: sendMessage,
          isOk: false,
        ));
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            // ignore: avoid_unnecessary_containers
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text(
                        'معرض الصور',
                        textAlign: TextAlign.right,
                      ),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('الكاميرا', textAlign: TextAlign.right),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  buildMessageComposer() {
    return Container(
      height: 60,
      color: kPrimaryColor,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              _showPicker(context);
            },
            icon: const Icon(Icons.photo),
            iconSize: 25.0,
          ),
          Expanded(
              child: TextField(
                  textAlign: TextAlign.right,
                  controller: _messageController,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.text,
                  onChanged: (value) {},
                  decoration: const InputDecoration.collapsed(
                    hintText: '... أرسل رسالة',
                  ))),
          IconButton(
            onPressed: () {
              _messageController.text == "" && _image == null
                  ? null
                  : sendMessage(newMessage: _messageController.text);
              // hide keyBoard after click send button
            },
            icon: const Icon(Icons.send),
            iconSize: 25.0,
          ),
        ],
      ),
    );
  }

  bool isBlockMe = false;
  checkIfThisPersonBlockedMe() async {
    isBlockMe = await _userController.isUserInMyBlockedBeople(
        widget.person!.id!, _athController.userId.value);
    setState(() {});
  }

  getUserInfo(String userId) async {
    return await _userController.getUser(userId);
  }

  @override
  void initState() {
    checkIfThisPersonBlockedMe();
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      AppFcm.fcmInstance.isChatPageOpen.value = true;
      AppFcm.fcmInstance.userChatId.value = "${widget.person?.id.toString()}";
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
     super.dispose();
    AppFcm.fcmInstance.isChatPageOpen.value = false;
    AppFcm.fcmInstance.userChatId.value = "";
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        AppFcm.fcmInstance.isChatPageOpen.value = false;
        AppFcm.fcmInstance.userChatId.value = "";
        return Future.value(true);
      },
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _chatController.getChatMessagesByRoomId(),
          builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> data) {
            if (data.hasError) {
            } else if (data.hasData) {
              QuerySnapshot<Map<String, dynamic>> chatData = data.data!;
              List<ChatMessage> chats = chatData.docs.map((e) {
                Map<String, dynamic> map = e.data();
                return ChatMessage.fromJson(map);
              }).toList();

              /// scroll for the last item
              Timer(
                  const Duration(
                    milliseconds: 2,
                  ), () {
                _scrollController
                    .jumpTo(_scrollController.position.maxScrollExtent);
              });
              return GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: Scaffold(
                  appBar: AppBar(
                    elevation: 0.0,
                    backgroundColor: Colors.white,
                    title: Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () async {
                          Get.to(UserInfo(
                            myUser: await getUserInfo(widget.person!.id!),
                          ));
                        },
                        child: Row(
                          children: [
                            widget.person!.imagePath!.length > 3
                                ? CircleAvatar(
                                    radius: 18,
                                    backgroundImage:
                                        NetworkImage(widget.person!.imagePath!))
                                : const CircleAvatar(
                                    radius: 18,
                                    backgroundImage: AssetImage(
                                        "assets/images/belhahaIcon.png")),
                            Text(
                              '  ${widget.person!.name!}',
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    leading: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            )),
                      ],
                    ),
                  ),
                  body: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0),
                                )),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: ListView.builder(
                                  controller: _scrollController,
                                  itemCount: chats.length,
                                  padding: const EdgeInsets.only(top: 15.0),
                                  itemBuilder: (context, int index) {
                                    final ChatMessage message = chats[index];
                                    final bool isMe = message.senderId ==
                                        _athController.userId.value;
                                    return buildMesage(message, isMe, context);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        isBlockMe == false
                            ? buildMessageComposer()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: 60,
                                    width: MediaQuery.of(Get.context!).size.width,
                                    color: Colors.amber,
                                    child: const Center(
                                      child: Text("Your are blocked"),
                                    ),
                                  )
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const Center(
              child: Text("Empty"),
            );
          }),
    );
  }
}
