import 'package:hive_ce/hive.dart';
import 'package:dolirest/infrastructure/dal/models/address_model.dart';
import 'package:dolirest/infrastructure/dal/models/company_model.dart';
import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/models/group_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/models/product_model.dart';
import 'package:dolirest/infrastructure/dal/models/user_model.dart';

extension HiveRegistrar on HiveInterface {
  void registerAdapters() {
    registerAdapter(AddressModelAdapter());
    registerAdapter(CompanyModelAdapter());
    registerAdapter(CustomerModelAdapter());
    registerAdapter(GroupModelAdapter());
    registerAdapter(InvoiceModelAdapter());
    registerAdapter(LineAdapter());
    registerAdapter(PaymentModelAdapter());
    registerAdapter(ProductModelAdapter());
    registerAdapter(UserModelAdapter());
  }
}
