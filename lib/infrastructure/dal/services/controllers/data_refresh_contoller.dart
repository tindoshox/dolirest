// ignore_for_file: unused_import

import 'dart:async';
import 'dart:isolate';

import 'package:dolirest/infrastructure/dal/models/address_model.dart';
import 'package:dolirest/infrastructure/dal/models/customer/customer_entity.dart';
import 'package:dolirest/infrastructure/dal/models/invoice/invoice_entity.dart';
import 'package:dolirest/infrastructure/dal/models/payment/payment_entity.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/network_controller.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/customer_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/invoice_repository.dart';
import 'package:dolirest/objectbox.g.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/string_manager.dart';
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
  var payments = <PaymentEntity>[].obs;
  var noInvoiceCustomers = 0.obs;
  var cashflow = 0.obs;
  var refreshing = false.obs;
  bool _isRefreshing = false;

  @override
  void onInit() {
    super.onInit();

    _dataRefreshSchedule();
    invoices.bindStream(_storage.invoiceBox
        .query()
        .order(InvoiceEntity_.name, flags: Order.nullsLast)
        .watch(triggerImmediately: true)
        .map((query) {
      return query.find();
    }));

    invoices.value = _storage.invoiceBox.getAll();
    customers.bindStream(_storage.customerBox
        .query()
        .order(CustomerEntity_.name, flags: Order.nullsLast)
        .watch(triggerImmediately: true)
        .map((query) => query.find()));

    cashflow.bindStream(
      _storage.paymentBox
          .query(PaymentEntity_.date.equalsDate(Utils.dateOnly(DateTime.now())))
          .watch(triggerImmediately: true)
          .map((query) {
        final payments = query.find();
        return payments.isEmpty
            ? 0
            : payments
                .map((p) => Utils.intAmounts(p.amount))
                .toList()
                .reduce((a, b) => a + b);
      }),
    );

    payments.bindStream(_storage.paymentBox
        .query()
        .watch(triggerImmediately: true)
        .map((query) {
      return query.find();
    }));

    _importCustomersToAddressBox();
  }

  void _dataRefreshSchedule() {
    final c = _storage.customerBox
        .query()
        .order(CustomerEntity_.dateModification, flags: Order.descending)
        .build()
        .findFirst();

    String? customerDateModified =
        c == null ? null : Utils.intToYMD(c.dateModification);

    final i = _storage.invoiceBox
        .query()
        .order(InvoiceEntity_.dateModification, flags: Order.descending)
        .build()
        .findFirst();

    String? invoiceDateModified =
        i == null ? null : Utils.intToYMD(i.dateModification);

    Timer.periodic(const Duration(minutes: 5), (Timer timer) async {
      await forceRefresh(
          customerDateModified: customerDateModified,
          invoiceDateModified: invoiceDateModified);
    });
  }

  Future forceRefresh(
      {String? customerDateModified, String? invoiceDateModified}) async {
    if (_isRefreshing || !_networkController.connected.value) {
      return;
    }
    _isRefreshing = true;

    if (_networkController.connected.value) {
      await syncCustomers(dateModified: customerDateModified).then(
          (customers) async =>
              await syncInvoices(dateModified: invoiceDateModified));
    }

    _isRefreshing = false;
  }

  fetchCustomers({String? dateModified}) async {
    try {
      final result = await _customerRepository.fetchCustomerList(
          dateModified: dateModified);

      result.fold((failure) {
        if (!kReleaseMode) {
          debugPrint(failure.message);
        }
      }, (customers) async {
        if (customers.isNotEmpty) {
          _storage.storeCustomers(customers);
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
        await fetchCustomers(dateModified: dateModified);
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
      customer.id = existing.id;
    }

    box.put(customer);
    return customer;
  }

  fetchInvoices({String? customerId, String? dateModified}) async {
    try {
      final result = await _invoiceRepository.fetchInvoiceList(
          customerId: customerId, dateModified: dateModified);
      result.fold((e) {}, (invoices) {
        _storage.storeInvoices(invoices);
      });
    } catch (e) {
      //
    }
  }

  Future<void> syncInvoices({String? customerId, String? dateModified}) async {
    if (_networkController.connected.value) {
      if (customerId != null || dateModified != null) {
        await fetchInvoices(customerId: customerId, dateModified: dateModified);
      }
    } else {
      await fetchInvoices();
    }
  }

  Future refreshPaymentData(List<InvoiceEntity> invs) async {
    if (invs.isNotEmpty) {
      for (var invoice in invs) {
        if (invoice.type == DocumentType.invoice &&
            invoice.remaintopay != invoice.totalTtc) {
          final res = await _invoiceRepository.fetchPaymentsByInvoice(
              invoiceId: invoice.documentId);
          res.fold((failure) => null, (ps) {
            for (var p in ps) {
              _storage.storePayment(p);
            }
          });
        }
      }
    }
    return 1;
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
