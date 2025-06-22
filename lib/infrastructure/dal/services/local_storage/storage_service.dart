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

  _upsertPayment(PaymentEntity payment) {
    final existing = paymentBox
        .query(PaymentEntity_.invoiceId
            .equals(payment.invoiceId)
            .and(PaymentEntity_.ref.equals(payment.ref)))
        .build()
        .findFirst();

    if (existing != null) {
      payment.id = existing.id;
    }

    paymentBox.put(payment);
    return payment;
  }

  void storePayment(PaymentEntity payment) async {
    _upsertPayment(payment);
  }

  InvoiceEntity _upsertInvoice(InvoiceEntity invoice) {
    final existing = invoiceBox
        .query(InvoiceEntity_.documentId.equals(invoice.documentId))
        .build()
        .findFirst();

    if (existing != null) {
      // Fix: Use = for assignment instead of == for comparison
      invoice.id = existing.id;

      final linesToRemove = lineBox
          .query(InvoiceLineEntity_.fkFacture.equals(invoice.documentId))
          .build()
          .find();
      lineBox.removeMany(linesToRemove.map((e) => e.id).toList());
    }

    // Store the invoice first to ensure it has an ID
    invoiceBox.put(invoice);

    return invoice;
  }

  storeInvoice(InvoiceEntity invoice) {
    return _upsertInvoice(invoice);
  }

  storeInvoices(List<InvoiceEntity> invoices) {
    if (invoices.isNotEmpty) {
      for (var invoice in invoices) {
        _upsertInvoice(invoice);
      }
    }
    return invoices;
  }

  deleteInvoice(int id) {
    return invoiceBox.remove(id);
  }

  deleteAllInvoices(List<int> ids) {
    return invoiceBox.removeMany(ids);
  }

  deleteAllPayments(List<int> ids) {
    return paymentBox.removeMany(ids);
  }

  _upsertCustomer(CustomerEntity customer) {
    final existing = customerBox
        .query(CustomerEntity_.customerId.equals(customer.customerId))
        .build()
        .findFirst();

    if (existing != null) {
      customer.id = existing.id;
    }

    customerBox.put(customer);
    return customer;
  }

  void storeCustomer(CustomerEntity customer) {
    _upsertCustomer(customer);
  }

  storeCustomers(List<CustomerEntity> customers) {
    if (customers.isNotEmpty) {
      for (var customer in customers) {
        _upsertCustomer(
          customer,
        );
      }
    }
    return customers;
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

  deleteCustomer(int id) {
    return customerBox.remove(id);
  }

  deleteManyCustomer(ids) {
    return customerBox.removeMany(ids);
  }

  storeSetting(SettingsModel setting) {
    return settingsBox.put(setting);
  }

  SettingsModel? getSetting(int id) {
    return settingsBox.get(id);
  }

  watchSetting(id) {
    return settingsBox.get(id);
  }

  clearSetting(id) {
    return settingsBox.remove(id);
  }

  _upsertGroup(GroupEntity group) {
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

  storeGroup(GroupEntity group) {
    return _upsertGroup(group);
  }

  void storeGroups(List<GroupEntity> groups) {
    if (groups.isNotEmpty) {
      for (var group in groups) {
        _upsertGroup(group);
      }
    }
  }

  GroupEntity? getGroup(id) {
    return groupBox.get(id);
  }

  List<GroupEntity> getGroupList() {
    return groupBox.getAll();
  }

  _upsertProduct(ProductEntity product) {
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
