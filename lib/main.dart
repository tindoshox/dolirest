import 'package:dolirest/infrastructure/dal/services/get_storage.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'infrastructure/navigation/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    var token = box.read("apikey");
    var intialScreen = token == null ? Routes.SETTINGS : Routes.HOME;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
          colorScheme: const ColorScheme.light(),
          useMaterial3: true,
          appBarTheme: const AppBarTheme()),
      darkTheme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        useMaterial3: true,
      ),
      initialRoute: intialScreen,
      getPages: Nav.routes,
    );
  }
}
