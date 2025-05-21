// ignore_for_file: unused_import

import 'dart:async';

import 'package:dolirest/infrastructure/dal/models/address_model.dart';
import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/network_controller.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/customer_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/invoice_repository.dart';
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
    if (!kDebugMode) {
      _dataRefreshSchedule();
    }
    super.onInit();
  }

  void _dataRefreshSchedule() {
    Timer.periodic(const Duration(minutes: 10), (Timer timer) async {
      await forceRefresh();
    });
  }

  Future<void> forceRefresh() async {
    if (_isRefreshing) {
      return;
    }
    _isRefreshing = true;
    refreshing.value = true;

    if (_networkController.connected.value) {
      await _syncCustomersWithApi()
          .then((v) async => await _syncInvoicesWithApi());
    }
    refreshing.value = false;
    _isRefreshing = false;
  }

  Future<void> _syncCustomersWithApi() async {
    final result = await _customerRepository.fetchCustomerList();
    result.fold((failure) {}, (customers) {
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

      for (var customer in customers) {
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
      List<CustomerModel> localCustomers = _storage.getCustomerList();
      final apiIds = customers.map((customer) => customer.id).toSet();
      final keysToDelete = <dynamic>[];
      for (var localCustomer in localCustomers) {
        if (!apiIds.contains(localCustomer.id)) {
          keysToDelete.add(localCustomer.id);
        }
      }

      _storage.deleteAllCustomer(keysToDelete);
    });
  }

  Future<void> _syncInvoicesWithApi() async {
    final result = await _invoiceRepository.fetchInvoiceList();
    result.fold((failure) {}, (invoices) {
      for (InvoiceModel invoice in invoices) {
        final customer = _storage.getCustomer(invoice.socid);
        invoice.name = customer!.name;
        _storage.storeInvoice(invoice.id, invoice);
      }
      final apiIds = invoices.map((invoice) => invoice.id).toSet();
      List<InvoiceModel> localInvoices = _storage.getInvoiceList();
      final keysToDelete = <dynamic>[];
      for (var localInvoice in localInvoices) {
        if (!apiIds.contains(localInvoice.id)) {
          keysToDelete.add(localInvoice.id);
        }
      }

      _storage.deleteAllInvoices(keysToDelete);
      _storage.deleteAllPayments(keysToDelete);
    });
  }
}
