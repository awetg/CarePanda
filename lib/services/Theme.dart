import 'package:carePanda/services/ServiceLocator.dart';
import 'package:carePanda/services/LocalStorageService.dart';
import 'package:flutter/material.dart';

// TODO: fix outlined color of TextFormField changing to white on light theme
// relevant widget/code can be found on question_page.dart

class ThemeChanger with ChangeNotifier {
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
    // toggleableActiveColor: Color(0xffA0C3E2),
    dialogBackgroundColor: Color(0xffF8F8F6),
    buttonColor: Color(0xff027DC5),
    disabledColor: Color(0xffA0C3E2),
    cardColor: Colors.white,
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(backgroundColor: Colors.white),
  );

  getTheme() => locator<LocalStorageService>().darkTheme ?? false
      ? darkTheme
      : lightTheme;

  setTheme(ThemeType theme) {
    if (theme == ThemeType.Dark) {
      locator<LocalStorageService>().darkTheme = true;
    } else {
      locator<LocalStorageService>().darkTheme = false;
    }
    notifyListeners();
  }
}

// using enumeration type for dark and light theme names
// becausing using non constant string will lead to errors
enum ThemeType { Dark, Light }
