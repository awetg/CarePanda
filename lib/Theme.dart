import 'package:carePanda/ServiceLocator.dart';
import 'package:carePanda/services/LocalStorageService.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class ThemeChanger with ChangeNotifier {
  var _storageService = locator<LocalStorageService>();

  ThemeData _themeData;

  ThemeChanger(this._themeData);

  final darkTheme = ThemeData(
    //primarySwatch: Colors.grey,
    //primaryColor: Colors.black,
    brightness: Brightness.dark,
    //backgroundColor: const Color(0xFF212121),
    accentColor: Color(0xff60cff4),
    accentIconTheme: IconThemeData(color: Color(0xff86B6E0)),
    toggleableActiveColor: Color(0xffA0C3E2),
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(backgroundColor: Color(0xff212121)),
    //dividerColor: Colors.black12,
    //cardColor: Colors.black,
  );

  final lightTheme = ThemeData(
    brightness: Brightness.light,

    //primarySwatch: Colors.grey,
    primaryColor: Colors.white,
    primaryColorDark: Colors.black,
    //backgroundColor: Colors.white,
    primaryColorLight: Colors.white,
    accentColor: Color(0xff027DC5),
    accentIconTheme: IconThemeData(color: Color.fromRGBO(2, 125, 197, 90)),
    toggleableActiveColor: Color(0xffA0C3E2),

    dialogBackgroundColor: Colors.white,
    buttonColor: Color(0xff027DC5),
    disabledColor: Color(0xffA0C3E2),
    cardColor: Colors.white,

    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(backgroundColor: Colors.white),
  );

  getTheme() => _themeData = _storageService.darkTheme ? darkTheme : lightTheme;

  setTheme(String theme) {
    if (theme == "Dark") {
      _storageService.darkTheme = true;
      _themeData = darkTheme;
    } else {
      _storageService.darkTheme = false;
      _themeData = lightTheme;
    }
    notifyListeners();
  }
}
