// ignore_for_file: unused_import

import 'dart:async';

import 'package:dolirest/infrastructure/dal/models/address_model.dart';
import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/network_controller.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/customer_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/invoice_repository.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class DataRefreshContoller extends GetxController {
  final StorageService _storage = StorageService();
  final CustomerRepository _customerRepository = Get.find();
  final InvoiceRepository _invoiceRepository = Get.find();
  final NetworkController _networkController = Get.find();
  var refreshing = false.obs;
  bool _isRefreshing = false;

  @override
  void onInit() {
    _dataRefreshSchedule();

    super.onInit();
  }

  void _dataRefreshSchedule() {
    final customers = _storage.getCustomerList();
    customers.sort((a, b) => a.dateModification.compareTo(b.dateModification));

    String? customerDateModified = customers.isEmpty
        ? null
        : Utils.intToYMD(customers.last.dateModification);

    var invoices = _storage.getInvoiceList();

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
          (v) async => await syncInvoices(dateModified: invoiceDateModified));
    }
    refreshing.value = false;
    _isRefreshing = false;
  }

  Future<List<CustomerModel>> fetchAllCustomersInBatches(
      {String? dateModified}) async {
    final List<CustomerModel> apiCustomers = [];
    int page = 1;
    const int limit = 100;
    bool hasMore = true;

    while (hasMore) {
      final result = await _customerRepository.fetchCustomerList(
          page: page, limit: limit, dateModified: dateModified);

      result.fold((failure) {
        if (!kReleaseMode) {
          debugPrint(failure.message);
          hasMore = false;
        }
      }, (customers) {
        apiCustomers.addAll(customers);

        hasMore = customers.length == limit;
        page++;
      });
    }

    return apiCustomers;
  }

  Future<void> syncCustomers({String? dateModified}) async {
    if (_networkController.connected.value) {
      final apiCustomers =
          await fetchAllCustomersInBatches(dateModified: dateModified);
      await _saveCustomers(apiCustomers);

      final apiIds = apiCustomers.map((e) => e.id).toSet();
      Box<CustomerModel> customerBox = _storage.customers;
      final keysToDelete = customerBox.keys.where((key) {
        final customer = customerBox.get(key);
        return customer != null && !apiIds.contains(customer.id);
      }).toList();

      if (apiCustomers.isNotEmpty) {
        await customerBox.deleteAll(keysToDelete);
      }
    }
  }

  _saveCustomers(List<CustomerModel> customers) {
    for (CustomerModel customer in customers) {
      _storage.storeCustomer(customer.id, customer);
      if (customer.address != null && customer.town != null) {
        _storage.storeAddresses(
          '${customer.town}-${customer.address}',
          AddressModel(
            town: customer.town,
            address: customer.address,
          ),
        );
      }
    }
  }

  Future<List<InvoiceModel>> fetchAllInvoicesInBatches(
      {String? customerId, String? dateModified}) async {
    final List<InvoiceModel> allInvoices = [];
    int page = 1;
    const int limit = 100;
    bool hasMore = true;

    while (hasMore) {
      final result = await _invoiceRepository.fetchInvoiceList(
          page: page,
          limit: limit,
          customerId: customerId,
          dateModified: dateModified);

      result.fold((failure) {
        if (!kReleaseMode) {
          debugPrint(failure.message);
        }
        hasMore = false;
      }, (invoices) {
        allInvoices.addAll(invoices);

        hasMore = invoices.length == limit;
        page++;
      });
    }

    return allInvoices;
  }

  Future<void> syncInvoices({String? customerId, String? dateModified}) async {
    if (_networkController.connected.value) {
      final apiInvoices = await fetchAllInvoicesInBatches(
          customerId: customerId, dateModified: dateModified);
      await _setInvoiceNames(apiInvoices);

      final apiIds = apiInvoices.map((e) => e.id).toSet();
      Box<InvoiceModel> invoiceBox = _storage.invoices;
      final keysToDelete = invoiceBox.keys.where((key) {
        final invoice = invoiceBox.get(key);
        return invoice != null && !apiIds.contains(invoice.id);
      }).toList();

      if (apiInvoices.isNotEmpty) {
        await invoiceBox.deleteAll(keysToDelete);
      }
    }
  }

  _setInvoiceNames(List<InvoiceModel> invoices) async {
    for (InvoiceModel invoice in invoices) {
      final customer = _storage.getCustomer(invoice.socid);
      if (customer != null) {
        invoice.name = customer.name;
        _storage.storeInvoice(invoice.id, invoice);
      }
    }
  }

  fetchPayment({required String documentId}) async {
    final result = await (_invoiceRepository.fetchPaymentsByInvoice(
        invoiceId: documentId));

    result.fold(
        (failure) => SnackBarHelper.errorSnackbar(message: failure.message),
        (payments) {
      for (var payment in payments) {
        PaymentModel p = PaymentModel(
          amount: payment.amount,
          type: payment.type,
          date: payment.date,
          num: payment.num,
          fkBankLine: payment.fkBankLine,
          ref: payment.ref,
          invoiceId: documentId,
          refExt: payment.refExt,
        );
        _storage.storePayment(payment.ref, p);
      }
    });
  }
}
