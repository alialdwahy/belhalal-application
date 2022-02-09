// ignore_for_file: file_names

import 'package:flutter/material.dart';

class AppDropdownInput<T> extends StatelessWidget {
  final String? hintText;
  final List<T> options;
  final T? value;
  final String? Function(T?)? getLabel;
  final void Function(T?)? onChanged;
  // ignore: use_key_in_widget_constructors
  const AppDropdownInput({
    this.hintText,
    this.options = const [],
    this.getLabel,
    this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return 
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          height: _height/14,
          width: _width/2.5,
                child:
                    DropdownButtonHideUnderline(
                      child: 
                      DropdownButton<T>(
                        alignment: Alignment.center,
                        borderRadius: const BorderRadius.all(
                         Radius.circular(20),
                      ), 
                        icon: const Icon(Icons.arrow_drop_down,color: Colors.black,),
                        iconSize: 30,
                        value: value,
                        isDense: true,
                        onChanged: onChanged!,
                        items: options.map((T value) {
                          return DropdownMenuItem<T>(
                            value: value,
                            child: Text(getLabel!(value)!,
                            textDirection: TextDirection.rtl ,
                            textAlign:TextAlign.right,
                            softWrap: true,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
        ),
        SizedBox(
          width: _width/3.5,
          child: Text(hintText!,textAlign: TextAlign.right,style: const TextStyle(color:Colors.white,fontSize: 15),)),

      ],
    );
  }
}

/*
return Container(
       height: _height/12,
      decoration: const ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                  Radius.circular(30),
                  ),
                  ),
                ),
      child: FormField<T>(
        builder: (FormFieldState<T> state) {
          textDirectionToAxisDirection(TextDirection.rtl);
          return InputDecorator(
            textAlign:TextAlign.right,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
              horizontal: 20.0, vertical: 10.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
            ),
            isEmpty: value == null || value == '',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DropdownButtonHideUnderline(
                  child: DropdownButton<T>(
                    value: value,
                    isDense: false,
                    onChanged: onChanged!,
                    items: options.map((T value) {
                      return DropdownMenuItem<T>(
                        value: value,
                        child: Text(getLabel!(value)!,
                        textDirection: TextDirection.rtl ,
                        textAlign:TextAlign.left,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                 Text(hintText!),
              ],
            ),
          );
        },
      ),
    );
*/