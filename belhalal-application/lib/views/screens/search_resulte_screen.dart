// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:halal/constants/constants.dart';
import 'package:halal/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:halal/views/screens/user_info.dart';

class SearchResults extends StatefulWidget {
  const SearchResults({Key? key}) : super(key: key);

  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  final UserController _userController = Get.put(UserController());

 @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            const SizedBox(
              width: 5,
            ),
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 30,
                color: kPrimaryColor,
              ),
              onPressed: () {
        
               Get.back();
              },
            ),
          ],
        ),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'نتائج البحث',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: _userController.searchedUsers.value.length,
        itemBuilder: (context, index) {
          return ListTile(
            
            shape: const Border(
              top: BorderSide(color: Colors.grey, width: 1),
            ),
            title: Text(_userController.searchedUsers.value[index].name!),
            leading: _userController.searchedUsers.value[index].imageUrl!.length> 3
                ? CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage(
                        _userController.searchedUsers.value[index].imageUrl!),
                  )
                : const CircleAvatar(
                    radius: 22,
                    backgroundImage:
                        AssetImage('assets/images/belhahaIcon.png'),
                  ),
            onTap: (){
             // ignore: invalid_use_of_protected_member
             Get.to(UserInfo(myUser: _userController.searchedUsers.value[index]));
            },
          );
        },
      ),
    );
  }
}
