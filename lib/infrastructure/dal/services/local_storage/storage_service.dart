import 'package:dolirest/infrastructure/dal/models/address_model.dart';
import 'package:dolirest/infrastructure/dal/models/company_model.dart';
import 'package:dolirest/infrastructure/dal/models/customer/customer_entity.dart';
import 'package:dolirest/infrastructure/dal/models/group/group_entity.dart';
import 'package:dolirest/infrastructure/dal/models/invoice/invoice_entity.dart';
import 'package:dolirest/infrastructure/dal/models/payment/payment_entity.dart';
import 'package:dolirest/infrastructure/dal/models/product/product_entity.dart';
import 'package:dolirest/infrastructure/dal/models/settings_model.dart';
import 'package:dolirest/infrastructure/dal/models/user_model.dart';
import 'package:dolirest/objectbox.g.dart';
import 'package:get/get.dart';

class StorageService extends GetxService {
  late final Store store;

  late final Box<CustomerEntity> customerBox;
  late final Box<InvoiceEntity> invoiceBox;
  late final Box<InvoiceLineEntity> lineBox;
  late final Box<PaymentEntity> paymentBox;
  late final Box<ProductEntity> productBox;
  late final Box<GroupEntity> groupBox;
  late final Box<CompanyModel> companyBox;
  late final Box<UserModel> userBox;
  late final Box<AddressModel> addressBox;
  late final Box<SettingsModel> settingsBox;

  StorageService._create(this.store) {
    customerBox = Box<CustomerEntity>(store);
    invoiceBox = Box<InvoiceEntity>(store);
    lineBox = Box<InvoiceLineEntity>(store);
    paymentBox = Box<PaymentEntity>(store);
    productBox = Box<ProductEntity>(store);
    groupBox = Box<GroupEntity>(store);
    companyBox = Box<CompanyModel>(store);
    userBox = Box<UserModel>(store);
    addressBox = Box<AddressModel>(store);
    settingsBox = Box<SettingsModel>(store);
  }

  static Future<StorageService> create() async {
    final store = await openStore();
    return StorageService._create(store);
  }

  PaymentEntity _upsertPayment(PaymentEntity payment) {
    final existing = paymentBox
        .query(PaymentEntity_.invoiceId
            .equals(payment.invoiceId)
            .and(PaymentEntity_.ref.equals(payment.ref)))
        .build()
        .findFirst();

    if (existing != null) {
      payment.id = existing.id;
    }

    // paymentBox.put(payment);
    return payment;
  }

  void storePayment(PaymentEntity payment) async {
    paymentBox.put(_upsertPayment(payment));
  }

  Future<List<PaymentEntity>> storePayments(
      List<PaymentEntity> payments) async {
    var cleaned = <PaymentEntity>[];

    for (var payment in payments) {
      cleaned.add(_upsertPayment(payment));
    }
    paymentBox.putManyAsync(cleaned);
    return cleaned;
  }

  void cleanupPayments(List<PaymentEntity> apiPayments, String invoiceId) {
    final existingIds = paymentBox
        .query(PaymentEntity_.invoiceId.equals(invoiceId))
        .build()
        .find()
        .map((p) => p.ref);
    final apiIds = apiPayments.map((i) => i.ref).toList();
    var idsToDelete = <int>[];

    for (var e in existingIds) {
      if (!apiIds.contains(e)) {
        idsToDelete.add(paymentBox
            .query(PaymentEntity_.ref
                .equals(e)
                .and(PaymentEntity_.invoiceId.equals(invoiceId)))
            .build()
            .findFirst()!
            .id);
      }
    }
    paymentBox.removeManyAsync(idsToDelete);
  }

  InvoiceEntity _upsertInvoice(InvoiceEntity invoice) {
    final existing = invoiceBox
        .query(InvoiceEntity_.documentId.equals(invoice.documentId))
        .build()
        .findFirst();

    if (existing != null) {
      invoice.id = existing.id;

      final linesToRemove = lineBox
          .query(InvoiceLineEntity_.fkFacture.equals(invoice.documentId))
          .build()
          .find();
      lineBox.removeMany(linesToRemove.map((e) => e.id).toList());
    }

    return invoice;
  }

  void storeInvoice(InvoiceEntity invoice) {
    invoiceBox.put(_upsertInvoice(invoice));
  }

  Future<List<InvoiceEntity>> storeInvoices(
      List<InvoiceEntity> invoices) async {
    if (invoices.isEmpty) return [];

    var cleaned = <InvoiceEntity>[];
    for (var invoice in invoices) {
      cleaned.add(_upsertInvoice(invoice));
    }

    invoiceBox.putManyAsync(cleaned);
    return cleaned;
  }

