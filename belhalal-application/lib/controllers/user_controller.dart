import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:halal/models/complaint.dart';
import 'package:halal/models/person.dart';
import 'package:halal/models/user.dart';
import 'package:halal/services/user_service.dart';
import 'package:halal/views/screens/pin_code_fields.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/src/utils/phone_number.dart';
import 'package:logger/logger.dart';

class UserController extends GetxController {
  var myUser = MyUser().obs;
  var searchedUsers = <MyUser>[].obs;
  var myComplaint = Complaint().obs;
  var myBlockedUserId = <String>[].obs;
  var myLikedUsers = <MyPerson>[].obs;
  var tabValue = 0;
  var isoCode = "0";
  var userNumber = "0";
  getUserInfo(String userId) async {
    myUser.value = await UserService.userService.getUserInfo(userId);
    update();
  }
  
  Future<MyUser> getSpecificUserinfo(String userId) async {
    return await UserService.userService.getSpecificUserinfo(userId);
  }

  Future<MyUser> getUser(String userId) async {
    return await UserService.userService.getUserInfo(userId);
  }
getUserImage(String userId){
  return UserService.userService.getUserImage(userId);
}
  getBlockedUserIds(blokedUsers) {
    blokedUsers.forEach((element) {
      myBlockedUserId.value.add(element.id!);
    });
  }

  updateUserInfo(String userId, MyUser myUser) async {
    await UserService.userService.updateUser(userId, myUser);
  }

  updateUserPic(String userId, XFile file) async {
    await UserService.userService.updateUserImage(userId, file);
  }

   getPeopleIlike(String userId) async {
    return await UserService.userService.getPeopleIlike(userId);
  }
  updatePeopleILiked(String userId)async{
    myLikedUsers.value = await UserService.userService.getPeopleIlike(userId);
  }

  doDisLikeForPeople(String userId, String disLikePersonId) async {
    await UserService.userService.doDisLikePeople(userId, disLikePersonId);
  }

  getPeopleIBlocked(String userId) async {
    List<MyPerson> blokedUsers =
        await UserService.userService.getPeopleIBlocked(userId);
    getBlockedUserIds(blokedUsers);
    update();
    return blokedUsers;
  }

  doDisBlockedForPeople(String userId, String disLikePersonId) async {
    await UserService.userService.doDisBlockedPeople(userId, disLikePersonId);
  }

  searchAboutSpesificUser(
      String uId, int fromAge, int toAge, String countryName) async {
    List<MyUser> users = await UserService.userService
        .searchAgeAndCountryName(uId, fromAge, toAge, countryName);
    return users
        .where((element) => element.gendervalue != myUser.value.gendervalue)
        .where((element) => !myBlockedUserId.contains(element.id))
        .toList();
  }



  getAllPeople(String userId, String myGenderValue) async{
  UserService.userService.getAllPeople(userId,myGenderValue,myBlockedUserId);
  }

  LikedForPeople(String myId, MyPerson person) async {
    await UserService.userService.likedPeople(myId, person);
  }

  blockPeople(String myId, MyPerson person) async {
    await UserService.userService.blockPeople(myId, person);
  }

  Future<bool> isUserInMyBlockedBeople(String myUserId, String personId) async {
    return await UserService.userService
        .checkIfUserInMyBlockedBeople(myUserId, personId);
  }

  Future<bool> isUserInMyLikedBeople(String myUserId, String personId) async {
    return await UserService.userService
        .checkIfUserInMyLikedBeople(myUserId, personId);
  }

  Future<List<MyUser>> getUserLooksLikeYou(
      String uId, int age, Subtype subtype) async {
    return await UserService.userService.getUserLooksLikeYou(uId, age, subtype);
  }

  Future<bool> checkIfthisEmailIsAlreadyExist(String email) async {
    return await UserService.userService.checkIfthisEmailIsAlreadyExist(email);
  }

  Future<String> getUserEmailByName(String userName) async {
    return await UserService.userService.getUserEmailByName(userName);
  }

  complaintAginestUserUser(String userId) async {
    return await UserService.userService.complaintAginestUserUser(userId);
  }

  getUsercomplaints(String userId) async {
    myComplaint.value = await UserService.userService.getUsercomplaints(userId);
    update();
  }
   deleteUserCurrentUser(String userId)async{
    await UserService.userService.deleteUser(userId);
  }

  void currentTabValue(int value) {
    //if value == 0 main mobile else main email
    Logger().d(value);
    tabValue = value;
    update();
  }

  //country
  void saveCountryIsoCod(PhoneNumber userNumber) {
     isoCode = userNumber.toString();
     update();
  }

  void phoneNumber(PhoneNumber userNumber) {
    Logger().d(userNumber.phoneNumber.toString());
    this.userNumber = userNumber.phoneNumber.toString();
    update();
  }

  void signInWithMobile() async{
    EasyLoading.show(status: "...الرجاء الانتظار");
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: userNumber,
      verificationCompleted: (PhoneAuthCredential credential)async {
        //add sign in code here just android
        // Logger().d("in1");
        // var userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        // if(userCredential.user != null){
          //todo go to pin code page
          Get.to( PinCodeVerificationScreen(phoneNumber:userNumber.toString()));
          EasyLoading.dismiss();
        // }else{
        //   EasyLoading.dismiss();
        // }
      },
      verificationFailed: (FirebaseAuthException e) {
        Get.snackbar("خطاء", e.message.toString());
      },
      codeSent: (String verificationId, int? resendToken) async{
        // Update the UI - wait for the user to enter the SMS code
        String smsCode = 'xxxx';
        Logger().d("in2");
        // Create a PhoneAuthCredential with the code
        // PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
        //
        Get.to( PinCodeScreen(userNumber:userNumber.toString()));
        EasyLoading.dismiss();
        // // Sign the user in (or link) with the credential
        // var userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        // if(userCredential.user != null){
        //   //todo go to pin code page
        //   Get.to( PinCodeScreen(userNumber:userNumber.toString()));
        //   EasyLoading.dismiss();
        // }else{
        //   EasyLoading.dismiss();
        // }
        ///for sign in
        ///ConfirmationResult confirmationResult = await auth.signInWithPhoneNumber('+44 7123 123 456');
        ///UserCredential userCredential = await confirmationResult.confirm('123456');
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
