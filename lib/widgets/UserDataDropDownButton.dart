import 'package:carePanda/services/LocalStorageService.dart';
import 'package:carePanda/services/ServiceLocator.dart';
import 'package:flutter/material.dart';

class UserDataDropDownButton extends StatelessWidget {
  final settingName;
  final value;
  final data;
  final floorData;
  final onChange;
  final _storageService = locator<LocalStorageService>();

  UserDataDropDownButton(
      {this.settingName, this.value, this.data, this.onChange, this.floorData});

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
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 0,
                  offset: _storageService.darkTheme
                      ? Offset(0, 0)
                      : Offset(0, 1), // changes position of shadow
                ),
              ],
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
