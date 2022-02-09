import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:halal/constants/constants.dart';
import 'package:halal/controllers/user_controller.dart';
import 'package:halal/views/widgets/age_slider.dart';
import 'package:halal/views/widgets/belhalal_logo.dart';
import 'package:halal/views/widgets/drop_down_input.dart';
import 'package:halal/views/widgets/drop_down_text_field.dart';
import 'complete_registration_screen2.dart';

class CompleteRegistration1 extends StatefulWidget {
  const CompleteRegistration1({Key? key}) : super(key: key);
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<CompleteRegistration1> {
  final TextEditingController countryController = TextEditingController();
  final UserController _userController = Get.put(UserController());
  String _dropdownValue = 'السعودية';
  double newAge = 21;
  final _formKey = GlobalKey<FormState>();
  String gendervalue = 'رجل';
  String socialStatusValue = 'لم يسبق الزواج';

  var genderItems = ['رجل', 'امراة'];
  var socialStatusItems = [
    'لم يسبق الزواج',
    'متزوج',
    'مطلق/مطلقة',
    'أرمل/أرملة',
  ];

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
      _userController.myUser.value.age = newAge.toInt();
      _userController.myUser.value.socialStatusValue = socialStatusValue;
      _userController.myUser.value.gendervalue = gendervalue;
      _userController.myUser.value.country = _dropdownValue;

      Get.to(() => const CompleteRegistration2());
    }else{

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
                        hintText: "الجنس",
                        options: genderItems,
                        value: gendervalue,
                        onChanged: (String? value) {
                          setState(() {
                            gendervalue = value!;
                          });
                        },
                        getLabel: (String? value) => value,
                      ),
                      SizedBox(
                        height: height / 40,
                      ),
                      AppDropdownInput(
                        hintText: "الحالة الاجتماعية",
                        options: socialStatusItems,
                        value: socialStatusValue,
                        onChanged: (String? value) {
                          setState(() {
                            socialStatusValue = value!;
                          });
                        },
                        getLabel: (String? value) => value,
                      ),
                      SizedBox(
                        height: height / 40,
                      ),
                      AgeSlider(
                        age: newAge,
                        activeColor: Colors.white,
                        inactiveColor: Colors.black,
                        thumbColor: Colors.white60,
                        textColor: Colors.white,
                        key: widget.key,
                        onChange: (value) {
                          setState(() {
                          newAge = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: height / 40,
                      ),
                      DropDownTxtField(
                        dropdownValue: _dropdownValue,
                        onChanged:(String? newValue) {
                          setState(() {
                            _dropdownValue = newValue!;
                          });
                        },
                        ),
                      SizedBox(
                        height: height / 40,
                      ),
                      SizedBox(
                        height: height / 30,
                      ),
                      GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            saveForm();
                          },
                          child: const Text(
                            'استمرار',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
