import 'dart:developer';

import 'package:belhalal_update/controllers/auth_controller.dart';
import 'package:belhalal_update/screen/home/home_page.dart';
import 'package:belhalal_update/value/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Login extends StatelessWidget {
  // final AuthController controller = Get.put(AuthController());
  bool isLoading = false;
  final userdata = GetStorage();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: Form(
          // key: controller.formkey.value,
          child: Padding(
            padding: Constant.kDefaultPadding,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Padding(
                      padding: const EdgeInsets.only(bottom: 60.0),
                      //...................................................... logo here
                      child: Center(),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      height: 42,
                      width: 320,
                      child: TextFormField(
                        // enabled: !controller.loginProcess.value,
                        // controller: controller.usernameTextController.value,
                        autocorrect: true,
                        textAlign: TextAlign.end,
                        validator: (val) => val!.isEmpty || val == null
                            ? 'Please enter your username'
                            : null,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.only(
                              left: 11, right: 3, top: 15, bottom: 14),
                          errorStyle: TextStyle(height: 0),
                          prefixIcon: Icon(Icons.person_outlined),
                          border: InputBorder.none,
                          hintText: "البريد الالكتروني",
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      height: 42,
                      width: 320,
                      child: Center(
                        child: TextFormField(
                          // obscureText:
                          //     controller.visible == false ? true : false,
                          // enabled: !controller.loginProcess.value,
                          // controller:
                          //     controller.passwordTextController.value,
                          validator: (t) {
                            if (t!.isEmpty) {
                              return "الرجاء ادحال كلمة المرور.";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.only(
                                left: 11, right: 3, top: 15, bottom: 14),
                            errorStyle: const TextStyle(height: 0),
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                            ),
                            hintText: "كلمة المرور",
                            suffixIcon: IconButton(
                              icon: Icon(Icons.visibility_off),
                              // icon: controller.visible.value
                              //     ? Icon(Icons.visibility)
                              //     : Icon(Icons.visibility_off),
                              onPressed: () {
                                // controller.visible.toggle();
                                // log(controller.visible.toString());
                              },
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {},
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
                    InkWell(
                      onTap: () async {
                        // String? username;

                        // if (controller.formkey.value.currentState!
                        //     .validate()) {
                        //   var result = await controller.login(
                        //       username: controller
                        //           .usernameTextController.value.text,
                        //       password: controller
                        //           .passwordTextController.value.text);
                        //   if (result) {
                        //     Get.offAll(HomePage());

                        //     EasyLoading.dismiss();
                        //     userdata.write('isLogged', true);
                        // //    userdata.write('username', username);
                        //   } else {
                        //     Get.snackbar(
                        //         "Error", "Wrong Username or password ",
                        //         snackPosition: SnackPosition.BOTTOM);
                        //     EasyLoading.dismiss();
                        //   }
                        // }
                      },
                      child: Container(
                        height: 45,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20)),
                        child: const Center(
                          child: Text(
                            'تسجيل',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                        onTap: () {
                          Get.to(const HomePage());
                        },
                        child: const Text(
                          'مستخدم جديد',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.red),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
