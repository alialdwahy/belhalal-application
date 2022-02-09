import 'package:flutter/material.dart';

class AppVariable {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController socialStatusController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController marriedTypeController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController skinColorController = TextEditingController();
  TextEditingController annualIncomeController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
}
