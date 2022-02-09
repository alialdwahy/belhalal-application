import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:halal/constants/constants.dart';
import 'package:halal/controllers/auth_controller.dart';
import 'package:halal/controllers/user_controller.dart';
import 'package:halal/views/widgets/belhalal_logo.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeScreen extends StatelessWidget {
  const PinCodeScreen( {Key? key, this.userNumber}) : super(key: key);
  final String? userNumber;
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return const MaterialApp(home: PinCodeVerificationScreen(phoneNumber:"+8801376221100"));
    });
  }
}

class PinCodeVerificationScreen extends StatefulWidget {
  final String? phoneNumber;

   const PinCodeVerificationScreen( {Key? key ,this.phoneNumber,}) : super(key: key);

  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  final AthController athController = Get.put(AthController());
  final UserController userController = Get.put(UserController());
  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SizedBox(
          height: height,
          width: width,
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 50),
              BelhalaLogo(
                height: height / 18,
                width: width / 5,
                logoLabel: 'بالحلال',
              ),
              const SizedBox(height: 23),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'التحقق بإستخدام رقم الهاتف',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22,color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text: "أدخل رقم التحقق المرسل للرقم  ",
                      children: [
                        TextSpan(
                            text: "${widget.phoneNumber}",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                      ],
                      style:
                          const TextStyle(color: Colors.white, fontSize: 15)),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: PinCodeTextField(
                      //backgroundColor: Colors.white,
                      appContext: context,
                      pastedTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      obscureText: true,
                      obscuringCharacter: '*',
                     // obscuringWidget:  BelhalaLogo(height: 2, width: 2,logoLabel:'',),
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v!.length < 3) {
                          return "يرجى إدخال جميع الخانات";
                        } else {
                          return null;
                        }
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.underline,
                        //borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: kPrimaryColor,
                        inactiveColor: Colors.white,
                        selectedFillColor: Colors.white,
                        inactiveFillColor: Colors.white,
                         activeColor: Colors.white,
                      ),
                      cursorColor: Colors.black,
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      boxShadows: const [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        ),
                      ],
                      onCompleted: (v) {
                        print("Completed");
                        userController.myUser.value.email = widget.phoneNumber.toString();
                        signUoWithMobile(v);
                      },
                      // onTap: () {
                      //   print("Pressed");
                      // },
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        print("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? "*Please fill up all the cells properly" : "",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () => snackBar("OTP resend!!"),
                      child: const Text(
                        "أعد الإرسال",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      )),
                  const Text(
                    "لم يصلك الكود بعد ؟ ",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(
                height: 14,
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                child: ButtonTheme(
                  height: 50,
                  child: TextButton(
                    onPressed: () {
                      formKey.currentState!.validate();
                      // conditions for validating
                      if (currentText.length != 6 || currentText != "123456") {
                        errorController!.add(ErrorAnimationType
                            .shake); // Triggering error shake animation
                        setState(() => hasError = true);
                      } else {
                        setState(
                          () {
                            hasError = false;
                            snackBar("OTP Verified!!");
                          },
                        );
                      }
                    },
                    child: Center(
                        child: Text(
                      "تـأكـيـد".toUpperCase(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(1, -2),
                          blurRadius: 5),
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(-1, 2),
                          blurRadius: 5)
                    ]),
              ),
              const SizedBox(
                height: 16,
              ),
              /*     Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                      child: TextButton(
                    child: const Text("حذف"),
                    onPressed: () {
                      textEditingController.clear();
                    },
                  )),
                  Flexible(
                      child: TextButton(
                    child: const Text("ألصق الكود"),
                    onPressed: () {
                      setState(() {
                        textEditingController.text = "123456";
                      });
                    },
                  )),
                ],
              ),
              */
            ],
          ),
        ),
      ),
    );
  }

  void signUoWithMobile(String v) {
    athController.signUpWithPhoneNumber(v);
  }
}
