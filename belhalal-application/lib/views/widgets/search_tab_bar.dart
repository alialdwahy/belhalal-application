import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:halal/constants/constants.dart';
import 'package:halal/controllers/auth_controller.dart';
import 'package:halal/controllers/user_controller.dart';
import 'package:halal/models/user.dart';
import 'package:halal/views/screens/search_resulte_screen.dart';
import 'package:halal/views/widgets/drop_down_text_field.dart';

class SearchForm extends StatefulWidget {
  const SearchForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  // final List<String> _dropdownItems = ['الكويت', 'العراق', 'السعودية'];
  RangeValues _rangeSliderDiscreteValues = const RangeValues(26, 45);
  String _dropdownValue = 'السعودية';
  double newAge = 25;
  TextEditingController ageController = TextEditingController();
  final UserController _userConreoler = Get.put(UserController());
  final AthController _athController = Get.put(AthController());
  List<MyUser> users = <MyUser>[];

  @override
  void initState() {
    super.initState();
  }

  getUsers() async {
    EasyLoading.show(status: "... جاري التحميل");
    List<MyUser> searchedUsers = await _userConreoler.searchAboutSpesificUser(
      _athController.userId.value,
      _rangeSliderDiscreteValues.start.toInt(),
      _rangeSliderDiscreteValues.end.toInt(),
      _dropdownValue,
    );
    if (searchedUsers.isNotEmpty) {
      users.addAll(searchedUsers);
      _userConreoler.searchedUsers.value = searchedUsers;
      Get.to(const SearchResults());
    }
    setState(() {});
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Center(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 50.0, right: 50.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 70),
                    child: Text('اختر صفة أو أكثر لتبدأ بالبحث',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600)),
                  ),
                  SizedBox(
                    height: height / 40,
                  ),
                  SizedBox(
                    height: height / 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RangeSlider(
                        values: _rangeSliderDiscreteValues,
                        min: 21,
                        max: 70,
                        activeColor: kPrimaryColor,
                        inactiveColor: Colors.black,
                        divisions: 49,
                        labels: RangeLabels(
                          _rangeSliderDiscreteValues.start.round().toString(),
                          _rangeSliderDiscreteValues.end.round().toString(),
                        ),
                        onChanged: (values) {
                          setState(() {
                            _rangeSliderDiscreteValues = values;
                          });
                        },
                      ),
                      const Text(': العمر',
                          style: TextStyle(color: Colors.black, fontSize: 14)),
                    ],
                  ),
                  SizedBox(
                    height: height / 40,
                  ),
                  DropDownTxtField(
                    dropdownValue: _dropdownValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        _dropdownValue = newValue!;
                      });
                    },
                  ),
                  SizedBox(
                    height: height / 10,
                  ),
                  SizedBox(
                    width: width / 4,
                    child: TextButton(
                      onPressed: () {
                        getUsers();
                      },
                      child: const Text(
                        'بحث',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(kPrimaryColor),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                        elevation: MaterialStateProperty.all(4.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
