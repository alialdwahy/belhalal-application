import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:halal/constants/constants.dart';
import 'package:halal/controllers/subscription_controller.dart';
import 'package:halal/models/user.dart';
import 'package:halal/views/widgets/subsicription_card.dart';
// ignore: must_be_immutable
class UserSubscriptions extends StatefulWidget {
  const UserSubscriptions({
    Key? key,
  }) : super(key: key);
  @override
  State<UserSubscriptions> createState() => _UserSubscriptionsState();
}
class _UserSubscriptionsState extends State<UserSubscriptions> {
  List<MyCards> myCards = [
    MyCards(
      borderColor: Colors.orangeAccent,
      subImage: 'assets/images/silver.png',
      subsMemberNum: 10,
      subsPrice: 9,
      subsType: 'برونزي',
      subtype: 3,
    ),
    MyCards(
      borderColor: Colors.grey,
      subImage: 'assets/images/silver.png',
      subsMemberNum: 20,
      subsPrice: 14,
      subsType: 'فضي',
      subtype: 2,
    ),
    MyCards(
      borderColor: Colors.yellow[400],
      subImage: 'assets/images/gold.png',
      subsMemberNum: 20,
      subsPrice: 29,
      subsType: 'ذهبي',
      subtype: 1,
    ),
  ];
  TextStyle txt1 = const TextStyle(
      color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold);
  final SubscriptionController _subscriptionController =
      Get.put(SubscriptionController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.red[50],
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, color: kPrimaryColor),
          )),
      backgroundColor: Colors.red[50], 
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 18.0, left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: height / 2.3,
                width: width,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: myCards.length,
                    itemBuilder: (BuildContext context, int index) {
                      return myCards[index];
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        width: 15,
                      );
                    }),
              ),
              Container(
                width: width,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  border: Border.all(
                    color: kPrimaryColor,
                    width: 2,
                  ),
                  color: Colors.white,
                ),
                child:Obx(()=> Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ' اشتراكك الحالي : ${_subscriptionController.mySubscription.value.subType == Subtype.goldSubscription ? 'ذهبي' : _subscriptionController.mySubscription.value.subType == Subtype.silverSubscription ? "فضي" : _subscriptionController.mySubscription.value.subType == Subtype.bronzeSubscription ? "برونزي" : "لا اشتراك"}  ',
                          style: txt1,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ' ${
                            _subscriptionController.mySubscription.value.maxSubNumber! >0? 
                            _subscriptionController.mySubscription.value.maxSubNumber! - _subscriptionController.mySubscription.value.currentSubNumber!:0
                             }  : عدد الأعضاء المتبقي للتواصل',
                          style: txt1,
                        ),
                      ],
                    ),
                  ],
                ),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
