import 'dart:io';

import 'package:dolirest/infrastructure/dal/models/group_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/models/product_model.dart';
import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/services/dependancy_injection.dart';
import 'package:dolirest/infrastructure/dal/services/storage.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:path_provider/path_provider.dart';
import 'infrastructure/navigation/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final Directory dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);
  Hive.registerAdapter<InvoiceModel>(InvoiceModelAdapter());
  Hive.registerAdapter<Line>(LineAdapter());
  Hive.registerAdapter(CustomerModelAdapter());
  Hive.registerAdapter<PaymentModel>(PaymentModelAdapter());
  Hive.registerAdapter<GroupModel>(GroupModelAdapter());
  Hive.registerAdapter<ProductModel>(ProductModelAdapter());

  await Hive.openBox<InvoiceModel>('invoices');
  await Hive.openBox<CustomerModel>('customers');
  await Hive.openBox<List>('payments');
  await Hive.openBox<ProductModel>('products');
  await Hive.openBox<GroupModel>('groups');
  await Hive.openBox('settings');

  runApp(const Main());
  DependencyInjection.init();
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    final initialRoute =
        Storage.settings.get('apikey') == null ? Routes.SETTINGS : Routes.HOME;
    return GetMaterialApp(
      debugShowCheckedModeBanner: kDebugMode,
      themeMode: ThemeMode.system,
      theme: ThemeData(
          colorScheme: const ColorScheme.light(),
          useMaterial3: true,
          appBarTheme: const AppBarTheme()),
      darkTheme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      getPages: Nav.routes,
    );
  }
}
