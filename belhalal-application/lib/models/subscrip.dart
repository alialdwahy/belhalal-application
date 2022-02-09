import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:halal/models/user.dart';

class Subscriptions {
  Timestamp? timeStamps;
  Subtype? subType;
  String? paymnetId;
  int? maxSubNumber;
  int? currentSubNumber;
  Subscriptions(
      {this.timeStamps,
      this.subType,
      this.paymnetId,
      this.maxSubNumber=0,
      this.currentSubNumber=0});

  Subscriptions.fromJson(Map<String, dynamic> json) {
    timeStamps = json['timeStamps'];
    paymnetId = json['paymnetId'];
    maxSubNumber = json['maxSubNumber']??0;
    currentSubNumber = json['currentSubNumber']??0;

    subType = json['subType'] == Subtype.goldSubscription.toString()
        ? Subtype.goldSubscription
        : json['subType'] == Subtype.silverSubscription.toString()
            ? Subtype.silverSubscription
            : json['subType'] == Subtype.bronzeSubscription.toString()
                ? Subtype.bronzeSubscription
                : Subtype.nonSubscription;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['timeStamps'] = timeStamps;
    data['paymnetId'] = paymnetId;
    data['maxSubNumber'] =maxSubNumber;
    data['currentSubNumber'] = currentSubNumber;
    data['subType'] = subType.toString();

    return data;
  }
}
