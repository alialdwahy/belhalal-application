import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:halal/controllers/auth_controller.dart';
import 'package:halal/models/subscrip.dart';
import 'package:get/get.dart';
import 'package:halal/services/sub_service.dart';

class SubscriptionController extends GetxController {
  var mySubscription = Subscriptions().obs;
  var isExpired = false.obs;
  var freeSubScription = false.obs;
  final AthController _athController = Get.put(AthController());
  getMySubscription(String userId) async {
    mySubscription.value =
        await SubscriptionService.subscriptionService.getMySubscription(userId);
    update();
  }

  setMySubscription(String userId, Subscriptions subscriptions) async {
    await SubscriptionService.subscriptionService
        .setMySubscription(userId, subscriptions);
  }

  checkIfUserHaveFreeSubscription(String userId) async {
    await getMySubscription(userId);
    Subscriptions freeSub = await SubscriptionService.subscriptionService
        .getAppLunchedSubscriptionsDate();

    DateTime appDateLunched = freeSub.timeStamps!.toDate();
    Subscriptions ss = mySubscription.value;
    DateTime mySubDateTime = ss.timeStamps!.toDate();
    final difference = mySubDateTime.difference(appDateLunched).inDays;
    freeSubScription.value = difference < 180 ? true : false;
    update();
  }

  increaseCurrentSupNumber(String userId) async {
    mySubscription.value.currentSubNumber =
        mySubscription.value.currentSubNumber! + 1;
    update();
    await SubscriptionService.subscriptionService
        .setMySubscription(userId, mySubscription.value);
  }
}
