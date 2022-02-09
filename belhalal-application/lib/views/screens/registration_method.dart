import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';
import 'package:halal/constants/constants.dart';
import 'package:halal/controllers/auth_controller.dart';
import 'package:halal/controllers/user_controller.dart';
import 'package:halal/views/widgets/belhalal_logo.dart';
import 'package:halal/views/widgets/custom_text_field.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'email_confirmation_screen.dart';

// ignore: must_be_immutable
class RegistrationMethodScreen extends StatelessWidget {
  RegistrationMethodScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController reEmailController = TextEditingController();
  final UserController userController = Get.put(UserController());
  final AthController athController = Get.put(AthController());
  String initialCountry = 'KWT';
  PhoneNumber userNumber = PhoneNumber(isoCode: 'KWT');

  bool isEmail(String input) => EmailValidator.validate(input);

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
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double height = MediaQuery
        .of(context)
        .size
        .height;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: GetBuilder<UserController>(
              init: userController,
              initState: (state) {
                emailController.text = userController.myUser.value.email.toString();
                reEmailController.text = userController.myUser.value.email.toString();
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
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: const [
                            SizedBox(
                              child: Text(
                                'اختر طريقة التحقق',
                                style: TextStyle(
                                    fontSize: 22, color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: SizedBox(child: Text(
                                'ملاحظة لن تظهر هذه المعلومات للمستخدمين',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),)),
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
                    margin:const  EdgeInsets.symmetric(horizontal: 25.0),
                    child:  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TabBar(
                        onTap: (value) => logic.currentTabValue(value),
                        unselectedLabelColor: Colors.black,
                        indicatorColor: Colors.black,
                        labelColor: kPrimaryColor,
                        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                        tabs:const  [
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
                        // first tab bar view widget
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Form(
                                key: formKey,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 45.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
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
                                      child: InternationalPhoneNumberInput(
                                        hintText: 'رقم الموبايل',
                                        onInputChanged: (
                                            PhoneNumber userNumber) {
                                          this.userNumber = userNumber;
                                          // logic.phoneNumber(userNumber);
                                        },
                                        // onInputValidated: (bool value) {
                                        //TODO:
                                        // },
                                        selectorConfig: const SelectorConfig(
                                          selectorType:
                                          PhoneInputSelectorType.BOTTOM_SHEET,
                                          setSelectorButtonAsPrefixIcon: true,
                                          showFlags: true,
                                          useEmoji: true,
                                        ),
                                        ignoreBlank: false,
                                        autoValidateMode: AutovalidateMode
                                            .disabled,
                                        selectorTextStyle:
                                        const TextStyle(color: Colors.black),
                                        initialValue: userNumber,
                                        textFieldController: controller,
                                        formatInput: false,
                                        keyboardType:
                                        const TextInputType.numberWithOptions(
                                            signed: true, decimal: true),
                                        inputBorder: const OutlineInputBorder(
                                          gapPadding: 0,
                                          borderSide: BorderSide.none,
                                        ),
                                        onSaved: (PhoneNumber userNumber) {
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
                              // const SizedBox(height: 15),
                              //  SingleChildScrollView(child: InkWell(
                              //   onTap: () {
                              //     logic.signInWithMobile();
                              //   },
                              //   child:const  Text(
                              //     'اضغط هنا لارسال الرمز', style: TextStyle(
                              //       color: Colors.white, fontSize: 14),
                              //     textAlign: TextAlign.right,),
                              // )),
                              const SizedBox(height: 35,),
                              SizedBox(
                                width: width / 2.5,
                                height: height / 15,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    primary: Colors.white, // background
                                  ),
                                  onPressed: () {
                                    // TODO: Rise up Code generate view and check if verifyed go to تم التحقق screen
                                    //Get.to(() =>  EmailConfirmationScreen());
                                    if(logic.userNumber.toString() != "0") {
                                      logic.signInWithMobile();
                                    }else{
                                      Get.snackbar("خطاء", "ادخل رقم الهاتف والمفتاح الدولي");
                                    }
                                  },
                                  child: const Text('أدخل الرمز',
                                    style: TextStyle(color: Colors.black,),),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // second tab bar viiew widget
                        Container(
                          color: kPrimaryColor,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 45.0),
                            child: Center(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 15),
                                    child: CustomTextField(
                                      leftTextAlign: true,
                                      onChanged: (p0) {
                                        userController.myUser.value.email = p0.toString();
                                        logic.update();
                                      },
                                      isEnable: emailController.text.isNotEmpty ? true : false,
                                      hint: 'البريد الالكتروني',
                                      keyboardType: TextInputType.emailAddress,
                                      textEditingController: emailController,
                                      validateFun: emailValidator,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 5),
                                    child: CustomTextField(
                                      leftTextAlign: true,
                                      isEnable: reEmailController.text.isNotEmpty ? true : false,
                                      hint: 'إعادة كتابة البريد الالكتروني',
                                      keyboardType: TextInputType.emailAddress,
                                      textEditingController: reEmailController,
                                      validateFun: emailValidator,
                                    ),
                                  ),
                                  const SizedBox(height: 25,),
                                  GestureDetector(
                                    onTap: () async{
                                      //TODO:
                                      //make loading here
                                      if(emailController.text.isNotEmpty && reEmailController.text.isNotEmpty
                                      && emailController.text ==
                                      reEmailController.text){
                                        EasyLoading.show(status: "...الرجاء الانتظار");
                                        await athController.signUp();
                                        EasyLoading.dismiss();
                                      }else{
                                        Get.snackbar("خطاء", "يرجى التاكد من توافيق الايميل ");
                                      }
                                      //Get.to(() => EmailConfirmationScreen());
                                      //    
                                    },
                                    child: SizedBox(
                                        width: width / 1.2,
                                        child: const Text(
                                          'أرسل رابط التحقق \nعبر الايميل',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),)),
                                  )
                                ],
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
