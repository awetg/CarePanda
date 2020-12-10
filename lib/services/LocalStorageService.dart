import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static LocalStorageService _instance =
      LocalStorageService._privateConstructor();
  static SharedPreferences _preferences;

  factory LocalStorageService() {
    return _instance;
  }

  LocalStorageService._privateConstructor();

  static Future<LocalStorageService> getInstance() async {
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
    return _instance;
  }

  // Local storage key string
  // App
  static const String HasQuestionnaireKey = 'hasQuestionnaire';
  static const String FirsTimeStartUp = 'firstTimeStartUp';
  static const String LastQuestionnaireRdy = 'lastQuestionnaireRdy';

  // Settings
  static const String IsLoggedIn = 'isLoggedIn';
  static const String RecievePushNotif = 'recievePushNotif';
  static const String DarkTheme = 'darkTheme';
  static const String Language = 'language';

  // USER DATA
  static const String UserData = "userData";
  static const String AnonymousUserId = "uniqueId";

  // Gets value from local storage
  // App
  bool get hasQuestionnaire => _getFromLocalStorage(HasQuestionnaireKey);
  bool get firstTimeStartUp => _getFromLocalStorage(FirsTimeStartUp);
  String get lastQuestionnaireRdy => _getFromLocalStorage(LastQuestionnaireRdy);

  // Settings
  bool get isLoggedIn => _getFromLocalStorage(IsLoggedIn);
  bool get recievePushNotif => _getFromLocalStorage(RecievePushNotif);
  bool get darkTheme => _getFromLocalStorage(DarkTheme);
  String get language => _getFromLocalStorage(Language);

  // USER DATA
  String get userData => _getFromLocalStorage(UserData);
  String get anonymousUserId => _getFromLocalStorage(AnonymousUserId);

  // Sets value to local storage
  // App
  set hasQuestionnaire(bool value) =>
      _saveToLocalStorage(HasQuestionnaireKey, value);
  set firstTimeStartUp(bool value) =>
      _saveToLocalStorage(FirsTimeStartUp, value);
  set lastQuestionnaireRdy(String value) =>
      _saveToLocalStorage(LastQuestionnaireRdy, value);

  //Settings
  set isLoggedIn(bool value) => _saveToLocalStorage(IsLoggedIn, value);
  set recievePushNotif(bool value) =>
      _saveToLocalStorage(RecievePushNotif, value);
  set darkTheme(bool value) => _saveToLocalStorage(DarkTheme, value);
  set language(String value) => _saveToLocalStorage(Language, value);

  // USER DATA
  set userData(String value) => _saveToLocalStorage(UserData, value);
  set anonymousUserId(String value) =>
      _saveToLocalStorage(AnonymousUserId, value);

  // VVV Functions to save/load data below VVV

  // Function to get data from local storage
  dynamic _getFromLocalStorage(String key) {
    var value = _preferences.get(key);
    //log('(TRACE) LocalStorageService:_getFromLocalStorage. key: $key value: $value');
    return value;
  }

  // Function to set data into local storage
  void _saveToLocalStorage<T>(String key, T content) {
    //log('(TRACE) LocalStorageService:_saveToLocalStorage. key: $key value: $content');
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
