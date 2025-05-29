import 'package:dolirest/infrastructure/dal/services/dependency_injection.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_service.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/presentation/theme/app_theme.dart';
import 'package:dolirest/utils/string_manager.dart' show SettingId;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'infrastructure/navigation/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(Main());
  DependencyInjection.init();
}

class Main extends StatelessWidget {
  const Main({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final StorageService storage = Get.find();
    final initialRoute = storage.getSetting(SettingId.tokenSettingId) == null ||
            storage.getSetting(SettingId.urlSettingId) == null
        ? Routes.LOGIN
        : Routes.HOME;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _getThmeMode(),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      initialRoute: initialRoute,
      getPages: Nav.routes,
    );
  }
}

_getThmeMode() {
  String? mode =
      Get.find<StorageService>().getSetting(SettingId.themeModeId)?.strValue;
  switch (mode) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
}
