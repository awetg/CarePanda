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

  // Gets boolean value from local storage
  bool get hasQuestionnaire => _getFromLocalStorage(HasQuestionnaireKey);

  // Sets boolean value to local storage
  set hasQuestionnaire(bool value) =>
      _saveToLocalStorage(HasQuestionnaireKey, value);

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
