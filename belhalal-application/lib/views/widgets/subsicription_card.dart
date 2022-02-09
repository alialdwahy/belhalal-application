import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:halal/constants/constants.dart';
import 'package:halal/controllers/auth_controller.dart';
import 'package:halal/controllers/payment_controller.dart';
import 'package:halal/controllers/subscription_controller.dart';
import 'package:halal/models/user.dart';
import 'package:halal/services/payment.service.dart';
import 'package:logger/logger.dart';
import 'package:pay/pay.dart';

// ignore: must_be_immutable
class MyCards extends StatefulWidget {
  MyCards({
    Key? key,
    required this.borderColor,
    required this.subsType,
    required this.subsPrice,
    required this.subImage,
    required this.subsMemberNum,
    required this.subtype,
  }) : super(key: key);

  final Color? borderColor;
  final String? subsType;
  final int? subsPrice;
  final String? subImage;
  final int? subsMemberNum;
  int? subtype;

  @override
  State<MyCards> createState() => _MyCardsState();
}

class _MyCardsState extends State<MyCards> {
  final AthController _authController = Get.put(AthController());
  final PaymentController _paymentController = Get.put(PaymentController());
  final SubscriptionController _subscriptionController =
      Get.put(SubscriptionController());
  static int paymentMethod = 1; //1)paypal 2)stripe
  var paymentItemsList = <PaymentItem>[];
  Pay _pay = Pay.withAssets(["apple_pay.json"]);

  getMethod() {
    switch (widget.subtype) {
      case 1:
        return GoldOnPressed();
      case 2:
        return SilverOnPressed();
      case 3:
        return PronzOnPressed();
      default:
        return print('');
    }
  }

/*
  simbleDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: const Text(':الدفع باستخدام',textAlign: TextAlign.right,),
              children: <Widget>[
              /*  SimpleDialogOption(
                  onPressed: () {
                    setState(() {
                      paymentMethod = 1;
                      Navigator.pop(context);
                      getMethod();
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                      SafeArea(
                        child: SizedBox(
                          width: 80,height:40,
                          child: SvgPicture.asset('assets/images/paypal.svg'), //Image.asset('assets/images/cardPayment.png',
                          // alignment: Alignment.centerRight,
                          // height: 20,
                          // width: 80,

                        ),
                      ),
                      const Text('باي بال',style: TextStyle(fontWeight:FontWeight.bold),),
                     ], ),
                  ),
               */
                SimpleDialogOption(
                  onPressed: () {
                    setState(() {
                      paymentMethod = 2;
                      Navigator.pop(context);
                      getMethod();
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                      SafeArea(
                        child: SizedBox(
                          width: 80,height:40,
                          child: SvgPicture.asset('assets/images/cardPayment.svg'),
                        ),
                      ),
                      const Text('البطاقة',style: TextStyle(fontWeight:FontWeight.bold),),
                     ], ),

                )
              ]);
        })) {
    }
  }
