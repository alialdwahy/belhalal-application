import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DropDownTxtField extends StatefulWidget {
   final Function(String?)? onChanged;
   String? dropdownValue ;
   DropDownTxtField({Key? key,required this.onChanged,this.dropdownValue}) : super(key: key);
  @override
  _DropDownTxtFieldState createState() => _DropDownTxtFieldState();
}
class _DropDownTxtFieldState extends State<DropDownTxtField> {
  // final List<String> _dropdownItems = ['الكويت', 'العراق', 'السعودية'];
  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return DropdownButtonHideUnderline(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              InputDecorator(
                decoration: const InputDecoration(
                  // filled: false,
                  prefixIcon:  Icon(Icons.location_on),
                  labelText: 'From',
                ),
                child: DropdownButton<String>(
                  value: widget.dropdownValue,
                  isDense: false,
                  onChanged: widget.onChanged!,
                  items: <String>['السعودية', 'الكويت', 'العراق'].map<DropdownMenuItem<String>>(
                    (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Container(
                       padding: const EdgeInsets.all(2),
                        child: Text(value)),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
