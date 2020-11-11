import 'package:carePanda/ServiceLocator.dart';
import 'package:carePanda/services/LocalStorageService.dart';
import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  var _storageService = locator<LocalStorageService>();

  ThemeData _themeData;

  ThemeChanger(this._themeData);

  final darkTheme = ThemeData(
    brightness: Brightness.dark,
    dialogBackgroundColor: Color(0xff303030),
    accentColor: Color(0xff60cff4),
    accentIconTheme: IconThemeData(color: Color(0xff86B6E0)),
    toggleableActiveColor: Color(0xffA0C3E2),
    dialogTheme: DialogTheme(elevation: 15),
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(backgroundColor: Color(0xff212121)),
  );

  final lightTheme = ThemeData(
    brightness: Brightness.light,
    canvasColor: Color(0xffF8F8F6),
    primaryColor: Colors.white,
    primaryColorDark: Colors.black,
    primaryColorLight: Colors.white,
    accentColor: Color(0xff027DC5),
    accentIconTheme: IconThemeData(color: Color.fromRGBO(2, 125, 197, 90)),
    toggleableActiveColor: Color(0xffA0C3E2),
    dialogBackgroundColor: Color(0xffF8F8F6),
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
