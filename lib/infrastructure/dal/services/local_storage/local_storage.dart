import 'package:dolirest/infrastructure/dal/models/address_model.dart';
import 'package:dolirest/infrastructure/dal/models/company_model.dart';
import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/models/group_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/models/product_model.dart';
import 'package:dolirest/infrastructure/dal/models/user_model.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_key.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class StorageService extends GetxController {
  final Box<InvoiceModel> _invoices = Hive.box('invoices');
  final Box<CustomerModel> _customers = Hive.box('customers');
  final Box<PaymentModel> _payments = Hive.box('payments');
  final Box<ProductModel> _products = Hive.box('products');
  final Box<GroupModel> _groups = Hive.box('groups');
  final Box<CompanyModel> _company = Hive.box('company');
  final Box<UserModel> _user = Hive.box('user');
  final Box<AddressModel> _addresses = Hive.box('addresses');
  final Box _settings = Hive.box('settings');

  void storeUser(UserModel user) async {
    await _user.put(StorageKey.user, user);
  }

  UserModel? getUser() {
    return _user.isOpen ? _user.get(StorageKey.user) : null;
  }

  void storeAddresses(String key, AddressModel value) async {
    await _addresses.put(key, value);
  }

  List<AddressModel> getAddressList() {
    return _addresses.toMap().values.toList();
  }

  void storeCompany(CompanyModel company) async {
    await _company.put(StorageKey.company, company);
  }

  CompanyModel? getCompany() {
    return _company.isOpen ? _company.get(StorageKey.company) : null;
  }

  void storePayment(String key, PaymentModel value) async {
    if (_payments.isOpen) await _payments.put(key, value);
  }

  List<PaymentModel> getPaymentList({String? invoiceId}) {
    if (invoiceId == null) {
      return _payments.toMap().values.toList();
    } else {
      return _payments.values.where((i) => i.invoiceId == invoiceId).toList();
    }
  }

  ValueListenable<Box<PaymentModel>> paymentsListenable() {
    return _payments.listenable();
  }

  void storeInvoice(String key, InvoiceModel value) async {
    if (_invoices.isOpen) await _invoices.put(key, value);
  }

  InvoiceModel? getInvoice(String key) {
    return _invoices.get(key);
  }

  List<InvoiceModel> getInvoiceList({String? customerId}) {
    if (customerId == null) {
      return _invoices.toMap().values.toList();
    } else {
      return _invoices.values.where((i) => i.socid == customerId).toList();
    }
  }

  ValueListenable<Box<InvoiceModel>> invoicesListenable() {
    return _invoices.listenable();
  }

  void storeCustomer(String key, CustomerModel value) async {
    if (_customers.isOpen) await _customers.put(key, value);
  }

  CustomerModel? getCustomer(String key) {
    return _customers.isOpen ? _customers.get(key) : null;
  }

  List<CustomerModel> getCustomerList() {
    return _customers.isOpen
        ? _customers.toMap().values.toList()
        : <CustomerModel>[];
  }

  void deleteCustomer(String key) {
    if (_customers.isOpen) _customers.delete(key);
  }

  ValueListenable<Box<CustomerModel>> customersListenable() {
    return _customers.listenable();
  }

  void storeSetting(String key, dynamic value) async {
    if (_settings.isOpen) await _settings.put(key, value);
  }

  String? getSetting(String key) {
    return _settings.isOpen ? _settings.get(key) : null;
  }

  watchSetting(String key) {
    return _settings.watch(key: key);
  }

  void clearSetting(String key) {
    if (_settings.isOpen) _settings.delete(key);
  }

  void storeGroup(String key, GroupModel value) async {
    if (_groups.isOpen) await _groups.put(key, value);
  }

  GroupModel? getGroup(String key) {
    return _groups.isOpen ? _groups.get(key) : null;
  }

  List<GroupModel> getGroupList() {
    return _groups.toMap().values.toList();
  }

  void storeProduct(String key, ProductModel value) async {
    if (_products.isOpen) await _products.put(key, value);
  }

  List<ProductModel> getProductList() {
    return _products.toMap().values.toList();
  }

  ProductModel? getProduct(String key) {
    return _products.isOpen ? _products.get(key) : null;
  }

  void storeEnabledModules(List<String> modules) async {
    if (_settings.isOpen) {
      await _settings.put(StorageKey.enabledModules, modules);
    }
  }

  List<String> getEnabledModules() {
    return _settings.isOpen
        ? _settings.get(StorageKey.enabledModules) != null
            ? List<String>.from(
                _settings.get(StorageKey.enabledModules).map((x) => x))
            : <String>[]
        : <String>[];
  }

  void clearAll() {
    _customers.clear();
    _groups.clear();
    _invoices.clear();
    _payments.clear();
    _products.clear();
    _settings.clear();
    _company.clear();
    _addresses.clear();
    _user.clear();
    _settings.clear();
  }
}
