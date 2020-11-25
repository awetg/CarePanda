import 'package:flutter/material.dart';
import 'LocalStorageService.dart';
import 'ServiceLocator.dart';

class QuestionnairProvider with ChangeNotifier {
  void setHasQuestionnaire(bool value) {
    locator<LocalStorageService>().hasQuestionnaire = value;
    notifyListeners();
  }

  bool getHasQuestionnaire() =>
      locator<LocalStorageService>().hasQuestionnaire ?? false;
}
