import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:halal/controllers/user_controller.dart';
import 'package:halal/models/auth.dart';
import 'package:halal/models/user.dart';
import 'package:halal/services/user_service.dart';
import 'package:halal/views/screens/email_confirmation_screen.dart';
import 'package:halal/views/screens/home_page.dart';
import 'package:halal/views/screens/login.dart';
import 'package:logger/logger.dart';

class AthService {
  AthService._();

  /// singilton onject
  static AthService userService = AthService._();
  FirebaseAuth auth = FirebaseAuth.instance;

  /// send email varification for user
  sendEmailVerificationToUser() async {
    await auth.currentUser!.sendEmailVerification().then((value) {
      Get.snackbar(
          "تفقد بريدك الالكتروني ", "لقد أرسلنا لك رسالة بريد إلكتروني للتحقق");
    });
  }

  /// lesten for user change to check if he verfy his email or not and do sign upß
  listenForUserChange(MyUser myUser) {
    var listen;
    listen = auth.userChanges().listen((
      response,
    ) {
      auth.currentUser!.reload(); // reload user auth
      // check if the user virefied his email or not
      if (response!.emailVerified) {
        // do signUp for new user after he virefied his email
        UserService.userService.createNewUser(myUser, auth.currentUser!.uid);

        // store user id locally by get_storage pakage
        storeUserIdLocally(auth.currentUser!.uid);

        listen.cancel();
      } else {
        Timer(const Duration(minutes: 1), () {
          listen.cancel();
        });
      }
    });
  }

  /// create new user on firebase
  signUp(MyUser myUser) async {
    // crete new user on firebase by email and password
    EasyLoading.show(status: "... جاري التحميل");
    await auth
        .createUserWithEmailAndPassword(
            email: myUser.email!, password: myUser.password!)
        .then((value) async {
          EasyLoading.dismiss(animation: true);
      Get.offAll(EmailConfirmationScreen(
        confirmEmail: true,
      ));
      // send verifcationEmail for the user
      sendEmailVerificationToUser();

      // lesten for user change to check if he verfy his email or not
      //listenForUserChange(myUser);

      // relode user data
      auth.currentUser!.reload();
      // to add user data to firestor
      UserService.userService.createNewUser(myUser, auth.currentUser!.uid);
    }).catchError((e) {
      EasyLoading.dismiss(animation: true);
      Get.snackbar("ناسف", "هذا الايميل مستخدم من قبل");
      Get.offAll(() => EmailConfirmationScreen(
            confirmEmail: false,
          )); //new Screen
    });
  }
  /// create new user on firebase
  signUpWithMobile(MyUser myUser , var code) async {
    // crete new user on firebase by email and password
    EasyLoading.show(status: "... جاري التحميل");
    ConfirmationResult confirmationResult = await auth.signInWithPhoneNumber('${myUser.email}');
    /*UserCredential userCredential =*/ await confirmationResult.confirm('$code').then((value)async {
      EasyLoading.dismiss(animation: true);
      auth.currentUser!.reload();
      await UserService.userService.createNewUser(myUser,value.user!.uid/* auth.currentUser!.uid*/);
      Get.offAll(()=>Home(selectedIndex: 0,));
    }).catchError((e) {
      EasyLoading.dismiss(animation: true);
      Get.snackbar("ناسف", "هذا الايميل مستخدم من قبل");
    });
  }

  login(AthUser athUser) async {
    String userId = "";
    // sign in with firebase
    await auth
        .signInWithEmailAndPassword(
            email: athUser.email!, password: athUser.password!)
        .then((value) async {
      //cheking if the yser verfy his email
      auth.currentUser!.reload();
      if (auth.currentUser!.emailVerified) {
        final UserController userController = Get.put(UserController());
        await userController.getUsercomplaints(value.user!.uid);
        if (userController.myComplaint.value.count! <= 3) {
          // store user id in to local storage
          storeUserIdLocally(value.user!.uid);
          userId = value.user!.uid == null ? "" : value.user!.uid;
          //get user data and store it into controller
          await  userController.getUserInfo(userId);
          EasyLoading.dismiss(animation: true);
          Get.offAll(Home(
            selectedIndex: 0,
          ));
        } else {
          EasyLoading.dismiss(animation: true);
          Get.snackbar("ناسف ", "تم اغلاق حسابك");
        }
      } else {
        EasyLoading.dismiss(animation: true);
        Get.snackbar("ناسف", "يرجى تفعيل حسابك");
      }
    }).catchError((e) {
      EasyLoading.dismiss(animation: true);
      Get.snackbar("ناسف", "يرجى التحقق من بريدك الإلكتروني و كلمة المرور");
    });
    return userId;
  }

  loginMobile(AthUser athUser) async {
    String userId = "";
    // sign in with firebase
    await auth
        .signInWithEmailAndPassword(
        email: athUser.email!, password: athUser.password!)
        .then((value) async {
      //cheking if the yser verfy his email
      auth.currentUser!.reload();
      // if (auth.currentUser!.phoneVerified) {
        final UserController userController = Get.put(UserController());
        await userController.getUsercomplaints(value.user!.uid);
        if (userController.myComplaint.value.count! <= 3) {
          // store user id in to local storage
          storeUserIdLocally(value.user!.uid);
          userId = value.user!.uid == null ? "" : value.user!.uid;
          Get.to(Home(
            selectedIndex: 0,
          ));
        } else {
          Get.snackbar("ناسف ", "تم اغلاق حسابك");
        }
      // } else {
      //   Get.snackbar("ناسف", "يرجى تفعيل حسابك");
      // }
    }).catchError((e) {
      Get.snackbar("ناسف", "يرجى التحقق من بريدك الإلكتروني و كلمة المرور");
    });
    return userId;
  }
  logout() async {
    try {

      await FirebaseAuth.instance.signOut().then((value) async{
        removeUserIdFromLocalStorage();
        await GetStorage().erase();
        await GetStorage().write('IsAcceptTerms', true);
        Get.offAll(() => const LoginScreen(fromLogout:true));
           });
    } catch (e) {
      Logger().d(e);
    }
  }

  resetPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email).then((value) {
      Get.snackbar("تمت العمليه بنجاح",
          "لقد أرسلنا رسالة إلى بريدك الإلكتروني ، تحقق من بريدك الإلكتروني لاستعادة كلمة مرورك");
    }).catchError((e) => Get.snackbar("ناسف", " لم تتم العمليه حاول مره اخری"));
  }

  /// store user id locally by get_storage pakage
  storeUserIdLocally(String userId) {
    GetStorage().write("user_id", userId);
  }

  /// store user id locally by get_storage pakage
  String getUserIdFromLocalStorage() {
    if (GetStorage().read("user_id") != null) {
      return GetStorage().read("user_id");
    }
    return "";
  }

  removeUserIdFromLocalStorage() {
    GetStorage().remove("user_id");
  }
  deleteAccount() async {
    try{
    await auth.currentUser?.delete().then((value) {
      removeUserIdFromLocalStorage();
    });
    }catch(e){
      Logger().d(e);
    }
  }
}
