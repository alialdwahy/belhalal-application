import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:halal/constants/constants.dart';
import 'package:halal/controllers/auth_controller.dart';
import 'package:halal/controllers/user_controller.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class ViewPicBeforeSend extends StatefulWidget {
  var image;
  Function? send;
  bool? isOk = true;
  XFile? xImage;
  ViewPicBeforeSend(
      {Key? key, @required this.image, this.send, this.xImage, this.isOk})
      : super(key: key);

  @override
  State<ViewPicBeforeSend> createState() => _ViewPicBeforeSendState();
}
class _ViewPicBeforeSendState extends State<ViewPicBeforeSend> {
  final UserController _userController = Get.put(UserController());
  final AthController _authController = Get.put(AthController());

  _updateimgFromGallery() async {
    EasyLoadingStyle.light;
    EasyLoading.show(
      status: '... جاري الرفع ',
    ); // show loding indicator
       await _userController.updateUserPic(
        _authController.userId.value, widget.xImage!);
       await _userController.getUserInfo(_authController.userId.value);
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 1.2,
        child: Image.file(
          widget.image,
          width: 200.0,
          height: 200.0,
          fit: BoxFit.contain,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.isOk != true ? widget.send!() : _updateimgFromGallery();
          setState(() {
          });
          Navigator.of(context).pop(); 
        },
        backgroundColor: kPrimaryColor,
        elevation: 1,
        child: widget.isOk != true
            ? const Icon(
                Icons.send_outlined,
                color: Colors.white,
              )
            : const Text('Ok',
                style: TextStyle(color: Colors.white, fontSize: 14,fontWeight: FontWeight.bold)),
      ),
    );
  }
}
