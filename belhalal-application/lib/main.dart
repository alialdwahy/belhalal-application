import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:halal/constants/constants.dart';
import 'package:halal/controllers/getx_network_manage.dart';
import 'package:halal/controllers/network_binding.dart';
import 'package:halal/fcm/app_fcm.dart';
import 'package:halal/views/screens/loose_network_connection.dart';
import 'package:halal/views/screens/splash_screen.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

//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 outlook
//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 gmail
///
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_live_51JyNA2BfYBsSPPlFzi9X1RToQlAnWM5jLgOy9vpZD88lkmJoDAK0ukR9fE2yaTARQ4jYZWwL1OKqQj1vWMF2jKCu00heNy6D4f';
  Stripe.merchantIdentifier = 'Bel7alal';
  await Firebase.initializeApp();
  await Stripe.instance.applySettings();
   await AppFcm.fcmInstance.init();
   await AppFcm.fcmInstance.getTokenFCM();
  await GetStorage.init();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: NetworkBinding(),
      title: 'بالحلال',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        // ignore: deprecated_member_use
        accentColor: const Color(0xFFFEF9EB),
      ),
      home: const App(), //NewLoginWithPhone(),
      builder: EasyLoading.init(),
    );
  }
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final GetXNetworkManager _networkManager = Get.find<GetXNetworkManager>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetXNetworkManager>(builder: (builder) {
      return _networkManager.connectionType == 0
          ? const NoInternetConnection()
          : FutureBuilder(
              // Initialize FlutterFire:
              future: _initialization,
              builder: (context, snapshot) {
                // Check for errors
                if (snapshot.hasError) {
                  return const SomethingWentWrong();
                }
                // Once complete, show your application
                if (snapshot.connectionState == ConnectionState.done) {
                  return const SplashScreen();
                }

                // Otherwise, show something whilst waiting for initialization to complete
                return const Loading();
              },
            );
    });
  }
}

class SomethingWentWrong extends StatelessWidget {
  const SomethingWentWrong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Error'),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }
}
///{
//         "amount": "0.00",
//         "detail": "Available within an hour",
//         "identifier": "in_store_pickup",
//         "label": "In-Store Pickup"
//       },
//       {
//         "amount": "4.99",
//         "detail": "5-8 Business Days",
//         "identifier": "flat_rate_shipping_id_2",
//         "label": "UPS Ground"
//       },
//       {
//         "amount": "29.99",
//         "detail": "1-3 Business Days",
//         "identifier": "flat_rate_shipping_id_1",
//         "label": "FedEx Priority Mail"
//       }