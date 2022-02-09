import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:halal/models/auth.dart';
import 'package:halal/services/email_message_service.dart';
import 'package:get/get.dart';
class EmailMessageController extends GetxController {
  var userEmail =  AthUser().obs;
  getUsernameAndEmail() async {
    userEmail.value = await EmailMessageService.emailMessageService.getUsernameAndEmail();
    update();
  }

  sendEmailOfComplain(
      String complainantPerson, String defendantPerson) async {
    await getUsernameAndEmail();
    await EmailMessageService.emailMessageService
        .sendEmail(complainantPerson, defendantPerson, userEmail.value);
  }
  sendEmailOfCallUs(
      String complainantPerson) async {
    await getUsernameAndEmail();
    await EmailMessageService.emailMessageService
        .callUsEmail(complainantPerson, userEmail.value);
  }
}
