import 'package:carePanda/services/LocalStorageService.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:developer';
import 'package:carePanda/ServiceLocator.dart';

class PushNotificationHandler {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialise() async {
    var _storageService = locator<LocalStorageService>();

    _fcm.configure(
      // When the app is open and it receives a push notification
      onMessage: (Map<String, dynamic> message) async {
        log("onMessage: $message");
        _storageService.hasQuestionnaire = true;
      },

      // When app is completely closed and launched again
      onLaunch: (Map<String, dynamic> message) async {
        log("onLaunch: $message");
        _storageService.hasQuestionnaire = true;
      },

      // When the app is opened from the background from the push notification
      onResume: (Map<String, dynamic> message) async {
        log("onResume: $message");
        _storageService.hasQuestionnaire = true;
      },
    );

    _fcm.getToken().then((String token) {
      assert(token != null);
      log(token);
    });
  }
}
