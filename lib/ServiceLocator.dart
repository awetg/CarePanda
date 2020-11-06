import 'package:carePanda/services/Api.dart';
import 'package:carePanda/services/CRUDModel.dart';
import 'package:get_it/get_it.dart';
import 'package:carePanda/services/LocalStorageService.dart';
import 'package:carePanda/PushNotifHandler.dart';

GetIt locator = GetIt.instance;

Future setupLocator() async {
  // Shared preference
  var instance = await LocalStorageService.getInstance();
  locator.registerSingleton<LocalStorageService>(instance);

  // Api - Give Api a model class
  //locator.registerLazySingleton(() => Api());

  // CRUDModel
  locator.registerLazySingleton(() => CRUDModel());

  // Push notif init
  final pushNotifHandler = PushNotificationHandler();
  pushNotifHandler.initialise();
}
