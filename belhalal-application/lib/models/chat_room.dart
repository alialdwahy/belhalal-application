// class ChatRoom {
//   String? chatRoomId;
//   List<String>? users;
//   List<ChatMessage>? chatMessage;

//   ChatRoom({this.chatRoomId, this.users, this.chatMessage});

//   ChatRoom.fromJson(Map<String, dynamic> json) {
//     chatRoomId = json['chatRoomId'];
//     users = json['users'].cast<String>();
//     if (json['chatMessage'] != null) {
//       chatMessage =<ChatMessage>[];
//       json['chatMessage'].forEach((v) {
//         chatMessage!.add( ChatMessage.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['chatRoomId'] = chatRoomId;
//     data['users'] = users;
//     if (chatMessage != null) {
//       data['chatMessage'] = chatMessage!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class ChatMessage {
//   String? sendBy;
//   String? message;
//   int? time;

//   ChatMessage({this.sendBy, this.message, this.time});

//   ChatMessage.fromJson(Map<String, dynamic> json) {
//     sendBy = json['sendBy'];
//     message = json['message'];
//     time = json['time'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['sendBy'] = sendBy;
//     data['message'] = message;
//     data['time'] = time;
//     return data;
//   }
// }
import 'package:get/get.dart';
import 'package:halal/controllers/user_controller.dart';

class ChatRoom {
  String? roomId;
  List<String>? users;

  ChatRoom({this.roomId, this.users});

  ChatRoom.fromJson(Map<String, dynamic> json) {
    roomId = json['RoomId'];
    users = json['users'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['RoomId'] = roomId;
    data['users'] = users;
    return data;
  }
}

class ChatMessage extends Comparable<ChatMessage>{
  String? id;
  String? senderId;
  String? senderName;
  String? senderImageUrl;
  String? message;
  String? timeInHour;
  int? timeInMilisecond;
  bool? isLiked;
  bool? unread;
  bool? isPic;
  String? messagePic;
  String? token;
  String? lastMessage;
  final UserController _userController = Get.put(UserController());

  ChatMessage(
      {this.id,
      this.senderId = "",
      this.senderName = "",
      this.senderImageUrl = "",
      this.message = "قل مرحبا",
      this.timeInMilisecond = 0000,
      this.timeInHour,
      this.isLiked = false,
      this.unread = true,
      this.isPic = false,
      this.messagePic = "",
      this.token="",
      this.lastMessage="",
      });

  ChatMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['senderId'];
    senderName = json['senderName'];
    senderImageUrl = json['senderImageUrl'];
    message = json['message'];
    timeInMilisecond = json['timeInMilisecond'];
    timeInHour = json['timeInHour'];
    isLiked = json['isLiked'];
    unread = json['unread'];
    isPic = json['isPic'];
    messagePic = json['messagePic'];
    token = json['token'];
    lastMessage = json['lastMessage'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id??"";
    data['senderId'] = senderId??"";
    data['senderName'] = senderName??"";
    data['senderImageUrl'] = senderImageUrl??"";
    data['message'] = message??"";
    data['timeInMilisecond'] = timeInMilisecond;
    data['timeInHour'] = timeInHour;
    data['isLiked'] = isLiked;
    data['unread'] = unread;
    data['isPic'] = isPic;
    data['messagePic'] = messagePic;
    data['token'] = token;
    data['lastMessage'] = lastMessage??"";
    return data;
  }

  @override
  int compareTo(ChatMessage other) {
    // TODO: implement compareTo
    return (other.timeInMilisecond.toString().compareTo(timeInMilisecond.toString()));
  }
}
