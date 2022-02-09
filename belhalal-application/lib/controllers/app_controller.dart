import 'package:get/get.dart';
import 'package:halal/controllers/auth_controller.dart';
import 'package:halal/controllers/subscription_controller.dart';
import 'package:halal/controllers/user_controller.dart';
import 'package:halal/models/person.dart';
import 'package:halal/models/user.dart';
import 'package:logger/logger.dart';

class AppController extends GetxController {
  var counreyname = "".obs;
  var myUsers = <MyUser>[].obs;
  var currentIndexSlider = 0.obs;
  bool isUserLoading = false;
  final UserController _controller = Get.put(UserController());
  final AthController _authController = Get.put(AthController());

  final SubscriptionController _subscriptionController =
      Get.put(SubscriptionController());

  getUsers() async {
    isUserLoading = true;
    update();
    Logger().d("test_${_authController.userId.value} , ${_controller.myUser.value.gendervalue}");
     if(/*!GetUtils.isNull(_controller.myUser.value)  &&*/ _controller.myUser.value.gendervalue != null) {
      await _controller.getAllPeople(_authController.userId.value,
          "${_controller.myUser.value.gendervalue}");
      isUserLoading = false;
      update();
    }else{
      // isUserLoading = false;
      // update();
    }
  }

  getUserId(String userId, int index) async {
    return myUsers[index].id;
  }

  updateFavUserImagePath(
    List<MyPerson> favList, String userId) async{
    String? newImagePath;
    for (var i = 0; i < myUsers.length; i++) {
      if (myUsers[i].id! == userId && favList[i].id == userId) {
        favList[i].imagePath = myUsers[i].imageUrl;
        newImagePath = favList[i].imagePath!;
      }
    }
    if (newImagePath!=null){
          return newImagePath;
    }
  }

  setSliderIndex(int index) {
    currentIndexSlider.value = index;
  }
}
