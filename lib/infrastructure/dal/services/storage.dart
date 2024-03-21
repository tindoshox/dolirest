import 'package:dolirest/infrastructure/dal/models/group_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/product_model.dart';
import 'package:dolirest/infrastructure/dal/models/third_party_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum BoxName {
  invoices,
  customers,
  payments,
  products,
  groups,
  settings,
}

class Storage {
  static Box<InvoiceModel> invoices = Hive.box(BoxName.invoices.name);
  static Box<CustomerModel> customers = Hive.box(BoxName.customers.name);
  static Box<List> payments = Hive.box(BoxName.payments.name);
  static Box<ProductModel> products = Hive.box(BoxName.products.name);
  static Box<GroupModel> groups = Hive.box(BoxName.groups.name);
  static Box settings = Hive.box(BoxName.settings.name);
}
