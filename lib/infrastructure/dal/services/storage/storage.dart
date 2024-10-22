import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/models/group_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/models/product_model.dart';

class StorageController extends GetxController {
  final Box<InvoiceModel> _invoices = Hive.box('invoices');
  final Box<CustomerModel> _customers = Hive.box('customers');
  final Box<PaymentModel> _payments = Hive.box('payments');
  final Box<ProductModel> _products = Hive.box('products');
  final Box<GroupModel> _groups = Hive.box('groups');
  final Box _settings = Hive.box('settings');

  void storePayment(String key, PaymentModel value) {
    _payments.put(key, value);
  }

  List<PaymentModel> getPaymentList() {
    return _payments.toMap().values.toList();
  }

  ValueListenable<Box<PaymentModel>> paymentsListenable() {
    return _payments.listenable();
  }

  void storeInvoice(String key, InvoiceModel value) {
    _invoices.put(key, value);
  }

  InvoiceModel? getInvoice(String key) {
    return _invoices.get(key);
  }

  List<InvoiceModel> getInvoiceList() {
    return _invoices.toMap().values.toList();
  }

  ValueListenable<Box<InvoiceModel>> invoicesListenable({List<dynamic>? keys}) {
    return _invoices.listenable(keys: keys);
  }

  void storeCustomer(String key, CustomerModel value) {
    _customers.put(key, value);
  }

  CustomerModel? getCustomer(String key) {
    return _customers.get(key);
  }

  List<CustomerModel> getCustomerList() {
    return _customers.toMap().values.toList();
  }

  ValueListenable<Box<CustomerModel>> customersListenable(
      {List<dynamic>? keys}) {
    return _customers.listenable(keys: keys);
  }

  void storeSetting(String key, String value) {
    _settings.put(key, value);
  }

  getSetting(String key) {
    return _settings.get(key);
  }

  void clearSetting(String key) {
    _settings.delete(key);
  }

  void storeGroup(String key, GroupModel value) {
    _groups.put(key, value);
  }

  GroupModel? getGroup(String key) {
    return _groups.get(key);
  }

  List<GroupModel> getGroupList() {
    return _groups.toMap().values.toList();
  }

  void storeProduct(String key, ProductModel value) {
    _products.put(key, value);
  }

  List<ProductModel> getProductList() {
    return _products.toMap().values.toList();
  }

  ProductModel? getProduct(String key) {
    return _products.get(key);
  }

  void clearAll() {
    _customers.deleteFromDisk();
    _groups.deleteFromDisk();
    _invoices.deleteFromDisk();
    _payments.deleteFromDisk();
    _products.deleteFromDisk();
    _settings.deleteFromDisk();
  }
}
