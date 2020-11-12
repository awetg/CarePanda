import 'package:carePanda/services/LocalStorageService.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:developer';
import 'package:carePanda/services/ServiceLocator.dart';

class PushNotificationHandler {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialise() async {
    var _storageService = locator<LocalStorageService>();

    _fcm.configure(
      // When the app is open and it receives a push notification
      onMessage: (Map<String, dynamic> message) async {
        log("onMessage: $message");
      },

      // When app is completely closed and launched again
      onLaunch: (Map<String, dynamic> message) async {
        log("onLaunch: $message");
      },

      // When the app is opened from the background from the push notification
      onResume: (Map<String, dynamic> message) async {
        log("onResume: $message");
      },
    );

    if (_storageService.recievePushNotif == null) {
      _storageService.recievePushNotif = true;
      _fcm.subscribeToTopic('notifications');
    }

    _fcm.getToken().then((String token) {
      assert(token != null);
      log(token);
    });
  }
}
