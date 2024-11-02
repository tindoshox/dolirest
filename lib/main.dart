import 'dart:io';

import 'package:dolirest/infrastructure/dal/models/address_model.dart';
import 'package:dolirest/infrastructure/dal/models/company_model.dart';
import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/models/group_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/models/product_model.dart';
import 'package:dolirest/infrastructure/dal/models/user_model.dart';
import 'package:dolirest/infrastructure/dal/services/dependancy_injection.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_key.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
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
  Hive.registerAdapter<CompanyModel>(CompanyModelAdapter());
  Hive.registerAdapter<AddressModel>(AddressModelAdapter());
  Hive.registerAdapter<UserModel>(UserModelAdapter());

  await Hive.openBox<InvoiceModel>('invoices');
  await Hive.openBox<CustomerModel>('customers');
  await Hive.openBox<PaymentModel>('payments');
  await Hive.openBox<ProductModel>('products');
  await Hive.openBox<GroupModel>('groups');
  await Hive.openBox<CompanyModel>('company');
  await Hive.openBox<AddressModel>('addresses');
  await Hive.openBox<UserModel>('user');
  await Hive.openBox('settings');

  runApp(Main());
  DependencyInjection.init();
}

class Main extends StatelessWidget {
  const Main({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final StorageController storage = Get.find();
    final initialRoute = storage.getSetting(StorageKey.apiKey) == null
        ? Routes.LOGIN
        : Routes.HOME;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _getThmeMode(),
      theme: ThemeData.light(
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      initialRoute: initialRoute,
      getPages: Nav.routes,
    );
  }
}

_getThmeMode() {
  String? mode = Get.find<StorageController>().getSetting(StorageKey.theme);
  switch (mode) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
}
