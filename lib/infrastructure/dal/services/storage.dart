import 'package:dolirest/infrastructure/dal/models/group_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/product_model.dart';
import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Storage {
  static Box<InvoiceModel> invoices = Hive.box('invoices');
  static Box<CustomerModel> customers = Hive.box('customers');
  static Box<List> payments = Hive.box('payments');
  static Box<ProductModel> products = Hive.box('products');
  static Box<GroupModel> groups = Hive.box('groups');
  static Box settings = Hive.box('settings');
}
