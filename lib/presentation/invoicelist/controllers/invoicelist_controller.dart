import 'package:dolirest/infrastructure/dal/models/customer/customer_entity.dart';
import 'package:dolirest/infrastructure/dal/models/invoice/invoice_entity.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/data_refresh_service.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/invoice_repository.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/string_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvoicelistController extends GetxController {
  int drafts = Get.arguments['drafts'] ?? 0;
  final StorageService _storage = Get.find();
  final DataRefreshService _data = Get.find();
  final InvoiceRepository _invoiceRepository = Get.find();

  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  var searchString = ''.obs;
  var searchIcon = true.obs;

  var invoices = <InvoiceEntity>[].obs;
  var customers = <CustomerEntity>[].obs;

  @override
  void onInit() {
    everAll([_data.invoices, _data.customers], (_) {
      invoices.value = drafts != 0
          ? _data.invoices
              .where((invoice) => invoice.status == ValidationStatus.draft)
              .toList()
          : _data.invoices
              .where((invoice) =>
                  invoice.type == DocumentType.invoice &&
                  invoice.remaintopay != "0" &&
                  invoice.status == ValidationStatus.validated &&
                  invoice.paye == PaidStatus.unpaid)
              .toList();

      customers = _data.customers;
      for (var invoice in invoices) {
        invoice.name =
            customers.firstWhere((c) => c.customerId == invoice.socid).name;
      }
    });

    invoices.value = drafts != 0
        ? _data.invoices
            .where((invoice) => invoice.status == ValidationStatus.draft)
            .toList()
        : _data.invoices
            .where((invoice) =>
                invoice.type == DocumentType.invoice &&
                invoice.remaintopay != "0" &&
                invoice.status == ValidationStatus.validated &&
                invoice.paye == PaidStatus.unpaid)
            .toList();

    customers = _data.customers;
    for (var invoice in invoices) {
      invoice.name =
          customers.firstWhere((c) => c.customerId == invoice.socid).name;
    }
    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();

    super.onClose();
  }

  void search({String searchText = ""}) {
    searchString.value = searchText;
  }

  Future refreshInvoiceList() async {
    SnackBarHelper.successSnackbar(message: 'Refreshing invoices');
    await _data.syncInvoices();
  }

  void toggleSearch() {
    if (searchController.text.isEmpty) {
      searchIcon.value = !searchIcon.value;
    }
    if (!searchIcon.value) {
      searchController.clear();
      searchString.value = "";
    }
  }

  void deleteDraft({required String documentId, required int entityId}) async {
    DialogHelper.showLoading('Deleting Invoice');
    final result =
        await _invoiceRepository.deleteInvoice(documentId: documentId);
    result.fold((failure) {
      DialogHelper.hideLoading();
      if (failure.code == 404) {
        _storage.invoiceBox.remove(entityId);

        SnackBarHelper.errorSnackbar(
            message: 'Invoice Deleted', duration: Duration(seconds: 1));
      } else {
        SnackBarHelper.errorSnackbar(message: 'Failed to delete draft');
      }
    }, (deleted) {
      DialogHelper.hideLoading();
      _storage.invoiceBox.remove(entityId);

      SnackBarHelper.errorSnackbar(
          message: 'Invoice Deleted', duration: Duration(seconds: 1));
    });
  }
}
