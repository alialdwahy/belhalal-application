import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:halal/constants/constants.dart';
import 'package:halal/controllers/auth_controller.dart';
import 'package:halal/controllers/user_controller.dart';
import 'package:halal/models/auth.dart';
import 'package:halal/utils/privacy_policy_text.dart';
import 'package:halal/views/screens/registration_screen.dart';
import 'package:halal/views/screens/update_user_password.dart';
import 'package:halal/views/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:halal/views/widgets/sign_in_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
    this.fromLogout = false,
  }) : super(key: key);
  final bool fromLogout;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

//////////////////////////////
class _LoginScreenState extends State<LoginScreen> {
  final AthController authController = Get.put(AthController());
  final UserController userController = Get.put(UserController());
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final AthUser _athUser = AthUser();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
     if(Platform.isAndroid) {
      _handleAcceptTerms();
     }
  }

  Widget emailTextFormField() {
    return CustomTextField(
      onChanged: (value) {
        _athUser.email = value;
      },
      leftTextAlign: true,
      validateFun: nullValidator,
      keyboardType: TextInputType.emailAddress,
      textEditingController: emailController,
      icon: Icons.email,
      hint: "البريد الالكتروني",
    );
  }

  Widget passwordTextFormField() {
    return CustomTextField(
      onChanged: (value) {
        _athUser.password = value;
      },
      leftTextAlign: true,
      validateFun: nullValidator,
      keyboardType: TextInputType.visiblePassword,
      textEditingController: passwordController,
      icon: Icons.lock,
      obscureText: true,
      hint: "كلمة المرور",
    );
  }

  bool isEmail(String input) => EmailValidator.validate(input);

  login() async {
    bool isEmailForm = isEmail(emailController.text);

    if (isEmailForm == true) {
      await authController.signIn(_athUser);
    } else {
      Get.snackbar("ناسف", "يرجى ادخال الايميل بالشكل الصحيح");
    }
  }

  nullValidator(String value) {
    if (value == '' || value.isEmpty) {
      return 'حقل مطلوب';
    }
    return null;
  }

  saveForm() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      login();
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget acceptButton = Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2.5,
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(kPrimaryColor),
          ),
          child: const Text("موافق",
              style: TextStyle(
                color: Colors.white,
              )),
          onPressed: () {
            setIsAcceptTerms(true);
            Get.back();
          },
        ),
      ),
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      scrollable: true,
      title: const Text(
        "سياسات الخصوصية",
        style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
        textAlign: TextAlign.right,
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width / 1.2,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                PrivacyPolicy.instance.privacyText,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ),
      ),
      actions: [acceptButton],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            if (Platform.isAndroid) {
              await SystemNavigator.pop();
            } else {
              exit(0);
            }
            return Future.value(false);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: alert,
          ),
        );
      },
    );
  }

  void setIsAcceptTerms(bool isAccept) {
    try {
      GetStorage().write('IsAcceptTerms', isAccept);
    } on Exception catch (e) {
      //TODO
      print(e);
    }
  }

  bool getIsAcceptTerms() {
    try {
      return GetStorage().read('IsAcceptTerms') ?? false;
    } on Exception catch (e) {
      // TODO
      print(e);
      return false;
    }
  }

  void _handleAcceptTerms() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (!getIsAcceptTerms()) {
        showAlertDialog(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: kSecondaryColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  height: height / 2.5,
                  width: width / 2,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/belhalal.png',
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        left: width / 12.0,
                        right: width / 12.0,
                        top: height / 15.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          emailTextFormField(),
                          SizedBox(height: height / 40.0),
                          passwordTextFormField(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Get.to(const UpdateUserPassword());
                },
                child: Container(
                  padding: const EdgeInsets.only(
                    bottom: 0, // Space between underline and text
                  ),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Colors.blueAccent,
                    width: 1.0, // Underline thickness
                  ))),
                  child: const Text(
                    "نسـيـت كلمـة الـمـرور ؟",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              SignInButton(
                ontop: saveForm,
                width: width,
                height: height,
                label: 'تسجيل',
                primaryColor: Colors.redAccent,
              ),
              SizedBox(
                height: height / 15,
              ),
              GestureDetector(
                  onTap: () {
                    Get.to(const RegistrationScreen());
                  },
                  child: const Text(
                    'مستخدم جديد',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: kPrimaryColor),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