*/
  // ignore: non_constant_identifier_names
  SilverOnPressed({bool? withApple = false, paymentId}) async {
    await _subscriptionController
        .getMySubscription(_authController.userId.value);
    if (_subscriptionController.mySubscription.value.subType ==
            Subtype.silverSubscription &&
        _subscriptionController.mySubscription.value.currentSubNumber! <
            _subscriptionController.mySubscription.value.maxSubNumber!) {
      Get.snackbar("تنبيه", "لديك اشتراك بالفعل");
    } else {
      if (withApple!) {
        PaymentService.paymentService.setSubscription(
          userId: _authController.userId.value,
          paymentId: paymentId,
          subtype: Subtype.silverSubscription,
        );
      } else {
        await _paymentController.doPayment(
            _authController.userId.value,
            Subtype.silverSubscription,
            'silversubscription',
            '14.99',
            paymentMethod);
      }
    }
  }

  // ignore: non_constant_identifier_names

  GoldOnPressed({bool? withApple = false, paymentId}) async {
    await _subscriptionController
        .getMySubscription(_authController.userId.value);

    if (_subscriptionController.mySubscription.value.subType ==
            Subtype.goldSubscription &&
        _subscriptionController.mySubscription.value.currentSubNumber! <
            _subscriptionController.mySubscription.value.maxSubNumber!) {
      Get.snackbar("تنبيه", "لديك اشتراك بالفعل");
    } else {
      if (withApple!) {
        PaymentService.paymentService.setSubscription(
            userId: _authController.userId.value,
            paymentId: paymentId,
            subtype: Subtype.goldSubscription);
      } else {
        await _paymentController.doPayment(
            _authController.userId.value,
            Subtype.goldSubscription,
            'goldSubscription',
            '29.99',
            paymentMethod);
      }
    }
  }

  PronzOnPressed({bool? withApple = false, paymentId}) async {
    await _subscriptionController
        .getMySubscription(_authController.userId.value);
    if (_subscriptionController.mySubscription.value.subType ==
            Subtype.bronzeSubscription &&
        _subscriptionController.mySubscription.value.currentSubNumber! <
            _subscriptionController.mySubscription.value.maxSubNumber!) {
      Get.snackbar("تنبيه", "لديك اشتراك بالفعل");
    } else {
      if (withApple!) {
        PaymentService.paymentService.setSubscription(
          userId: _authController.userId.value,
          paymentId: paymentId,
          subtype: Subtype.bronzeSubscription,
        );
      } else {
        await _paymentController.doPayment(
            _authController.userId.value,
            Subtype.bronzeSubscription,
            'bronzeSubscription',
            '9.99',
            paymentMethod);
      }
    }
  }

  Widget get appleBtn => InkWell(
        onTap: () async {
          if (widget.subsType == "ذهبي") {
            var data = await _pay.showPaymentSelector(paymentItems: const [
              PaymentItem(
                label: 'goldSubscription',
                amount: '29.99',
                status: PaymentItemStatus.final_price,
              )
            ]);
            String tokenToBeSentToCloud = data["token"];
            try {
              if (!GetUtils.isNull(tokenToBeSentToCloud)) {
                GoldOnPressed(withApple: true, paymentId: tokenToBeSentToCloud);
              } else {
                Get.snackbar("Error", data["message"]);
              }
            } on Exception catch (e) {
              // TODO
              Logger().d(e.toString());
            }
          } else if (widget.subsType == "فضي") {
            var data = await _pay.showPaymentSelector(paymentItems: const [
              PaymentItem(
                label: 'silversubscription',
                amount: '14.99',
                status: PaymentItemStatus.final_price,
              )
            ]);
            String tokenToBeSentToCloud = data["token"];
            try {
              if (!GetUtils.isNull(tokenToBeSentToCloud)) {
                SilverOnPressed(
                    withApple: true, paymentId: tokenToBeSentToCloud);
              } else {
                Get.snackbar("Error", data["message"]);
              }
            } on Exception catch (e) {
              // TODO
              Logger().d(e.toString());
            }
          } else {
            var data = await _pay.showPaymentSelector(paymentItems: const [
              PaymentItem(
                label: 'bronzeSubscription',
                amount: '9.99',
                status: PaymentItemStatus.final_price,
              )
            ]);
            String tokenToBeSentToCloud = data["token"];
            try {
              if (!GetUtils.isNull(tokenToBeSentToCloud)) {
                PronzOnPressed(
                    withApple: true, paymentId: tokenToBeSentToCloud);
              } else {
                Get.snackbar("Error", data["message"]);
              }
            } on Exception catch (e) {
              // TODO
              Logger().d(e.toString());
            }
          }
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(
            width: 50,
          ),
          Expanded(
              child: Text(
            "Pay",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          )),
          Expanded(
              child: SvgPicture.asset(
            "assets/images/apple.svg",
            color: Colors.white,
            width: 24,
            height: 24,
          )),
          const SizedBox(
            width: 50,
          ),
        ]),
      );

  //   ApplePayButton(
  //     paymentConfigurationAsset: 'apple_pay.json',
  //     childOnError:  Text("not supported"),
  //     onError: (error) {
  //       Get.snackbar("Error", "${error?.toString()}");
  //     },
  //     paymentItems:paymentItemsList
  // /*[
  //       widget.subsType == 1
  //           ? const PaymentItem(
  //               label: 'goldSubscription',
  //               amount: '29.99',
  //               status: PaymentItemStatus.final_price,
  //             )
  //           : widget.subsType == 2
  //               ? const PaymentItem(
  //                   label: 'silversubscription',
  //                   amount: '14.99',
  //                   status: PaymentItemStatus.final_price,
  //                 )
  //               : const PaymentItem(
  //                   label: 'bronzeSubscription',
  //                   amount: '9.99',
  //                   status: PaymentItemStatus.final_price,
  //                 )
  //     ]*/,
  //     onPressed: onApplePayClick,
  //     style: ApplePayButtonStyle.black,
  //     type: ApplePayButtonType.checkout,
  //     margin: const EdgeInsets.only(top: 15.0),
  //     onPaymentResult: onApplePayResult,
  //     loadingIndicator: const Center(
  //       child: CircularProgressIndicator(),
  //     ),
  //   );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 230,
      child: TextButton(
          style: ButtonStyle(
            alignment: Alignment.center,
            side: MaterialStateProperty.all(
              BorderSide(color: widget.borderColor!, width: 3),
            ),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0))),
          ),
          onPressed: () async {
            if (Platform.isAndroid) {
              setState(() {
                paymentMethod = 2;
                //Navigator.pop(context);
                getMethod();
              });
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'إشتراك ${widget.subsType}',
                style: const TextStyle(
                    color: kPrimaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                '\$${widget.subsPrice}.99',
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
              const SizedBox(
                height: 5,
              ),
              Image.asset(
                '${widget.subImage}',
                width: 50,
              ),
              const SizedBox(
                height: 20,
              ),
              widget.subtype == 1
                  ? const Text(
                      'التواصل مع عدد\n مفتوح من الأعضاء \nرسائل مباشرة',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    )
                  : Text(
                      'التواصل مع ${widget.subsMemberNum} من الأعضاء\n رسائل مباشرة',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                    ),
              if (Platform.isIOS) ...[
                const SizedBox(
                  height: 30,
                ),
                Container(
                    width: 180,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: appleBtn),
              ],
            ],
          )),
    );
  }

  // void onApplePayResult(paymentResult) {
  //   switch (widget.subtype) {
  //     case 1:
  //       return GoldOnPressed(
  //           withApple: true, paymentId: "${paymentResult.toString()}");
  //     case 2:
  //       return SilverOnPressed(
  //           withApple: true, paymentId: "${paymentResult.toString()}");
  //     case 3:
  //       return PronzOnPressed(
  //           withApple: true, paymentId: "${paymentResult.toString()}");
  //     default:
  //       return print('');
  //   }
  // }

  // void onApplePayClick() async {
  //   await _subscriptionController
  //       .getMySubscription(_authController.userId.value);
  //   if (widget.subsType == 1) {
  //     //GoldOnPressed
  //     paymentItemsList.clear();
  //     paymentItemsList.add(const PaymentItem(
  //       label: 'goldSubscription',
  //       amount: '29.99',
  //       status: PaymentItemStatus.final_price,
  //     ));
  //     if (_subscriptionController.mySubscription.value.subType ==
  //             Subtype.goldSubscription &&
  //         _subscriptionController.mySubscription.value.currentSubNumber! <
  //             _subscriptionController.mySubscription.value.maxSubNumber!) {
  //       Get.snackbar("تنبيه", "لديك اشتراك بالفعل");
  //       return;
  //     }
  //   } else if (widget.subsType == 2) {
  //     //SilverOnPressed
  //     paymentItemsList.clear();
  //     paymentItemsList.add(const PaymentItem(
  //       label: 'silversubscription',
  //       amount: '14.99',
  //       status: PaymentItemStatus.final_price,
  //     ));
  //     if (_subscriptionController.mySubscription.value.subType ==
  //             Subtype.silverSubscription &&
  //         _subscriptionController.mySubscription.value.currentSubNumber! <
  //             _subscriptionController.mySubscription.value.maxSubNumber!) {
  //       Get.snackbar("تنبيه", "لديك اشتراك بالفعل");
  //       return;
  //     }
  //   } else if (widget.subsType == 3) {
  //     //PronzOnPressed
  //     paymentItemsList.clear();
  //     paymentItemsList.add(const PaymentItem(
  //       label: 'bronzeSubscription',
  //       amount: '9.99',
  //       status: PaymentItemStatus.final_price,
  //     ));
  //     if (_subscriptionController.mySubscription.value.subType ==
  //             Subtype.bronzeSubscription &&
  //         _subscriptionController.mySubscription.value.currentSubNumber! <
  //             _subscriptionController.mySubscription.value.maxSubNumber!) {
  //       Get.snackbar("تنبيه", "لديك اشتراك بالفعل");
  //       return;
  //     }
  //   } else {}
  // }
}
