import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:halal/constants/constants.dart';
import 'package:halal/controllers/auth_controller.dart';
import 'package:halal/controllers/user_controller.dart';
import 'package:halal/views/screens/registration_method.dart';
import 'package:halal/views/widgets/belhalal_logo.dart';
import 'package:halal/views/widgets/custom_text_field.dart';
import 'package:halal/views/widgets/drop_down_input.dart';
import 'package:flutter/material.dart';
import 'package:halal/views/widgets/sign_in_button.dart';

class CompleteRegistration2 extends StatefulWidget {
  const CompleteRegistration2({Key? key}) : super(key: key);
  @override
  _CompleteRegistration2State createState() => _CompleteRegistration2State();
}

class _CompleteRegistration2State extends State<CompleteRegistration2> {
  TextEditingController skinColorController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController hightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String marriedTypeValue = 'دائم معلن';
  var marriedTypes = ['دائم معلن', 'دائم غير معلن','آخر'];
  String annualIncomeValue = 'أقل من 50\$ ألف';
  var annualIncomeTypes = [
    'أكثر من 150\$ ألف',
    'أقل من 100\$ ألف',
    'أقل من 50\$ ألف'
  ];
 final  UserController _userController = Get.put(UserController());
 final  AthController _authController = Get.put(AthController());

  nullValidator(String value) {
    if (value == '' || value.isEmpty) {
      return 'حقل مطلوب';
    }
    return null;
  }

  // save form
  saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _userController.myUser.value.marriedTypeValue = marriedTypeValue;
      _userController.myUser.value.skinColor = skinColorController.text;
      _userController.myUser.value.long = hightController.text;
      _userController.myUser.value.weight = weightController.text;
      _userController.myUser.value.job = jobController.text;
      _userController.myUser.value.annualIncomeValue = annualIncomeValue;
      // Get.to(() =>  RegistrationMethodScreen());
      _authController.signUp();
    }
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
      backgroundColor: kPrimaryColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            BelhalaLogo(height: height, width: width),
            Form(
              key: _formKey,
              child: Container(
                width: width / 1.2,
                margin: EdgeInsets.only(top: height / 25.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AppDropdownInput( 
                        hintText: "نوع الزواج",
                        options:   marriedTypes,
                        value: marriedTypeValue,
                        onChanged: (String? value) {
                          setState(() {
                            marriedTypeValue = value!;
                          });
                        },
                        getLabel: (String? value) => value,
                      ),
                      SizedBox(
                        height: height / 40,
                      ),
                      CustomTextField(
                        hint: 'لون البشرة',
                        leftTextAlign: false,
                        keyboardType: TextInputType.text,
                        textEditingController: skinColorController,
                        validateFun: nullValidator,
                      ),
                      SizedBox(
                        height: height / 40,
                      ),
                      AppDropdownInput(
                        hintText: "الدخل السنوي",
                        options: annualIncomeTypes,
                        value: annualIncomeValue,
                        onChanged: (String? value) {
                          setState(() {
                            annualIncomeValue = value!;
                          });
                        },
                        getLabel: (String? value) => value,
                      ),
                      SizedBox(
                        height: height / 40,
                      ),
                      CustomTextField(
                        leftTextAlign: false,
                        hint: 'المهنة',
                        keyboardType: TextInputType.text,
                        textEditingController: jobController,
                        validateFun: nullValidator,
                      ),
                      SizedBox(
                        height: height / 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width / 2.4,
                  child: CustomTextField(
                    leftTextAlign: false,
                    width: width / 2.4,
                    hint: 'الوزن',
                    keyboardType: TextInputType.number,
                    textEditingController: weightController,
                    validateFun: nullValidator,
                  ),
                ),
                SizedBox(
                  width: width / 40,
                ),
                SizedBox(
                  width:width / 2.4,
                  child: CustomTextField(
                    leftTextAlign: false,
                    width: width / 2.4,
                    hint: 'الطول',
                    keyboardType: TextInputType.number,
                    textEditingController: hightController,
                    validateFun: nullValidator,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height:25,
            ),
            SignInButton(
              width: width,
              height: height,
              label: 'تسجيل'/*'استمرار'*/,
              labelcolor: Colors.white,
              primaryColor: kPrimaryColor,
              borderColor: Colors.white,
              ontop: () {
                FocusScope.of(context).unfocus();
                saveForm();
              },
            ),
          ],
        ),
      ),
      ),
    );
  }
}
