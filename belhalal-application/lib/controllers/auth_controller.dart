import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:halal/controllers/app_controller.dart';
import 'package:halal/controllers/user_controller.dart';
import 'package:halal/models/auth.dart';
import 'package:halal/models/user.dart';
import 'package:halal/services/auth_service.dart';
import 'package:halal/views/screens/login.dart';
import 'package:logger/logger.dart';

class AthController extends GetxController {
  var userId = "".obs;
  final UserController _userController = Get.put(UserController());

  /// store user id locally by get_storage pakage
  getUserIdFromLocalStorage() {
    userId.value = AthService.userService.getUserIdFromLocalStorage();
  }

  /// signup new user
  signUp() {
    AthService.userService.signUp(_userController.myUser.value);
  }

  resetPassword(String email)async{
   await  AthService.userService.resetPassword(email);
  }

  /// store user id locally by get_storage pakage
  storeUserIdLocally(String userId) {
    AthService.userService.storeUserIdLocally(userId);
  }

  /// signIn user
  signIn(AthUser athUser) async {
     EasyLoading.show(status: "... جاري التحقق");
    String userid = await AthService.userService.login(athUser);
    userId.value = userid;

  }

  ///logout
  logout() async{
    try {
      final UserController userController = Get.put(UserController());
      final AppController _appController = Get.put(AppController());
      userId.value = "";
      userController.myUser.value = MyUser();
      _appController.myUsers.value.clear();
      await AthService.userService.logout();
    } catch (e) {
      Logger().d(e);
    }
  }
  deleteMyaccount()async{
    final UserController userController = Get.put(UserController());
    await userController.deleteUserCurrentUser(userId.value.toString());
    await AthService.userService.deleteAccount();
    userId.value="";
    userController.myUser.value=MyUser();
    Get.offAll(const LoginScreen());
  }

  void signUpWithPhoneNumber(var code) {
    AthService.userService.signUpWithMobile(_userController.myUser.value , code);
  }
}
