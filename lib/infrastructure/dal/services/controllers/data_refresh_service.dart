// ignore_for_file: unused_import

import 'dart:async';
import 'dart:isolate';

import 'package:dolirest/infrastructure/dal/models/address_model.dart';
import 'package:dolirest/infrastructure/dal/models/customer/customer_entity.dart';
import 'package:dolirest/infrastructure/dal/models/invoice/invoice_entity.dart';
import 'package:dolirest/infrastructure/dal/models/payment/payment_entity.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/network_service.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/dio_service.dart';
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
  final NetworkService _network = Get.find();
  final DioService _dioService = Get.find();

  var invoices = <InvoiceEntity>[].obs;
  var customers = <CustomerEntity>[].obs;
  var payments = <PaymentEntity>[].obs;
  var cashflow = 0.obs;
  bool _isRefreshing = false;
  var connected = false.obs;

  @override
  void onInit() {
    super.onInit();
    ever(_network.connected, (_) {
      connected = _network.connected;
    });
    connected = _network.connected;

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

    Timer.periodic(const Duration(minutes: 10), (Timer timer) async {
      await forceRefresh(
          customerDateModified: customerDateModified,
          invoiceDateModified: invoiceDateModified);
    });
  }

  Future forceRefresh(
      {String? customerDateModified, String? invoiceDateModified}) async {
    if (_isRefreshing || !connected.value) {
      return;
    }
    _isRefreshing = true;
    SnackBarHelper.successSnackbar(message: 'Refreshing data');

    // if (_networkController.connected.value) {
    await syncCustomers(dateModified: customerDateModified).then(
        (customers) async =>
            await syncInvoices(dateModified: invoiceDateModified));
    //  }

    _isRefreshing = false;
  }

  Future<void> fetchCustomers({String? dateModified}) async {
    const int limit = 100;
    int page = 0;
    bool hasMore = true;

    final token = _dioService.createToken('sync-customers');

    while (hasMore) {
      if (token.isCancelled) {
        debugPrint("Cancelled at page $page");
        break;
      }

      final result = await _customerRepository.fetchCustomerList(
        page: page,
        limit: limit,
        dateModified: dateModified,
        cancelToken: token,
      );

      final shouldContinue = await result.fold<Future<bool>>(
        (error) async {
          debugPrint("Error: ${error.message}");
          return false;
        },
        (customers) async {
          await _storage.storeCustomers(customers);
          return customers.length == limit; // continue only if full batch
        },
      );

      hasMore = shouldContinue;
      page++;
    }
  }

  Future<void> syncCustomers({String? dateModified}) async {
    if (_network.connected.value) {
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

  Future<void> fetchInvoices({String? customerId, String? dateModified}) async {
    const int limit = 100;
    int page = 0;
    bool hasMore = true;

    final token = _dioService.createToken('sync-invoices');

    while (hasMore) {
      if (token.isCancelled) {
        debugPrint("Cancelled at page $page");
        break;
      }

      final result = await _invoiceRepository.fetchInvoiceList(
        page: page,
        limit: limit,
        dateModified: dateModified,
        cancelToken: token,
      );

      final shouldContinue = await result.fold<Future<bool>>(
        (error) async {
          debugPrint("Error: ${error.message}");
          return false;
        },
        (invoices) async {
          await _storage.storeInvoices(invoices);
          return invoices.length == limit; // continue only if full batch
        },
      );

      hasMore = shouldContinue;
      page++;
    }
  }

  Future<void> syncInvoices({String? customerId, String? dateModified}) async {
    if (_network.connected.value) {
      await fetchInvoices(customerId: customerId, dateModified: dateModified);
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
