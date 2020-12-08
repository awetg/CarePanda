import 'package:carePanda/services/LocalStorageService.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:carePanda/services/ServiceLocator.dart';

class PushNotificationHandler {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialise() async {
    var _storageService = locator<LocalStorageService>();

    _fcm.configure(
      // When the app is open and it receives a push notification
      onMessage: (Map<String, dynamic> message) async {},

      // When app is completely closed and launched again
      onLaunch: (Map<String, dynamic> message) async {},

      // When the app is opened from the background from the push notification
      onResume: (Map<String, dynamic> message) async {},
    );

    // If no value on storage service about receiving push notifications, subscribes to push notifications
    if (_storageService.recievePushNotif == null) {
      _storageService.recievePushNotif = true;
      _fcm.subscribeToTopic('notifications');
    }

    // Gets token
    _fcm.getToken().then((String token) {
      assert(token != null);
    });
  }
}
