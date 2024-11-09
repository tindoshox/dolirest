import 'dart:io';

import 'package:dolirest/hive_registrar.g.dart';
import 'package:dolirest/infrastructure/dal/models/address_model.dart';
import 'package:dolirest/infrastructure/dal/models/company_model.dart';
import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/models/group_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/models/product_model.dart';
import 'package:dolirest/infrastructure/dal/models/user_model.dart';
import 'package:dolirest/infrastructure/dal/services/dependency_injection.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_key.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'infrastructure/navigation/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final Directory dir = await getApplicationDocumentsDirectory();
  Hive
    ..init(dir.path)
    ..registerAdapters();

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
    final StorageService storage = Get.find();
    final initialRoute = storage.getSetting(StorageKey.apiKey) == null ||
            storage.getSetting(StorageKey.url) == null
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
  String? mode = Get.find<StorageService>().getSetting(StorageKey.theme);
  switch (mode) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
}
