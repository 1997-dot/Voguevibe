import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/navigation/app_navigator.dart';
import '../core/navigation/tab_navigator.dart';
import '../core/network/api_client.dart';
import '../core/storage/local_storage.dart';
import '../core/storage/secure_storage.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Core - Storage
  getIt.registerSingleton<LocalStorage>(
    LocalStorage(prefs: getIt<SharedPreferences>()),
  );
  getIt.registerSingleton<SecureStorage>(SecureStorage());

  // Core - Network
  getIt.registerSingleton<ApiClient>(
    ApiClient(secureStorage: getIt<SecureStorage>()),
  );

  // Core - Navigation
  getIt.registerSingleton<AppNavigator>(AppNavigator());
  getIt.registerSingleton<TabNavigator>(TabNavigator());

  // TODO: Phase 3 - Register data sources
  // TODO: Phase 3 - Register repositories
  // TODO: Phase 4 - Register use cases
}
