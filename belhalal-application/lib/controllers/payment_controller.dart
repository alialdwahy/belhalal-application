import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:halal/models/user.dart';
import 'package:halal/services/payment.service.dart';

class PaymentController extends GetxController{
 

  doPayment(String userId,Subtype subtype,String name,String amount,int paymentMethod){
  PaymentService.paymentService.pay(userId,subtype,name,amount,paymentMethod);
 }
}