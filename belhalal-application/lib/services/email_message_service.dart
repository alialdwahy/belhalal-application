import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:halal/models/auth.dart';
import 'package:url_launcher/url_launcher.dart';

class  EmailMessageService {
  EmailMessageService._();
  static EmailMessageService emailMessageService = EmailMessageService._();

   Future<AthUser>getUsernameAndEmail( ) async {
    try {
      var documentSnapshot = await FirebaseFirestore.instance
          .collection('account')
          .get();
          documentSnapshot.docs.first;
      // ignore: unnecessary_cast
      var userMap = documentSnapshot.docs.first.data() as Map<String, dynamic>;
      return AthUser.fromJson(userMap);
    } catch (e) {
      return AthUser();
    }
  }

sendEmail(String complainantPerson,String defendantPerson ,AthUser myuser)async{
 String otherEmail =myuser.email!;
 String title = "شكوى";
 String body = '''
  
مرحبا ، فريق تطبيق بالحلال
أنا المستخدم $complainantPerson أقدم شكوى على المستخدم $defendantPerson

التفاصيل /

تحياتي
$complainantPerson,
 ''';

 Uri uri = Uri(
        scheme: 'mailto', path: otherEmail, query: 'subject=$title&body=${Uri.encodeFull(body)}');
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      Get.snackbar("فشل ","يرجى المحاولة مرة أخری");
    }


  }
callUsEmail(String complainantPerson,AthUser myuser)async{
 String otherEmail =myuser.email!;
 String title = "الموضوع /";
 String body = '''
  
مرحبا ، فريق تطبيق بالحلال
أنا المستخدم $complainantPerson 

التفاصيل /

تحياتي
$complainantPerson,
 ''';

 Uri uri = Uri(
        scheme: 'mailto', path: otherEmail, query: 'subject=$title&body=${Uri.encodeFull(body)}');
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      Get.snackbar("فشل ","يرجى المحاولة مرة أخری");
    }


  }



}