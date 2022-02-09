import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:halal/models/chat_room.dart';
import 'package:halal/models/person.dart';
import 'package:halal/services/chat_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChatController extends GetxController {
  var currentRoom = "".obs;
  addRoom(ChatRoom chatRoom)async {
   currentRoom.value =  await  ChatService.chatService.addChatRoom(chatRoom);
  }

  addMessageByRoomId(String chatRoomId, ChatMessage chatMessage) {
     ChatService.chatService.addMessageByRoomId(chatRoomId, chatMessage);
  }

  getChats(String chatRoomId) {
    return ChatService.chatService.getChats(chatRoomId);
  }

  addMessageToMyNewMessage(String reseverId, ChatMessage message, {MyPerson? person}) async {
    await ChatService.chatService.addMessageToMyNewMessage(reseverId, message ,person:person);
  }

  getMyLastNewMessage(String myUserId) {
    return ChatService.chatService.getMyLastNewMessage(myUserId);
  }

  // ignore: non_constant_identifier_names
  updateUnreadMessageStatuse(String SenderId, String myUserId) {
    ChatService.chatService.updateUnreadMessageStatuse(SenderId, myUserId);
  }


/// get room id
  getRoomIdByUser(String senderId, myUserId) async {
    String value = await ChatService.chatService.getRoomId(senderId, myUserId);
    currentRoom.value = value;
    update();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatMessagesByRoomId() {
    return ChatService.chatService
        .getChatMessagesByRoomId(currentRoom.value.toString());
  }

  uploadMessageImageChat(String userId, XFile file, String chatRoomId,
      ChatMessage chatMessage) async {
    await ChatService.chatService
        .uploadMessageImageChat(userId, file, chatRoomId, chatMessage);
  }

  uploadImageChat(XFile file) async {
    return await ChatService.chatService.uploadImageChat(file);
  }

  deleteMessageFromMyNewMessageLis(String myId ,String messageSenderId)async{
    await ChatService.chatService.deleteMessageFromMyNewMessageLis(myId,messageSenderId);
  }

}
