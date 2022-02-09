import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/instance_manager.dart';
import 'package:halal/controllers/auth_controller.dart';
import 'package:halal/controllers/subscription_controller.dart';
import 'package:halal/controllers/user_controller.dart';
import 'package:halal/models/subscrip.dart';
import 'package:halal/models/user.dart';
import 'package:halal/services/user_service.dart';
import 'package:get/get.dart';
import 'package:halal/views/screens/payment/paypal_payment.dart';
import 'package:halal/views/screens/payment/stripe_payment.dart';

class PaymentService {
  PaymentService._();
  static PaymentService paymentService = PaymentService._();
  final SubscriptionController _subscriptionController =
      Get.put(SubscriptionController());
  final AthController _athController = Get.put(AthController());
  final UserController _userController = Get.put(UserController());

  setSubscription({Subtype? subtype, String? userId, String? paymentId}) async {
    await _subscriptionController.setMySubscription(
      _athController.userId.value,
      Subscriptions(
        subType: subtype,
        timeStamps: Timestamp.fromDate(DateTime.now()),
        paymnetId: paymentId,
        maxSubNumber: subtype == Subtype.goldSubscription
            ? 1000
            : subtype == Subtype.silverSubscription
                ? 20
                : subtype == Subtype.bronzeSubscription
                    ? 10
                    : subtype == Subtype.nonSubscription
                        ? 0
                        : 0,
      ),
    );
    await UserService.userService.updateUserSupType(userId!, subtype!);
    await _userController.getUserInfo(_athController.userId.value);
    await _subscriptionController.getMySubscription(userId);
  }

  /// pay by using paybal
  payWithPaybal(String userId, Subtype subtype, String name, String amount) {
    Navigator.of(Get.context!).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaypalPayment(
            itemName: name,
            totalPrice: amount,
            onFinish: (id) async {
              if (id.toString().length > 1) {
                await setSubscription(
                    subtype: subtype, userId: userId, paymentId: id);
                EasyLoading.dismiss();
              } else {
                Get.snackbar("فشلت العملية", "لم تتم العملية بنجاح");
              }
            }),
      ),
    );
  }

//// pay by using Stripe
  payWithStripe(
    String amount,
    String userId,
    Subtype subtype,
  ) {
    StripePaymentMethod.stripePaymentMethod
        .makePayment(amount, setSubscription, subtype, userId);
  }

  /// pay
  pay(String userId, Subtype subtype, String name, String amount,
      int paymentMethod) async {
    await _subscriptionController.getMySubscription(userId);

    paymentMethod == 1
        ? payWithPaybal(
            userId,
            subtype,
            name,
            amount,
          )
        : payWithStripe(amount, userId, subtype); 
        
  await _subscriptionController
        .getMySubscription(_athController.userId.value);  }
}
