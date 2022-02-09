import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:logger/logger.dart';

class PushNotification {
  PushNotification._();

  static final PushNotification instance = PushNotification._();

  ///todo you will need change Authorization :key= key from cloud messaging in firebase console
  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'key=AAAAqduBTp0:APA91bENC_7BgzKCa0gWmCT8HqMlom-Sfo6vUxjVBN3sAEaHcPbTLEeJfQqS964kspWEGMVpRSn9eb9uyufjGj0RtdqvyLYdP7XClddqjtDMkrFV_lWuY-9uEAlWd5ebt0lGk_2Pcu6G'
  };

  ///todo you will need change [title ,body ,to=FCM user Token , data//data you need to send]
  ///todo you must add it in method from parameter sendNotification("","","","")

  sendNotification({var title, var body, var to, var mapData}) async {
    try {
      var request =
          http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
      request.body = json.encode({
        "notification": {
          "title": "$title", //?? "you have recieved a message from user X",
          "body": "$body", //?? "testing body from post man",
          "sound": "default"
        },
        "android": {
          "priority": "HIGH",
          "notification": {
            "notification_priority": "PRIORITY_MAX",
            "sound": "default",
            "default_sound": true,
            "default_vibrate_timings": true,
            "default_light_settings": true
          }
        },
        "to":
            "$to", //?? "e9Ws0ldNrUCHjWHIhPg56q:APA91bGKQ42_dglUX5NyoFBLmnfCkwBLuoBQ_Rv59kh3KNO8M33Q-t_IfJgRB70ovEp6jQlbfSrqU-n8fGylZW9-m78QhfPeOGZfJpkdiJjJbWb46opI8aoFX_XhD7L9wN58kV3QxMxk",
        "priority": "high",
        "data": mapData ??
            {
              "type": "order",
              "id": "87",
              "click_action": "FLUTTER_NOTIFICATION_CLICK"
            }
      });
      request.headers.addAll(headers);
      http.StreamedResponse responses = await request.send();
      var response = await http.Response.fromStream(responses);
      if (response.statusCode < 400) {
        //todo success
        Logger().d("success push success");
      } else {
        //todo faile
        Logger().d(" push faile ${response.body}");
      }
    } on Exception catch (e) {
      // TODO
      Logger().d(" $e");
    }
  }
}
