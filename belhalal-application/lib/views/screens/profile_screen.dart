// ignore_for_file: unrelated_type_equality_checks, unused_field
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:halal/chat/widgets/view_pic_before_send.dart';
import 'package:halal/constants/constants.dart';
import 'package:halal/controllers/auth_controller.dart';
import 'package:halal/controllers/email_message_controller.dart';
import 'package:halal/controllers/payment_controller.dart';
import 'package:halal/controllers/subscription_controller.dart';
import 'package:halal/controllers/user_controller.dart';
import 'package:halal/utils/firebase_utils.dart';
import 'package:halal/utils/shared_method.dart';
import 'package:halal/views/screens/home_page.dart';
import 'package:halal/views/screens/login.dart';
import 'package:halal/views/screens/privacy_policy_screen.dart';
import 'package:halal/views/screens/subscriptions.dart';
import 'package:halal/views/screens/update_user_info.dart';
import 'package:halal/views/widgets/custome_buttom_clipper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String displayText1 = '''للتحدث إلى 10 أعضاء
  عبر الرسائل \$19''';
  String displayText2 = '''للتحدث إلى عدد مفتوح من الأعضاء
  عبر الرسائل \$49''';
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  var imagePath;
  final UserController _userController = Get.put(UserController());
  final AthController _authController = Get.put(AthController());
  final PaymentController _paymentController = Get.put(PaymentController());
  final SubscriptionController _subscriptionController =
      Get.put(SubscriptionController());
  final EmailMessageController _emailMessageController =
      Get.put(EmailMessageController());
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  _imgFromCamera() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 40);
    if (image!.length() != 0) {
      EasyLoading.show(status: '... جاري التحميل'); // show loding indicator
      _userController.updateUserPic(_authController.userId.value, image);
      _userController.getUserInfo(_authController.userId.value);
      EasyLoading.dismiss(); // stop loging indicator
    }
  }

  _imgFromGallery() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 40);
    if (image!.length() != 0) {
      setState(() {
        _image = image;
        imagePath = File(image.path);
      });
      await Get.to(() => ViewPicBeforeSend(
            image: imagePath,
            xImage: image,
            isOk: true,
          ));
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            // ignore: avoid_unnecessary_containers
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text(
                      'معرض الصور',
                      textAlign: TextAlign.right,
                    ),
                    onTap: () async {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('الكاميرا', textAlign: TextAlign.right),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> showMyDialog(BuildContext context, String displayText) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(displayText,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        );
      },
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("إلغاء"),
      onPressed: () {
        Get.back();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("الخروج"),
      onPressed: () async {
        await _authController.logout();
        Get.offAll(const LoginScreen());
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("تسجيل الخروج"),
      content: const Text(" هل تريد الخروج بالفعل ؟"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  getMySubScription() async {
    await _subscriptionController
        .getMySubscription(_authController.userId.value);
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _userController.getUserInfo(_authController.userId.value);
    Get.offAll(Home(
      selectedIndex: 3,
    ));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _userController.getUserInfo(_authController.userId.value);
    });
    _refreshController.loadComplete();
  }

  bool isHide = Platform.isIOS ? false : false;
  @override
  void initState() {
    getMySubScription();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (Platform.isIOS) {
        FirebaseRef.instance.isHideWallet().then((value) {
          isHide = value;
          setState(() {});
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                ClipPath(
                  clipper: CustomClipPath(),
                  child: Container(
                    color: kPrimaryColor,
                    height: 280.0,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showPicker(context);
                          });
                        },
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: const Color(0xFFF5F5F5),
                          child: imagePath != null
                              ? ClipOval(
                                  child: Image.file(
                                    imagePath,
                                    fit: BoxFit.cover,
                                    width: 120,
                                    height: 120,
                                  ),
                                )
                              : _userController.myUser.value.imageUrl != ""
                                  ? Obx(() => ClipOval(
                                      child: AppSharedMethod.instance
                                          .imageNetwork(
                                              url: _userController
                                                  .myUser.value.imageUrl
                                                  .toString(),
                                              width: 120,
                                              height: 120)
                                      // Image.network(
                                      //       _userController.myUser.value.imageUrl
                                      //           .toString(),
                                      //       fit: BoxFit.cover,
                                      //       width: 120,
                                      //       height: 120,
                                      //     ),
                                      ))
                                  : Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey, width: 1),
                                        borderRadius: BorderRadius.circular(60),
                                        color: Colors.white,
                                      ),
                                      width: 115,
                                      height: 115,
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Builder(
                      builder: (context) {
                        return TextButton(
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all(2.0),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white70),
                                shadowColor:
                                    MaterialStateProperty.all(Colors.black38),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0)))),
                            onPressed: () async {
                              showAlertDialog(context);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  "تسجيل الخروج",
                                  style: TextStyle(color: Colors.black),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.logout,
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ],
                            ));
                      }
                    ),
                  ),
                  const SizedBox(width: 40),
                  TextButton(
                    clipBehavior: Clip.antiAlias,
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(2.0),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white70),
                        shadowColor: MaterialStateProperty.all(Colors.black38),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)))),
                    onPressed: () {
                      Get.to(const UpdateUserInfo());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'تحرير الملف',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.edit,
                          color: Colors.black,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: height / 2.9,
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Column(
                      children: [
                        if (!isHide) ...[
                          Container(
                            width: width/1.6,
                            margin:  EdgeInsets.only(
                                top: height/20, left: 32,right: 32),
                            child: TextButton(
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(2.0),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  shadowColor:
                                      MaterialStateProperty.all(Colors.black38),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0)))),
                              onPressed: () {
                                Get.to(const UserSubscriptions());
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Center(
                                  child: Text(
                                    'إدارة الإشتراكات',
                                    style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Text(
                              'لإختيار إشتراك جديد أولمتابعة حالة الإشتراك',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                              )),
                           SizedBox(
                            height: height/20,
                          ),
                          GestureDetector(
                                onTap: () {
                                  Get.to(() => const PrivacyPolicy());
                                },
                                child: const Text(
                                  'شروط الخصوصية  ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      fontSize: 13),
                                )),
                           SizedBox(
                            height: height/20,
                          ),
                        ],
                        if (isHide)
                          const SizedBox(
                            height: 130,
                          ),
                        GestureDetector(
                          onTap: () async {
                            await _emailMessageController.sendEmailOfCallUs(
                              _userController.myUser.value.name!,
                            );
                          },
                          child: Text('اتـصـل بـنـا',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
