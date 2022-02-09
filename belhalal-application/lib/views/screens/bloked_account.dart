import 'package:flutter/material.dart';

class BlockedAcount extends StatelessWidget {
  const BlockedAcount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.block,size: 150,),
            Text(
              "Sorry",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text("Your Acount Was Blocked"),
          ],
        ),
      ),
    );
  }
}
