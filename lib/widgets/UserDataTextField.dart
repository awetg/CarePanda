import 'package:flutter/material.dart';

class UserDataTextField extends StatelessWidget {
  final label;
  final value;
  final onChange;
  final controller;

  UserDataTextField(
      {@required this.label,
      this.value,
      @required this.onChange,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(primaryColor: Color(0xff027DC5)),
      child: Material(
        elevation: 3,
        child: TextFormField(
          controller: controller,
          initialValue: value,
          decoration: new InputDecoration(
            labelText: label,
            fillColor: Theme.of(context).cardColor,
            filled: true,
            isDense: true,
            contentPadding: EdgeInsets.only(top: 4, left: 4, bottom: 4),
            enabledBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).accentColor, width: 1.5),
            ),
          ),
          onChanged: onChange,
        ),
      ),
    );
  }
}
