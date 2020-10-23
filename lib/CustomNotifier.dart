import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomNotifier extends ValueNotifier<bool> {
  CustomNotifier({bool value}) : super(value ?? false);

  void setHasQuestionnaire() {
    value = !value;
  }
}
