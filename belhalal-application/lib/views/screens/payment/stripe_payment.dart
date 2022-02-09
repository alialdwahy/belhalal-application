import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:halal/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

class StripePaymentMethod {
  StripePaymentMethod._();
  static StripePaymentMethod stripePaymentMethod = StripePaymentMethod._();

  Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment(String amount ,Function subscription,Subtype subtype, String userId) async {
    try {
      paymentIntentData = await createPaymentIntent(
          amount, 'USD'); //json.decode(response.body);
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntentData!['client_secret'],
                  applePay: Stripe.instance.isApplePaySupported.value,
                  googlePay: true,
                  //testEnv: true,
                  testEnv: false,
                  style: ThemeMode.dark,
                  merchantCountryCode: 'US',
                  merchantDisplayName: 'ANNIE'))
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet(subscription, subtype,  userId);
    } catch (e, s) {
      Get.snackbar("فشل", "فشل العمليه");
      // print('exception:$e$s');
    }
  }

  displayPaymentSheet(Function subscription ,Subtype subtype, String userId) async {
    try {
      await Stripe.instance
          .presentPaymentSheet(
              parameters: PresentPaymentSheetParameters(
        clientSecret: paymentIntentData!['client_secret'],
        confirmPayment: true,
      ))
          .then((newValue) {
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text("paid successfully")));
             subscription(subtype: subtype, userId:userId,paymentId:paymentIntentData!['id'].toString());
/// TODO subscription method
        paymentIntentData = null;
      }).onError((error, stackTrace) {
        // print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: Get.context!,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      Get.snackbar("فشل", "فشل العمليه");

      // print('$e');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer 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',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body);
    } catch (err) {
      Get.snackbar("فشل", "فشل العمليه");
    }
  }

  calculateAmount(String amount) {
    final a = (double.parse(amount)) * 100;
    return a.toInt().toString();
  }
}
