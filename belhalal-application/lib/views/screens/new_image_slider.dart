import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:halal/constants/constants.dart';
import 'package:halal/controllers/app_controller.dart';
import 'package:halal/controllers/user_controller.dart';
import 'package:halal/utils/shared_method.dart';
import 'package:halal/views/screens/user_info.dart';
import 'package:logger/logger.dart';

final themeMode = ValueNotifier(2);

class CarouselDemo extends StatelessWidget {
  const CarouselDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder: (context, value, g) {
        return MaterialApp(
          initialRoute: '/',
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.values.toList()[value as int],
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (ctx) => const CarouselDemoHome(),
            '/fullscreen': (ctx) => const FullscreenSliderDemo(),
          },
        );
      },
      valueListenable: themeMode,
    );
  }
}

class CarouselDemoHome extends StatelessWidget {
  const CarouselDemoHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: FullscreenSliderDemo(),
    );
  }
}
class FullscreenSliderDemo extends StatefulWidget {
  const FullscreenSliderDemo({Key? key}) : super(key: key);

  @override
  State<FullscreenSliderDemo> createState() => _FullscreenSliderDemoState();
}

class _FullscreenSliderDemoState extends State<FullscreenSliderDemo> {
  final AppController _appController = Get.put(AppController());
  final UserController _userController = Get.put(UserController());
  bool? _visible = true;

  getUsers() async {
    // EasyLoading.show(status: "جاري التحميل ..");
    await _appController.getUsers();
    // EasyLoading.dismiss();
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      getUsers();
    });
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      //asynchronous delay
      if (mounted) {
        //checks if widget is still active and not disposed
        setState(() {
          //tells the widget builder to rebuild again because ui has updated
          _visible =
              false; //update the variable declare this under your class so its accessible for both your widget build and initState which is located under widget build{}
        });
      }
    });
    // Logger().d("user_email_${_userController.myUser.value.email}");
  }
  getData() async {
    await _appController.getUsers();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<AppController>(
          init: _appController,
          builder: (logic) {
            return Stack(children: [
              Builder(
                builder: (context) {
                  final double height = MediaQuery.of(context).size.height;
                  if (logic.isUserLoading) {
                    return  const Center(child:  CircularProgressIndicator());
                  } else {
                    return Obx(() => CarouselSlider(
                          options: CarouselOptions(
                              enableInfiniteScroll: false,
                              reverse: true,
                              height: height,
                              initialPage:
                                  _appController.currentIndexSlider.value,
                              viewportFraction: 1.0,
                              enlargeCenterPage: false,
                              onPageChanged: (v, s) {
                                _appController.setSliderIndex(v);
                                if (v >=
                                    _appController.myUsers.value.length / 2) {
                                  getData();
                                }
                              }
                              // autoPlay: false,
                              ),
                          items: _appController.myUsers.value
                              // ignore: avoid_unnecessary_containers
                              .map((item) => GestureDetector(
                                    onTap: () {
                                      Get.to(UserInfo(
                                        myUser: item,
                                      ));
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(),
                                            color:
                                                kPrimaryColor, //.withOpacity(0.5),
                                          ),
                                          child: item.imageUrl!.length > 3
                                              ? AppSharedMethod.instance
                                                  .imageNetwork(
                                                      url: item.imageUrl
                                                          .toString(),
                                                      width: double.infinity,
                                                      height: double.infinity)
                                              /*CachedNetworkImage(
                                          imageUrl: item.imageUrl!,
                                          color: Colors.white,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) => const Center(
                                              child: CircularProgressIndicator(
                                            color: Colors.blue,
                                            backgroundColor: Colors.white,
                                          )),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        )*/
                                              : item.gendervalue == "رجل"
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: SvgPicture.asset(
                                                        "assets/images/meal.svg",
                                                        fit: BoxFit.contain,
                                                      ),
                                                    )
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: SvgPicture.asset(
                                                        "assets/images/femail.svg",
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 60.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  color: Colors.transparent,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 50.0),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                                ' ${item.name}  ',
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                            const Text(
                                                                '   الاسم',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                                '  ${item.age} ',
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                            const Text(
                                                                '   العمر',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: const [
                                                            Text(
                                                                '        لمعرفة المزيد اضغط على  الصورة',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ));
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 45.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                      color: Colors.transparent,
                      child: Visibility(
                        visible: _visible!,
                        child: const Text(
                          'اسحب الشاشة لليمين لرؤية التالي واليسار لرؤية السابق',
                          style: TextStyle(fontSize: 12),
                        ),
                      )),
                ),
              ),
            ]);
          }),
    );
  }
}
