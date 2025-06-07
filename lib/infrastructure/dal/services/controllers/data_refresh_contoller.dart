// ignore_for_file: unused_import

import 'dart:async';

import 'package:dolirest/infrastructure/dal/models/address_model.dart';
import 'package:dolirest/infrastructure/dal/models/customer/customer_entity.dart';
import 'package:dolirest/infrastructure/dal/models/customer/customer_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice/invoice_entity.dart';
import 'package:dolirest/infrastructure/dal/models/invoice/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment/payment_entity.dart';
import 'package:dolirest/infrastructure/dal/models/payment/payment_model.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/network_controller.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/customer_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/invoice_repository.dart';
import 'package:dolirest/objectbox.g.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class DataRefreshService extends GetxService {
  final StorageService _storage = Get.find();
  final CustomerRepository _customerRepository = Get.find();
  final InvoiceRepository _invoiceRepository = Get.find();
  final NetworkController _networkController = Get.find();
  var invoices = <InvoiceEntity>[].obs;
  var customers = <CustomerEntity>[].obs;
  var noInvoiceCustomers = <CustomerEntity>[].obs;
  var refreshing = false.obs;
  bool _isRefreshing = false;

  @override
  void onInit() {
    super.onInit();
    _dataRefreshSchedule();
    invoices.bindStream(_storage.invoiceBox
        .query()
        .watch(triggerImmediately: true)
        .map((query) {
      return query.find();
    }));
    customers.bindStream(_storage.customerBox
        .query()
        .order(CustomerEntity_.name, flags: Order.nullsLast)
        .watch(triggerImmediately: true)
        .map((query) => query.find()));

    noInvoiceCustomers.bindStream(_storage.customerBox
        .query()
        .watch(triggerImmediately: true)
        .map((query) {
      var allCustomers = query.find();
      var nICustomers = <CustomerEntity>[];
      for (var customer in allCustomers) {
        final customerInvoices =
            invoices.where((invoice) => invoice.socid == customer.customerId);
        if (customerInvoices.isEmpty) {
          nICustomers.add(customer);
        }
      }
      return nICustomers;
    }));
    _importCustomersToAddressBox();
  }

  void _dataRefreshSchedule() {
    // final customers = _storage.getCustomerList();
    customers.sort((a, b) => a.dateModification.compareTo(b.dateModification));

    String? customerDateModified = customers.isEmpty
        ? null
        : Utils.intToYMD(customers.last.dateModification);

    // var invoices = _storage.getInvoiceList();
    invoices.removeWhere((i) => i.dateModification == 0);
    invoices.sort((a, b) => a.dateModification.compareTo(b.dateModification));
    String? invoiceDateModified = invoices.isEmpty
        ? null
        : Utils.intToYMD(invoices.last.dateModification);

    Timer.periodic(const Duration(minutes: 10), (Timer timer) async {
      await forceRefresh(
          customerDateModified: customerDateModified,
          invoiceDateModified: invoiceDateModified);
    });
  }

  Future<void> forceRefresh(
      {String? customerDateModified, String? invoiceDateModified}) async {
    if (_isRefreshing || !_networkController.connected.value) {
      return;
    }
    _isRefreshing = true;
    refreshing.value = true;

    if (_networkController.connected.value) {
      await syncCustomers(dateModified: customerDateModified).then(
          (customers) async =>
              await syncInvoices(dateModified: invoiceDateModified));
    }
    refreshing.value = false;
    _isRefreshing = false;
  }

  fetchCustomers({String? dateModified}) async {
    var customers = <CustomerEntity>[];
    try {
      final result = await _customerRepository.fetchCustomerList(
          dateModified: dateModified);

      result.fold((failure) {
        if (!kReleaseMode) {
          debugPrint(failure.message);
        }
      }, (c) async {
        if (c.isNotEmpty) {
          customers = c;
        }
      });
    } catch (e) {
      //
    }
    return customers;
  }

  Future<void> syncCustomers({String? dateModified}) async {
    if (_networkController.connected.value) {
      try {
        //  List<CustomerModel> apiCustomers =
        await fetchCustomers(dateModified: dateModified)
            .then((customers) async => await _saveCustomers(customers));

        // final apiIds = apiCustomers.map((e) => e.id).toSet();
        // Box<CustomerModel> customerBox = _storage.objectBox.customerBox;
        // final keysToDelete = customerBox.keys.where((key) {
        //   final customer = customerBox.get(key);
        //   return customer != null && !apiIds.contains(customer.id);
        // }).toList();

        // if (apiCustomers.isNotEmpty && apiIds.isNotEmpty) {
        //   await customerBox.deleteAll(keysToDelete);
        // }
      } on Exception catch (e) {
        if (!kReleaseMode) {
          debugPrint(e.toString());
          return;
        }
      }
    }
  }

  CustomerEntity upsertCustomer(
      CustomerEntity customer, Box<CustomerEntity> box) {
    final existing = box
        .query(CustomerEntity_.customerId.equals(customer.customerId))
        .build()
        .findFirst();

    if (existing != null) {
      customer.id = existing.id; // assign internal ObjectBox ID to update
    }

    box.put(customer); // will insert or update based on ID
    return customer;
  }

  _saveCustomers(List<CustomerEntity> customers) async {
    for (var customer in customers) {
      upsertCustomer(customer, _storage.customerBox);
    }
    if (Get.isDialogOpen == true) {
      DialogHelper.updateMessage('Saved ${customers.length} customer(s)');
    }
  }

  fetchInvoices({String? customerId, String? dateModified}) async {
    var invoices = <InvoiceEntity>[];
    try {
      final result = await _invoiceRepository.fetchInvoiceList(
          customerId: customerId, dateModified: dateModified);
      result.fold((e) {}, (i) {
        invoices = i;
      });
    } catch (e) {
      //
    }

    return invoices;
  }

  Future<void> syncInvoices({String? customerId, String? dateModified}) async {
    if (_networkController.connected.value) {
      if (customerId != null || dateModified != null) {
        await fetchInvoices(customerId: customerId, dateModified: dateModified)
            .then((invoices) async => await _saveInvoices(invoices));
      } else {
        await fetchInvoices()
            .then((invoices) async => await _saveInvoices(invoices));
      }
    }
  }

  InvoiceEntity upsertInvoice(InvoiceEntity invoice, Box<InvoiceEntity> box) {
    final existing = box
        .query(InvoiceEntity_.documentId.equals(invoice.documentId))
        .build()
        .findFirst();

    if (existing != null) {
      invoice.id = existing.id; // assign internal ObjectBox ID to update
    }

    box.put(invoice); // will insert or update based on ID
    return invoice;
  }

  _saveInvoices(List<InvoiceEntity> invoices) async {
    for (var invoice in invoices) {
      upsertInvoice(invoice, _storage.invoiceBox);
    }
    if (Get.isDialogOpen == true) {
      DialogHelper.updateMessage('Saved ${invoices.length} invoice(s)');
    }
  }

  fetchPayment({required String documentId}) async {
    final result = await (_invoiceRepository.fetchPaymentsByInvoice(
        invoiceId: documentId));

    result.fold(
        (failure) => SnackBarHelper.errorSnackbar(message: failure.message),
        (payments) {});
  }

  PaymentEntity upsertPayment(PaymentEntity payment, Box<PaymentEntity> box) {
    final existing = box
        .query(PaymentEntity_.invoiceId.equals(payment.invoiceId))
        .build()
        .findFirst();

    if (existing != null) {
      payment.id = existing.id; // assign internal ObjectBox ID to update
    }

    box.put(payment); // will insert or update based on ID
    return payment;
  }

  void _importCustomersToAddressBox() {
    final customers = _storage.customerBox.getAll();
    final box = _storage.addressBox;

    for (var customer in customers) {
      if (customer.address.isNotEmpty && customer.town.isNotEmpty) {
        final exists = box
            .query(AddressModel_.address
                .equals(customer.address)
                .and(AddressModel_.town.equals(customer.town)))
            .build()
            .findFirst();

        if (exists == null) {
          box.put(AddressModel(
            town: customer.town,
            address: customer.address,
          ));
        }
      }
    }
  }
}
