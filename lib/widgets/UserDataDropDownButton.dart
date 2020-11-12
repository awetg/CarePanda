import 'package:flutter/material.dart';

class UserDataDropDownButton extends StatelessWidget {
  final settingName;
  final value;
  final data;
  final onChange;

  UserDataDropDownButton(
      {this.settingName, this.value, this.data, this.onChange});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(children: [
        Expanded(
          child: Text(settingName),
        ),
        Container(
          padding: EdgeInsets.only(left: 6),
          height: 40,
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(4)),
          child: DropdownButton(
            dropdownColor: Theme.of(context).cardColor,
            value: value.toString(),
            underline: SizedBox(),
            items: [
              for (final values in data)
                DropdownMenuItem<String>(
                  key: ValueKey(values),
                  value: values,
                  child: Text(values),
                )
            ],
            onChanged: onChange,
          ),
        ),
      ]),
    );
  }
}
