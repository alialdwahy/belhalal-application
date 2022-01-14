import 'dart:io';
import 'package:belhalal_update/screen/splash_screen/splash_screen.dart';
import 'package:belhalal_update/utils/storage/storage_helper.dart';
import 'package:belhalal_update/utils/storage/storage_keys.dart';
import 'package:belhalal_update/value/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';



const debug = true;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  await GetStorage.init();
  await StorageHelper.getInstance();

  WidgetsFlutterBinding.ensureInitialized();
  // await di.init();
  //await FlutterDownloader.initialize(debug: debug);
  final storageToken = await StorageHelper.get(StorageKeys.token);

  print(storageToken);

  runApp(MyApp());
  configLoading();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: GetMaterialApp(

        debugShowCheckedModeBanner: false,

        title: 'Flutter Demo',
        theme: ThemeData(

          primaryColor: Colors.red,

          // Define the default font family.
          fontFamily: 'Georgia',


        ),
        home: SplashScreen(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
