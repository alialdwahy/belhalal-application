import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';
import 'package:halal/constants/constants.dart';
import 'package:halal/controllers/auth_controller.dart';
import 'package:halal/controllers/user_controller.dart';
import 'package:halal/models/auth.dart';
import 'package:halal/views/screens/pin_code_fields.dart';
import 'package:halal/views/screens/registration_screen.dart';
import 'package:halal/views/screens/update_user_password.dart';
import 'package:halal/views/widgets/belhalal_logo.dart';
import 'package:halal/views/widgets/custom_text_field.dart';
import 'package:halal/views/widgets/sign_in_button.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'email_confirmation_screen.dart';

// ignore: must_be_immutable
class NewLoginWithPhone extends StatelessWidget {
  NewLoginWithPhone({Key? key}) : super(key: key);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final UserController userController = Get.put(UserController());
  final AthController authController = Get.put(AthController());
  TextEditingController passwordController = TextEditingController();
  final AthUser _athUser = AthUser();
  final _formKey = GlobalKey<FormState>();
  String initialCountry = 'KWT';
  PhoneNumber userNumber = PhoneNumber(isoCode: 'KWT');
  bool isEmail(String input) => EmailValidator.validate(input);
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

  login() async {
    bool isEmailForm = isEmail(emailController.text);

    if (isEmailForm == true) {
      await authController.signIn(_athUser);
    } else {
      Get.snackbar("ناسف", "يرجى ادخال الايميل بالشكل الصحيح");
      // String myEmail =
      //     await userController.getUserEmailByName(emailController.text);

      // authController.signIn(AthUser(email: myEmail, password: _athUser.password));

    }
  }

  nullValidator(String value) {
    if (value == '' || value.isEmpty) {
      return 'حقل مطلوب';
    }
    return null;
  }

