import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:halal/constants/constants.dart';

// ignore: must_be_immutable
class MessagePicView extends StatelessWidget {
  MessagePicView({ Key? key,@required this.messageSrc}) : super(key: key);
  String? messageSrc='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: kPrimaryColor,
        leading:IconButton(
           onPressed: ()=>Navigator.of(context).pop(),
           icon: const Icon(Icons.arrow_back,color: Colors.white,),
           ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height /1.2,
        child:Image.network(
          messageSrc!,
          fit: BoxFit.contain,
        )),
     
    );
  }
}