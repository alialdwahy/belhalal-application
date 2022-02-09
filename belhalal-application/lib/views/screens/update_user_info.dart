import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:halal/constants/constants.dart';
import 'package:halal/controllers/auth_controller.dart';
import 'package:halal/controllers/user_controller.dart';
import 'package:halal/models/user.dart';
import 'package:halal/utils/word_filter.dart';
import 'package:halal/views/screens/login.dart';
import 'package:halal/views/widgets/age_slider.dart';
import 'package:halal/views/widgets/custom_text_field.dart';
import 'package:get/get.dart';
import 'package:halal/views/widgets/drop_down_input.dart';
import 'package:halal/views/widgets/drop_down_text_field.dart';
import 'package:logger/logger.dart';

class UpdateUserInfo extends StatefulWidget {
  const UpdateUserInfo({Key? key}) : super(key: key);

  @override
  State<UpdateUserInfo> createState() => _UpdateUserInfoState();
}

class _UpdateUserInfoState extends State<UpdateUserInfo> {
  TextStyle style1 = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );
  final UserController _userController = Get.put(UserController());
  final AthController _authController = Get.put(AthController());
  double newAge = 25;
  int intAge = 25;
  String socialStatusValue = 'لم يسبق الزواج';
  var socialStatusItems = [
    'لم يسبق الزواج',
    'متزوج',
    'مطلق/مطلقة',
    'أرمل/أرملة',
  ];
  String annualIncomeValue = 'أقل من 50\$ ألف';
  var annualIncomeTypes = [
    'أكثر من 150\$ ألف',
    'أقل من 100\$ ألف',
    'أقل من 50\$ ألف'
  ];
  String marriedTypeValue = 'دائم معلن';
  var marriedTypes = ['دائم معلن', 'دائم غير معلن', 'آخر'];
  updateUserInfo(MyUser myUser) {
    _userController.updateUserInfo(_authController.userId.value, myUser);
  }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordConroller = TextEditingController();
  // final TextEditingController _ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController hightController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("تراجع"),
      onPressed: () {
        Get.back();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("حذف الحساب"),
      onPressed: () {
        _authController.deleteMyaccount();
        Get.offAll(const LoginScreen());
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("حذف الحساب"),
      content: const Text(" هل تريد بالفعل حذف الحساب ؟"),
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

  setData() {
    _usernameController.text = _userController.myUser.value.name!;
    // _emailController.text = _userController.myUser.value.email!;
    // _passwordConroller.text = _userController.myUser.value.password!;
    // _ageController.text = _userController.myUser.value.age!.toString();
    intAge = newAge.toInt();
    intAge = _userController.myUser.value.age!;
    newAge = _userController.myUser.value.age!.toDouble();
    weightController.text = _userController.myUser.value.weight!;
    hightController.text = _userController.myUser.value.long!;
    _salaryController.text = _userController.myUser.value.annualIncomeValue!;
    _jobController.text = _userController.myUser.value.job!;
    marriedTypeValue = _userController.myUser.value.marriedTypeValue!;
    annualIncomeValue = _userController.myUser.value.annualIncomeValue!;
    socialStatusValue = _userController.myUser.value.socialStatusValue.toString();
  }

  saveNewData() {
    _userController.myUser.value.name = _usernameController.text;
    // _userController.myUser.value.email = _emailController.text;
    // _userController.myUser.value.password = _passwordConroller.text;
    // _userController.myUser.value.age = int.parse(_ageController.text);
    _userController.myUser.value.age = newAge.toInt(); //new update
    _userController.myUser.value.weight = weightController.text;
    _userController.myUser.value.long = hightController.text;
    // _userController.myUser.value.annualIncomeValue = _salaryController.text;
    _userController.myUser.value.socialStatusValue = socialStatusValue;
    _userController.myUser.value.job = _jobController.text;
    _userController.myUser.value.marriedTypeValue = marriedTypeValue;
    _userController.myUser.value.annualIncomeValue = annualIncomeValue;
  }

  nullValidator(String value) {
    if (value == '' || value.isEmpty) {
      return 'حقل مطلوب';
    }
    return null;
  }

  // ignore: non_constant_identifier_names
  SaveForm() {
    Logger().d("one");
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Logger().d("two");
      if(WordFilter.instance.isBadWord(_usernameController.text.toString())){
        Logger().d("three");
        Get.snackbar("عذرا", "يرجى التحلي بالاخلاق والمعاير المنسابة لمجتمعاتنا واختر اسم مناسب لها");
        EasyLoading.dismiss(animation: true);
        // return ;
      }else{
        Logger().d("fore");
        EasyLoading.show(status: "... جاري التحميل");
        saveNewData();
        updateUserInfo(_userController.myUser.value);
        EasyLoading.dismiss();
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void initState() {
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: kPrimaryColor,
          centerTitle: true,
          title: Text(
            'تحرير الملف',
            style: style1,
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon:
                  const Icon(Icons.arrow_back, color: Colors.white, size: 20)),
        ),
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Center(
            // ignore: avoid_unnecessary_containers
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: width / 1.3,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              width: width / 1.4,
                              leftTextAlign: false,
                              keyboardType: TextInputType.name,
                              hint: 'اسم المستخدم',
                              textEditingController: _usernameController,
                              onChanged: (value) {},
                              onSaved: (value) {},
                              validateFun: nullValidator,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            AgeSlider(
                              //new
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
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: width / 3,
                                  child: CustomTextField(
                                    leftTextAlign: false,
                                    width: width / 3,
                                    hint: 'الوزن',
                                    keyboardType: TextInputType.number,
                                    textEditingController: weightController,
                                    validateFun: nullValidator,
                                  ),
                                ),
                                SizedBox(
                                  width: width / 25,
                                ),
                                SizedBox(
                                  height: 50,
                                  width: width / 3,
                                  child: CustomTextField(
                                    leftTextAlign: false,
                                    width: width / 3,
                                    hint: 'الطول',
                                    keyboardType: TextInputType.number,
                                    textEditingController: hightController,
                                    validateFun: nullValidator,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
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
                            const SizedBox(
                              height: 15,
                            ),
                            AppDropdownInput(
                              hintText: "نوع الزواج",
                              options: marriedTypes,
                              value: marriedTypeValue,
                              onChanged: (String? value) {
                                setState(() {
                                  marriedTypeValue = value!;
                                });
                              },
                              getLabel: (String? value) => value,
                            ),
                            const SizedBox(
                              height: 15,
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
                            const SizedBox(
                              height: 25,
                            ),
                            GestureDetector(
                                onTap: () {
                                  SaveForm();
                                },
                                child: Text('حفظ', style: style1)),
                            SizedBox(
                              height: height / 10,
                            ),
                            Builder(
                              builder: (context) {
                                return TextButton(
                                  clipBehavior: Clip.antiAlias,
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
                                    showAlertDialog(context);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(
                                        Icons.delete_forever,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 7,
                                      ),
                                      Text(
                                        'حذف الحساب',
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 15),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                    ],
                                  ),
                                );
                              }
                            ),
                          ],
                        ),
                      ),
                    )
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
