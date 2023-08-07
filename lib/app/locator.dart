import 'package:get_it/get_it.dart';
import 'package:nelayan_coba/service/fishon_new_service.dart';
import 'package:nelayan_coba/service/prefs_service.dart';
import 'package:nelayan_coba/service/seaseed_service.dart';

final locator = GetIt.instance;

setupLocator() {
  locator.registerLazySingleton(() => FishonNewService());
  locator.registerLazySingleton(() => PrefsService());
  locator.registerLazySingleton(() => SeaseedService());
}