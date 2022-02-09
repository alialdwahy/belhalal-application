import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CatagorySelector extends StatefulWidget {
  const CatagorySelector({Key? key}) : super(key: key);

  @override
  _CatagorySelectorState createState() => _CatagorySelectorState();
}

class _CatagorySelectorState extends State<CatagorySelector> {
  int selectedIndex = 0;
  final List<String> catagories = ['Messages', 'Online', 'Groups', 'Requests'];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      color: Theme.of(context).primaryColor,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: catagories.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                   selectedIndex = index;
                });
              },
                child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 15.0,
                ),
                child: Text(
                  catagories[index],
                  style: TextStyle(
                      color: index == selectedIndex
                          ? Colors.white
                          : Colors.white60,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2),
                ),
              ),
            );
          }),
    );
  }
}
