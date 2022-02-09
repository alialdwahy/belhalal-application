import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:halal/models/subscrip.dart';
import 'package:halal/models/user.dart';

class SubscriptionService {
  SubscriptionService._();
  static SubscriptionService subscriptionService = SubscriptionService._();

  Future<Subscriptions> getMySubscription(String userId) async {
    try {
      var documentSnapshot = await FirebaseFirestore.instance
          .collection("subscriptions")
          .doc(userId)
          .get();
      var userMap = documentSnapshot.data() as Map<String, dynamic>;
      return Subscriptions.fromJson(userMap);
    } catch (e) {
      return Subscriptions(timeStamps: Timestamp(00,00),subType: Subtype.nonSubscription);
    }
  }

  setMySubscription(String userId, Subscriptions subscriptions) async {
    await FirebaseFirestore.instance
        .collection("subscriptions")
        .doc(userId)
        .set(subscriptions.toJson());
       
  }

   Future<Subscriptions> getAppLunchedSubscriptionsDate() async {
    try {
      var documentSnapshot = await FirebaseFirestore.instance
          .collection("subscriptions")
          .doc('appLunchedDate')
          .get();
      var userMap = documentSnapshot.data() as Map<String, dynamic>;
      return Subscriptions.fromJson(userMap);
    } catch (e) {
      return Subscriptions(timeStamps: Timestamp(00,00),subType: Subtype.nonSubscription);
    }
  }


 
}
