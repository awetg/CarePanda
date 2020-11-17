import 'package:shared_preferences/shared_preferences.dart';

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
  // App
  static const String HasQuestionnaireKey = 'hasQuestionnaire';
  static const String FirsTimeStartUp = 'firstTimeStartUp';
  static const String ShowBoarding = 'showBoarding';
  static const String LastQuestionnaireRdy = 'lastQuestionnaireRdy';

  // Settings
  static const String IsLoggedIn = 'isLoggedIn';
  static const String RecievePushNotif = 'recievePushNotif';
  static const String DarkTheme = 'darkTheme';
  static const String Language = 'language';

  // USER DATA
  static const String Name = 'name';
  static const String LastName = 'lastName';
  static const String BirthYear = 'birthYear';
  static const String Gender = 'gender';
  static const String Building = 'building';
  static const String Floor = 'floor';
  static const String YearsInNokia = 'yearsInNokia';
  static const String AnonymousUserId = "uniqueId";

  // Gets value from local storage
  // App
  bool get hasQuestionnaire => _getFromLocalStorage(HasQuestionnaireKey);
  bool get firstTimeStartUp => _getFromLocalStorage(FirsTimeStartUp);
  bool get showBoarding => _getFromLocalStorage(ShowBoarding);
  String get lastQuestionnaireRdy => _getFromLocalStorage(LastQuestionnaireRdy);

  // Settings
  bool get isLoggedIn => _getFromLocalStorage(IsLoggedIn);
  bool get recievePushNotif => _getFromLocalStorage(RecievePushNotif);
  bool get darkTheme => _getFromLocalStorage(DarkTheme);
  String get language => _getFromLocalStorage(Language);

  // USER DATA
  String get name => _getFromLocalStorage(Name);
  String get lastName => _getFromLocalStorage(LastName);
  int get birthYear => _getFromLocalStorage(BirthYear);
  int get gender => _getFromLocalStorage(Gender);
  int get building => _getFromLocalStorage(Building);
  int get floor => _getFromLocalStorage(Floor);
  int get yearsInNokia => _getFromLocalStorage(YearsInNokia);
  String get anonymousUserId => _getFromLocalStorage(AnonymousUserId);

  // Sets value to local storage
  // App
  set hasQuestionnaire(bool value) =>
      _saveToLocalStorage(HasQuestionnaireKey, value);
  set firstTimeStartUp(bool value) =>
      _saveToLocalStorage(FirsTimeStartUp, value);
  set showBoarding(bool value) => _saveToLocalStorage(ShowBoarding, value);
  set lastQuestionnaireRdy(String value) =>
      _saveToLocalStorage(LastQuestionnaireRdy, value);

  //Settings
  set isLoggedIn(bool value) => _saveToLocalStorage(IsLoggedIn, value);
  set recievePushNotif(bool value) =>
      _saveToLocalStorage(RecievePushNotif, value);
  set darkTheme(bool value) => _saveToLocalStorage(DarkTheme, value);
  set language(String value) => _saveToLocalStorage(Language, value);

  // USER DATA
  set name(String value) => _saveToLocalStorage(Name, value);
  set lastName(String value) => _saveToLocalStorage(LastName, value);
  set birthYear(int value) => _saveToLocalStorage(BirthYear, value);
  set gender(int value) => _saveToLocalStorage(Gender, value);
  set building(int value) => _saveToLocalStorage(Building, value);
  set floor(int value) => _saveToLocalStorage(Floor, value);
  set yearsInNokia(int value) => _saveToLocalStorage(YearsInNokia, value);
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

class HasQuestionnaire {
  final hasQuestionnaire;
  HasQuestionnaire({this.hasQuestionnaire});
}
