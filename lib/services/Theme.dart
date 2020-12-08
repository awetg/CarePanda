import 'package:carePanda/services/ServiceLocator.dart';
import 'package:carePanda/services/LocalStorageService.dart';
import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  // a singleton contructor
  static final ThemeChanger _themeChanger = ThemeChanger._privateConstructor();
  factory ThemeChanger() {
    return _themeChanger;
  }
  ThemeChanger._privateConstructor();

  // Dark theme
  final _darkTheme = ThemeData(
    brightness: Brightness.dark,
    dialogBackgroundColor: Color(0xff303030),
    accentColor: Color(0xff60cff4),
    accentIconTheme: IconThemeData(color: Color(0xff86B6E0)),
    toggleableActiveColor: Color(0xffA0C3E2),
    dialogTheme: DialogTheme(elevation: 15),
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(backgroundColor: Color(0xff212121)),
  );

  // Light theme
  final _lightTheme = ThemeData(
    brightness: Brightness.light,
    canvasColor: Color(0xffFDFDFD),
    primaryColor: Colors.white,
    primaryColorDark: Colors.black,
    primaryColorLight: Colors.white,
    accentColor: Color(0xff027DC5),
    accentIconTheme: IconThemeData(color: Color.fromRGBO(2, 125, 197, 90)),
    // toggleableActiveColor: Color(0xffA0C3E2),
    dialogBackgroundColor: Color(0xffFDFDFD),
    buttonColor: Color(0xff027DC5),
    disabledColor: Color(0xffA0C3E2),
    cardColor: Colors.white,
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(backgroundColor: Colors.white),
  );

  // Get theme
  getTheme() => locator<LocalStorageService>().darkTheme ?? false
      ? _darkTheme
      : _lightTheme;

  // Set theme
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
