import 'package:carePanda/services/LocalStorageService.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:developer';
import 'package:carePanda/ServiceLocator.dart';

class PushNotificationHandler {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialise() async {
    var _storageService = locator<LocalStorageService>();

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        log("onMessage: $message");
        _storageService.hasQuestionnaire = true;
      },
      onLaunch: (Map<String, dynamic> message) async {
        log("onLaunch: $message");
        _storageService.hasQuestionnaire = true;
      },
      onResume: (Map<String, dynamic> message) async {
        log("onResume: $message");
        _storageService.hasQuestionnaire = true;
      },
    );

    /*_fcm.getToken().then((String token) {
      assert(token != null);
      log(token);
    });*/
  }
}
