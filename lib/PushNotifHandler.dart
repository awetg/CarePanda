import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:developer';

class PushNotificationHandler {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialise() async {
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );

    /*_fcm.getToken().then((String token) {
      assert(token != null);
      log(token);
    });*/
  }
}
