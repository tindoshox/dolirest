import 'package:dolirest/infrastructure/dal/models/address_model.dart';
import 'package:dolirest/infrastructure/dal/models/company_model.dart';
import 'package:dolirest/infrastructure/dal/models/customer/customer_entity.dart';
import 'package:dolirest/infrastructure/dal/models/group_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice/invoice_entity.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/models/product_model.dart';
import 'package:dolirest/infrastructure/dal/models/settings_model.dart';
import 'package:dolirest/infrastructure/dal/models/user_model.dart';
import 'package:dolirest/objectbox.g.dart';
import 'package:get/get.dart';

class StorageService extends GetxService {
  late final Store store;

  late final Box<CustomerEntity> customerBox;
  late final Box<InvoiceEntity> invoiceBox;
  late final Box<InvoiceLineEntity> lineBox;
  late final Box<PaymentModel> paymentBox;
  late final Box<ProductModel> productBox;
  late final Box<GroupModel> groupBox;
  late final Box<CompanyModel> companyBox;
  late final Box<UserModel> userBox;
  late final Box<AddressModel> addressBox;
  late final Box<SettingsModel> settingsBox;
  // Add more boxes as needed

  StorageService._create(this.store) {
    customerBox = Box<CustomerEntity>(store);
    invoiceBox = Box<InvoiceEntity>(store);
    lineBox = Box<InvoiceLineEntity>(store);
    paymentBox = Box<PaymentModel>(store);
    productBox = Box<ProductModel>(store);
    groupBox = Box<GroupModel>(store);
    companyBox = Box<CompanyModel>(store);
    userBox = Box<UserModel>(store);
    addressBox = Box<AddressModel>(store);
    settingsBox = Box<SettingsModel>(store);
  }

  static Future<StorageService> create() async {
    final store = await openStore(); // generated method
    return StorageService._create(store);
  }

  void storeUser(UserModel user) {
    userBox.put(user);
  }

  UserModel? getUser(int id) {
    return userBox.get(id);
  }

  userListenable() {}

  void storeAddresses(AddressModel address) {
    addressBox.put(address);
  }

  List<AddressModel> getAddressList() {
    return addressBox.getAll();
  }

  void storeCompany(CompanyModel company) {
    companyBox.put(company);
  }

  CompanyModel? getCompany(int id) {
    return companyBox.get(id);
  }

  companyListenable() {}

  void storePayment(PaymentModel payment) async {
    paymentBox.put(payment);
  }

  List<PaymentModel> getPaymentList({String? invoiceId}) {
    if (invoiceId == null) {
      return paymentBox.getAll();
    } else {
      return paymentBox
          .getAll()
          .where((p) => p.invoiceId == invoiceId)
          .toList();
    }
  }

  Stream<Query<PaymentModel>> paymentsStream() {
    return paymentBox
        .query()
        .order(PaymentModel_.date, flags: Order.descending)
        .watch(triggerImmediately: true);
  }

  void storeInvoice(InvoiceEntity invoice) {
    invoiceBox.put(invoice);
  }

  void storeInvoices(List<InvoiceEntity> invoices) {
    if (invoices.isNotEmpty) {
      invoiceBox.putMany(invoices);
    }
  }

  InvoiceEntity? getInvoice(String documentId) {
    return invoiceBox
        .getAll()
        .firstWhereOrNull((i) => i.documentId == documentId);
  }

  List<InvoiceEntity> getInvoiceList({String? customerId}) {
    if (customerId == null) {
      return invoiceBox.getAll();
    } else {
      return invoiceBox.getAll().where((i) => i.socid == customerId).toList();
    }
  }

  Stream<List<InvoiceEntity>> getInvoices() {
    final builder = invoiceBox.query()
      ..order(InvoiceEntity_.date, flags: Order.descending);
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  invoicesListenable() {}

  void deleteInvoice(int id) {
    invoiceBox.remove(id);
  }

  void deleteAllInvoices(List<int> ids) {
    invoiceBox.removeMany(ids);
  }

  void deleteAllPayments(List<int> ids) {
    paymentBox.removeMany(ids);
  }

  void storeCustomer(CustomerEntity customer) {
    customerBox.put(customer);
  }

  void storeCustomers(List<CustomerEntity> customers) {
    if (customers.isNotEmpty) {
      customerBox.putMany(customers);
    }
  }

  CustomerEntity? getCustomer(String customerId) {
    return customerBox.getAll().firstWhere((c) => c.customerId == customerId);
  }

  List<CustomerEntity> getCustomerList() {
    return customerBox.getAll();
  }

  void deleteCustomer(int id) {
    customerBox.remove(id);
  }

  void deleteAllCustomer(ids) {
    customerBox.removeMany(ids);
  }

  customersListenable() {}

  void storeSetting(SettingsModel setting) {
    settingsBox.put(setting);
  }

  SettingsModel? getSetting(int id) {
    return settingsBox.get(id);
  }

  watchSetting(id) {
    return settingsBox.get(id);
  }

  void clearSetting(id) {
    settingsBox.remove(id);
  }

  void storeGroup(id, GroupModel group) {
    groupBox.put(group);
  }

  GroupModel? getGroup(id) {
    return groupBox.get(id);
  }

  List<GroupModel> getGroupList() {
    return groupBox.getAll();
  }

  void storeProduct(ProductModel product) {
    productBox.put(product);
  }

  List<ProductModel> getProductList() {
    return productBox.getAll();
  }

  ProductModel? getProduct(id) {
    return productBox.get(id);
  }

  void storeEnabledModules(modules) {
    settingsBox.put(modules);
  }

  SettingsModel? getEnabledModules(id) {
    return settingsBox.get(id);
  }

  settingsListenable() {}

  void clearAll() {
    addressBox.removeAll();
    companyBox.removeAll();
    customerBox.removeAll();
    groupBox.removeAll();
    invoiceBox.removeAll();
    paymentBox.removeAll();
    productBox.removeAll();
    settingsBox.removeAll();
    userBox.removeAll();
  }
}