  void cleanupInvoices(List<InvoiceEntity> apiInvoices) {
    final existingIds = invoiceBox.getAll().map((i) => i.documentId).toList();
    final apiIds = apiInvoices.map((i) => i.documentId).toList();
    var idsToDelete = <int>[];
    for (var e in existingIds) {
      if (!apiIds.contains(e)) {
        idsToDelete.add(invoiceBox
            .query(InvoiceEntity_.documentId.equals(e))
            .build()
            .findFirst()!
            .id);
      }
    }
    invoiceBox.removeManyAsync(idsToDelete);
  }

  bool deleteInvoice(int id) {
    return invoiceBox.remove(id);
  }

  int deleteAllInvoices(List<int> ids) {
    return invoiceBox.removeMany(ids);
  }

  int deleteAllPayments(List<int> ids) {
    return paymentBox.removeMany(ids);
  }

  CustomerEntity _upsertCustomer(CustomerEntity customer) {
    final existing = customerBox
        .query(CustomerEntity_.customerId.equals(customer.customerId))
        .build()
        .findFirst();

    if (existing != null) {
      customer.id = existing.id;
    }

    // customerBox.put(customer);
    return customer;
  }

  void storeCustomer(CustomerEntity customer) {
    customerBox.put(_upsertCustomer(customer));
  }

  Future<List<CustomerEntity>> storeCustomers(
      List<CustomerEntity> customers) async {
    if (customers.isEmpty) return [];

    var cleaned = <CustomerEntity>[];

    for (var customer in customers) {
      cleaned.add(_upsertCustomer(customer));
    }

    customerBox.putManyAsync(cleaned);
    return cleaned;
  }

  void cleanupCustomers(List<CustomerEntity> apiCustomers) {
    final existingIds = customerBox.getAll().map((c) => c.customerId).toList();
    final apiIds = apiCustomers.map((c) => c.customerId).toList();
    var idsToDelete = <int>[];
    for (var e in existingIds) {
      if (!apiIds.contains(e)) {
        idsToDelete.add(customerBox
            .query(CustomerEntity_.customerId.equals(e))
            .build()
            .findFirst()!
            .id);
      }
    }
    customerBox.removeManyAsync(idsToDelete);
  }

  CustomerEntity? getCustomer(String customerId) {
    return customerBox
        .query(CustomerEntity_.customerId.equals(customerId))
        .build()
        .findFirst();
  }

  List<CustomerEntity> getCustomerList() {
    return customerBox.getAll();
  }

  bool deleteCustomer(int id) {
    return customerBox.remove(id);
  }

  int deleteManyCustomer(List<int> ids) {
    return customerBox.removeMany(ids);
  }

  int storeSetting(SettingsModel setting) {
    return settingsBox.put(setting);
  }

  SettingsModel? getSetting(int id) {
    return settingsBox.get(id);
  }

  bool clearSetting(int id) {
    return settingsBox.remove(id);
  }

  GroupEntity _upsertGroup(GroupEntity group) {
    final existing = groupBox
        .query(GroupEntity_.groupId.equals(group.groupId!))
        .build()
        .findFirst();

    if (existing != null) {
      group.id = existing.id;
    }

    groupBox.put(group);
    return group;
  }

  dynamic storeGroup(GroupEntity group) {
    return _upsertGroup(group);
  }

  void storeGroups(List<GroupEntity> groups) {
    if (groups.isNotEmpty) {
      for (var group in groups) {
        _upsertGroup(group);
      }
    }
  }

  GroupEntity? getGroup(int id) {
    return groupBox.get(id);
  }

  List<GroupEntity> getGroupList() {
    return groupBox.getAll();
  }

  void _upsertProduct(ProductEntity product) {
    final existing = productBox
        .query(ProductEntity_.productId.equals(product.productId!))
        .build()
        .findFirst();

    if (existing != null) {
      product.id = existing.id;
    }

    productBox.put(product);
  }

  void storeProduct(ProductEntity product) {
    _upsertProduct(product);
  }

  void storeProducts(List<ProductEntity> products) {
    if (products.isNotEmpty) {
      for (var product in products) {
        _upsertProduct(product);
      }
    }
  }

  void clearAll() {
    addressBox.removeAll();

    companyBox.removeAll();
    customerBox.removeAll();
    groupBox.removeAll();
    lineBox.removeAll();
    invoiceBox.removeAll();
    paymentBox.removeAll();
    productBox.removeAll();
    settingsBox.removeAll();
    userBox.removeAll();
  }
}
