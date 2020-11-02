import 'package:get_it/get_it.dart';
import 'package:carePanda/services/LocalStorageService.dart';
import 'package:carePanda/PushNotifHandler.dart';

GetIt locator = GetIt.instance;

Future setupLocator() async {
  var instance = await LocalStorageService.getInstance();
  locator.registerSingleton<LocalStorageService>(instance);
  final pushNotifHandler = PushNotificationHandler();
  pushNotifHandler.initialise();
}