  // validate email if empty or not correct
  emailValidator(String value) {
    //checkIsEmailAlreadyExist(value);
    if (value == '' || value.isEmpty) {
      return "حقل مطلوب";
    }
    if (!isEmail(value)) {
      return "الايميل غير صحيح";
    }
    // if (emailIsExist==true) {
    //   return  "الايميل موجود بالفعل";
    // }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    saveForm() async {
      FocusScope.of(context).unfocus();
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        login();
      }
    }

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: GetBuilder<UserController>(
                init: userController,
                initState: (state) {
                  emailController.text =
                      userController.myUser.value.email.toString();
                  passwordController.text =
                      userController.myUser.value.password.toString();
                  userController.update();
                },
                builder: (logic) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        BelhalaLogo(
                          height: height,
                          width: width,
                          logoLabel: 'بالحلال',
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30,),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                children: const [
                                  SizedBox(
                                    child: Text(
                                      'اختر طريقة تسجيل الدخول',
                                      style: TextStyle(
                                          fontSize: 22, color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: SizedBox(
                                        child: Text(
                                      'ملاحظة لن تظهر هذه المعلومات للمستخدمين',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                          textAlign: TextAlign.right,
                                    )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // the tab bar with two items
                        Container(
                          color: Colors.white,
                          height: 72,
                          margin: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: TabBar(
                              onTap: (value) {
                                FocusManager.instance.primaryFocus?.unfocus();
                                logic.currentTabValue(value);
                              },
                              unselectedLabelColor: Colors.black,
                              indicatorColor: Colors.black,
                              labelColor: kPrimaryColor,
                              labelStyle:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              tabs: const [
                                Tab(
                                  text: 'الموبايل',
                                ),
                                Tab(
                                  text: 'البريد الالكتروني',
                                ),
                              ],
                            ),
                          ),
                        ),
                        // create widgets for each tab bar here
                        SizedBox(
                          height: height / 2 - 4,
                          child: TabBarView(
                            children: [
                              // first tab bar view widget sign in by phone number
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Form(
                                      key: formKey,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 45.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            color: Colors.white,
                                          ),
                                          padding: const EdgeInsets.only(
                                              right: 2, left: 20),
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 25,
                                          ),
                                          width: width,
                                          child: SizedBox(
                                            height: 63,
                                            child:
                                                InternationalPhoneNumberInput(
                                              hintText: 'رقم الموبايل',
                                              onInputChanged:
                                                  (PhoneNumber userNumber) {
                                                this.userNumber = userNumber;
                                                // logic.phoneNumber(userNumber);
                                              },
                                              // onInputValidated: (bool value) {
                                              //TODO:
                                              // },
                                              selectorConfig:
                                                  const SelectorConfig(
                                                selectorType:
                                                    PhoneInputSelectorType
                                                        .BOTTOM_SHEET,
                                                setSelectorButtonAsPrefixIcon:
                                                    true,
                                                showFlags: true,
                                                useEmoji: true,
                                              ),
                                              ignoreBlank: false,
                                              autoValidateMode:
                                                  AutovalidateMode.disabled,
                                              selectorTextStyle:
                                                  const TextStyle(
                                                      color: Colors.black),
                                              initialValue: userNumber,
                                              textFieldController: controller,
                                              formatInput: false,
                                              keyboardType: const TextInputType
                                                      .numberWithOptions(
                                                  signed: true, decimal: true),
                                              inputBorder:
                                                  const OutlineInputBorder(
                                                gapPadding: 0,
                                                borderSide: BorderSide.none,
                                              ),
                                              onSaved:
                                                  (PhoneNumber userNumber) {
                                                //print('On Saved: $userNumber');
                                                this.userNumber = userNumber;
                                                logic.phoneNumber(userNumber);
                                              },
                                              onSubmit: () {
                                                // logic.saveCountryIsoCod(userNumber);
                                                logic.phoneNumber(userNumber);
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    SingleChildScrollView(
                                        child: InkWell(
                                      onTap: () {
                                        logic.signInWithMobile();
                                      },
                                      child: const Text(
                                        'اضغط هنا لارسال الرمز',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                        textAlign: TextAlign.right,
                                      ),
                                    )),
                                    const SizedBox(
                                      height: 35,
                                    ),
                                    SizedBox(
                                      width: width / 2.5,
                                      height: height / 15,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          primary: Colors.white, // background
                                        ),
                                        onPressed: () {
                                          // TODO: Rise up Code generate view and check if verifyed go to تم التحقق screen
                                          Get.to(
                                            const PinCodeScreen(),
                                          );
                                          //Get.to(() =>  EmailConfirmationScreen());
                                        },
                                        child: const Text(
                                          'أدخل الرمز',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          Get.to(const RegistrationScreen());
                                        },
                                        child: const Text(
                                          ' مستخدم جديد ؟',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white,
                                        )),
                                    )],
                                ),
                              ),
                              //////////////////////////// second tab bar view widget sign in by email////////////////////////////////////////////
                              Container(
                                color: kPrimaryColor,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 25.0),
                                  child: Center(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 25, vertical: 15),
                                            child:
                                                // emailTextFormField(),
                                                CustomTextField(
                                              leftTextAlign: true,
                                              onChanged: (p0) {
                                                userController.myUser.value
                                                    .email = p0.toString();
                                                logic.update();
                                              },
                                              icon: Icons.email,
                                              isEnable: emailController
                                                      .text.isNotEmpty
                                                  ? true
                                                  : false,
                                              hint: 'البريد الالكتروني',
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              textEditingController:
                                                  emailController,
                                              validateFun: emailValidator,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          SizedBox(
                                              width: width / 1.2,
                                              child: passwordTextFormField()),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                  onTap: () {
                                                    Get.to(
                                                        const RegistrationScreen());
                                                  },
                                                  child: const Text(
                                                    ' مستخدم جديد ؟',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.white),
                                                  )),
                                              //////////////////////////////////////
                                              SizedBox(
                                                width: width / 10,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Get.to(
                                                      const UpdateUserPassword());
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    bottom:
                                                        0, // Space between underline and text
                                                  ),
                                                  child: const Text(
                                                    "نسـيـت كلمـة الـمـرور ؟",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 25,
                                          ),
                                          SignInButton(
                                            ontop: saveForm,
                                            width: width,
                                            height: height,
                                            label: 'تسجيل',
                                            primaryColor: Colors.white,
                                            labelcolor: Colors.black,
                                            borderColor: kPrimaryColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber userNumber =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');
//TODO
    //setState(() {
    this.userNumber = userNumber;
    //});
  }

  @override
  void dispose() {
    controller.dispose();
  }
}
