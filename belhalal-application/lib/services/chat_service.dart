import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:halal/fcm/app_fcm.dart';
import 'package:halal/models/chat_room.dart';
import 'package:halal/models/person.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ChatService {
  ChatService._();
  static ChatService chatService = ChatService._();
  // receave a map as a parameter
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection("users")
        .where('name', isEqualTo: searchField)
        .get();
  }

  /// add chat room
  Future<String> addChatRoom(ChatRoom chatRoom) async {
    ChatRoom newRoom = ChatRoom();
    newRoom = chatRoom;
    var documentSnapshot =
        await FirebaseFirestore.instance.collection("chatRoom").doc();
    newRoom.roomId = documentSnapshot.id;
    await documentSnapshot.set(chatRoom.toJson());
    await documentSnapshot.collection("chats")
    /*.add(ChatMessage(message:"قل مرحبا",timeInMilisecond: DateTime.now().millisecondsSinceEpoch,timeInHour: DateFormat('jm').format(DateTime.now())).toJson())*/;

    return newRoom.roomId!;
  }

  ///get room id by sender messages id
  Future<String> getRoomId(String senderId, String myId) async {
    String roomId = "";
    var querysnabshot = await FirebaseFirestore.instance
        .collection("chatRoom")
        //  .where("users",arrayContains:'CcgjiNLJk9abaAkhy4L8G4GE4xm2')
        .where("users", arrayContains: myId)
        .get()
        .catchError((e) {
      Get.snackbar("ناسف", "لم يتم انشاء محادثه");
    });
    querysnabshot.docs.forEach((element) {
      List users = element.data()["users"];
      if (users.contains(senderId)) {
        roomId = element.data()['RoomId'];
      }
    });
    return roomId;
  }

  ///get chat message by room id
  Stream<QuerySnapshot<Map<String, dynamic>>> getChatMessagesByRoomId(
      String roomId) {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(roomId)
        .collection("chats")
        .orderBy("timeInMilisecond")
        .snapshots();
  }

  /// get all my new message
  addMessageToMyNewMessage(String reseverId, ChatMessage message, {MyPerson? person}) async {
    //todo his for he
    var documentSnapshot = await FirebaseFirestore.instance
        .collection("myNewMessage")
        .doc(reseverId)
        .collection("myMessages")
        .doc(message.senderId);

    var jsons = message.toJson();
    // jsons.remove("token");
     jsons["token"] = AppFcm.myToken.toString();
    await documentSnapshot
        .set(jsons)
        .then((value) =>{})
        .catchError((e){Get.snackbar("ناسف", "لم يتم ارسال الرساله");});

    //todo his for me
    var documentSnapshotONe = await FirebaseFirestore.instance
        .collection("myNewMessage")
        .doc(message.senderId)
        .collection("myMessages")
        .doc(reseverId);

    var json = message.toJson();
    json["unread"] = false;
    json["senderId"] = person?.id;
    json["senderName"] = person?.name;
    json["senderImageUrl"] = person?.imagePath;
    json["token"] = person?.token;
    await documentSnapshotONe
        .set(json)
        .then((value) =>{})
        .catchError((e){Get.snackbar("ناسف", "لم يتم ارسال الرساله");});
  }

  deleteMessageFromMyNewMessageLis(String myId, String messageSenderId) async {
    await FirebaseFirestore.instance
        .collection("myNewMessage")
        .doc(myId)
        .collection('myMessages')
        .doc(messageSenderId)
        .delete()
        .then((value) {
    }).catchError((e) {
      Get.snackbar("ناسف", "لا يمكن حذف الرسالة");
    });
  }

  /// get all my last messages
  Stream<QuerySnapshot<Map<String, dynamic>>> getMyLastNewMessage(
      String myUserId) {
    return FirebaseFirestore.instance
        .collection("myNewMessage")
        .doc(myUserId)
        .collection("myMessages")
        .orderBy('timeInMilisecond',descending: true)
        .snapshots();
  }


// update user unread feaild in MyNewMessages
  updateUnreadMessageStatuse(String SenderId, String myUserId) {
    FirebaseFirestore.instance
        .collection("myNewMessage")
        .doc(myUserId)
        .collection("myMessages")
        .doc(SenderId)
        .update({'unread': false});
  }

  /// get add chats message that related with this room
  Stream<QuerySnapshot<Map<String, dynamic>>> getChats(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  ///add message to Room
  addMessageByRoomId(String chatRoomId, ChatMessage chatMessageData){
     FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData.toJson())
        .catchError((e) {
          Logger().e(e.toString());
          Get.snackbar("حدث خطأ", e.toString());
    });
  }

  Future<String> uploadImageChat(XFile xfile) async {
    String filePath = xfile.path;
    File file = File(filePath);
    String fileName = filePath.split('/').last;
    Reference reference = firebaseStorage.ref('chatImages/$fileName');
    TaskSnapshot taskSnapshot = await reference.putFile(file);
    String url = await reference.getDownloadURL();
    return url;
  }

  ///update user image
  uploadMessageImageChat(String userId, XFile file, String chatRoomId,
      ChatMessage chatMessage) async {
    String imageUrl = await uploadImageChat(file);
    await addMessageByRoomId(chatRoomId, chatMessage);
  }

  // getUserInfo(String email) async {
  //   return FirebaseFirestore.instance
  //       .collection("users")
  //       .where("email", isEqualTo: email)
  //       .get()
  //       .catchError((e) {
  //     print(e.toString());
  //   });
  // }

}
