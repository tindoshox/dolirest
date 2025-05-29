// ignore_for_file: unused_import

import 'dart:async';

import 'package:dolirest/infrastructure/dal/models/address_model.dart';
import 'package:dolirest/infrastructure/dal/models/customer/customer_entity.dart';
import 'package:dolirest/infrastructure/dal/models/customer/customer_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice/invoice_entity.dart';
import 'package:dolirest/infrastructure/dal/models/invoice/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
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

class DataRefreshContoller extends GetxController {
  final StorageService _storage = Get.find();
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
    customers
        .sort((a, b) => a.dateModification!.compareTo(b.dateModification!));

    String? customerDateModified = customers.isEmpty
        ? null
        : Utils.intToYMD(customers.last.dateModification!);

    var invoices = _storage.getInvoiceList();
    invoices.removeWhere((i) => i.dateModification == null);
    invoices.sort((a, b) => a.dateModification!.compareTo(b.dateModification!));
    String? invoiceDateModified = invoices.isEmpty
        ? null
        : Utils.intToYMD(invoices.last.dateModification!);

    Timer.periodic(const Duration(seconds: 600), (Timer timer) async {
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

  _saveCustomers(List<CustomerEntity> customers) async {
    _storage.storeCustomers(customers);
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

  _saveInvoices(List<InvoiceEntity> invoices) async {
    _storage.storeInvoices(invoices);
    if (Get.isDialogOpen == true) {
      DialogHelper.updateMessage('Saved ${invoices.length} invoice(s)');
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
        _storage.storePayment(p);
      }
    });
  }
}
