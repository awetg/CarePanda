import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class LocalStorageService {
  static LocalStorageService _instance;
  static SharedPreferences _preferences;

  static Future<LocalStorageService> getInstance() async {
    if (_instance == null) {
      _instance = LocalStorageService();
    }
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
    return _instance;
  }

  // Local storage key string
  static const String HasQuestionnaireKey = 'hasQuestionnaire';
  static const String FirsTimeStartUp = 'firstTimeStartUp';
  static const String ShowBoarding = 'showBoarding';
  // USER DATA
  static const String Name = 'name';
  static const String LastName = 'lastName';
  static const String Birthday = 'birthday';
  static const String Gender = 'gender';
  static const String Building = 'building';

  // Gets value from local storage
  bool get hasQuestionnaire => _getFromLocalStorage(HasQuestionnaireKey);
  bool get firstTimeStartUp => _getFromLocalStorage(FirsTimeStartUp);
  bool get showBoarding => _getFromLocalStorage(ShowBoarding);
  // USER DATA
  String get name => _getFromLocalStorage(Name);
  String get lastName => _getFromLocalStorage(LastName);
  String get birthday => _getFromLocalStorage(Birthday);
  String get gender => _getFromLocalStorage(Gender);
  String get building => _getFromLocalStorage(Building);

  // Sets value to local storage
  set hasQuestionnaire(bool value) =>
      _saveToLocalStorage(HasQuestionnaireKey, value);
  set firstTimeStartUp(bool value) =>
      _saveToLocalStorage(FirsTimeStartUp, value);
  set showBoarding(bool value) => _saveToLocalStorage(ShowBoarding, value);
  // USER DATA
  set name(String value) => _saveToLocalStorage(Name, value);
  set lastName(String value) => _saveToLocalStorage(LastName, value);
  set birthday(String value) => _saveToLocalStorage(Birthday, value);
  set gender(String value) => _saveToLocalStorage(Gender, value);
  set building(String value) => _saveToLocalStorage(Building, value);

  // VVV Functions to save/load data below VVV
  // Function to get data from local storage
  dynamic _getFromLocalStorage(String key) {
    var value = _preferences.get(key);
    log('(TRACE) LocalStorageService:_getFromLocalStorage. key: $key value: $value');
    return value;
  }

// Function to set data into local storage
  void _saveToLocalStorage<T>(String key, T content) {
    log('(TRACE) LocalStorageService:_saveToLocalStorage. key: $key value: $content');
    if (content is String) {
      _preferences.setString(key, content);
    }
    if (content is bool) {
      _preferences.setBool(key, content);
    }
    if (content is int) {
      _preferences.setInt(key, content);
    }
    if (content is double) {
      _preferences.setDouble(key, content);
    }
    if (content is List<String>) {
      _preferences.setStringList(key, content);
    }
  }
}

class HasQuestionnaire {
  final hasQuestionnaire;
  HasQuestionnaire({this.hasQuestionnaire});
}
