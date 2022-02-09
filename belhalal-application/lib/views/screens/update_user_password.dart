import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:halal/constants/constants.dart';
import 'package:halal/controllers/auth_controller.dart';
import 'package:halal/views/widgets/custom_text_field.dart';
import 'package:get/get.dart';

import 'forget_mypassword_email_was__sent.dart';

class UpdateUserPassword extends StatefulWidget {
  const UpdateUserPassword({Key? key}) : super(key: key);

  @override
  State<UpdateUserPassword> createState() => _UpdateUserPasswordState();
}

class _UpdateUserPasswordState extends State<UpdateUserPassword> {
  TextStyle style1 = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AthController _athController = Get.put(AthController());
  nullValidator(String value) {
    if (value == '' || value.isEmpty) {
      return 'حقل مطلوب';
    }
    return null;
  }


  changePassword()async{
  await _athController.resetPassword(_emailController.text);
  }

  // ignore: non_constant_identifier_names
  SaveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
     changePassword();
     Get.to(()=>const ForgetMyPassEmail());
    }
  }
    bool isEmail(String input) => EmailValidator.validate(input);
    // validate email if empty or not correct
    emailValidator(String value) {
    //checkIsEmailAlreadyExist(value);
      if (value == '' || value.isEmpty) {
        return  "حقل مطلوب";
      }
      if (!isEmail(value)) {
        return  "الايميل غير صحيح";
      }
      
      return null;
    }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        title: Text(
          'تغيير كلمة المرور',
          style: style1,
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20)),
      ),
      backgroundColor: kPrimaryColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Center(
          // ignore: avoid_unnecessary_containers
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: width / 1.3,
                    child: Form(
                       key:_formKey ,
                      child: Column(
                        children: [
                          CustomTextField(
                            leftTextAlign: true,
                            keyboardType: TextInputType.emailAddress,
                            //key: ,
                            hint: 'قم بإدخال ايميلك',
                            textEditingController: _emailController,
                            onChanged: (value) {},
                            onSaved: (value) {},
                            validateFun: emailValidator,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text('سيتم إرسال رسالة تحقق إلى إيميلك',
                          style: TextStyle(color: Colors.black,fontSize: 12),),
                          const SizedBox(
                            height: 45,
                          ),
                          InkWell(
                              onTap: () {
                               SaveForm();
                               FocusScope.of(context).unfocus(); 
                              },
                              child: Text('أرسل', style: style1)),
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
