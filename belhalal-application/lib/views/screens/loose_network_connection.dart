import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:halal/constants/constants.dart';

class NoInternetConnection extends StatelessWidget {
  const NoInternetConnection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.red[100],
        body: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 7),
            height: height / 2.1,
            width: width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('انـقـطـع الاتـصـال',
                style: TextStyle(color: kPrimaryColor,fontSize: 26,fontWeight: FontWeight.bold),
                ),
                const Text('الـرجـاء التـحـقـق من الانـتـرنـت الخـاص بـك',
                style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),
                ),
                TextButton(
                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(const Size.fromWidth(120),),
                      elevation: MaterialStateProperty.all(2.0),
                      backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                      shadowColor: MaterialStateProperty.all(Colors.black38),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)))),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Center(
                      child: Text(
                        'الرجـوع',
                        style: TextStyle(
                          color: Colors.white ,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
