import 'package:carePanda/services/firestore_service.dart';
import 'package:carePanda/services/survey_response_service.dart';
import 'package:get_it/get_it.dart';
import 'package:carePanda/services/LocalStorageService.dart';
import 'package:carePanda/PushNotifHandler.dart';

GetIt locator = GetIt.instance;

Future setupLocator() async {
  // Shared preference
  var instance = await LocalStorageService.getInstance();
  locator.registerSingleton<LocalStorageService>(instance);
  locator.registerSingleton<FirestoreService>(FirestoreService());
  locator.registerSingleton<SurveyResponseService>(SurveyResponseService());

  // Push notif init
  final pushNotifHandler = PushNotificationHandler();
  pushNotifHandler.initialise();
}
