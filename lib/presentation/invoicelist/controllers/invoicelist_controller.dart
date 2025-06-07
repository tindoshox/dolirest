import 'package:dolirest/infrastructure/dal/models/invoice/invoice_entity.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/data_refresh_contoller.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_service.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/string_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvoicelistController extends GetxController {
  int drafts = Get.arguments['drafts'] ?? 0;
  final StorageService storage = Get.find();
  final DataRefreshService _dataRefreshContoller = Get.find();

  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  var searchString = ''.obs;
  var searchIcon = true.obs;

  var invoices = <InvoiceEntity>[].obs;

  @override
  void onInit() {
    // invoices.bindStream(
    //     storage.invoiceBox.query().watch(triggerImmediately: true).map((query) {
    //   final list = query.find();

    if (drafts != 0) {
      invoices.value = _dataRefreshContoller.invoices
          .where((invoice) => invoice.status == ValidationStatus.draft)
          .toList();
    } else {
      invoices.value = _dataRefreshContoller.invoices
          .where((invoice) =>
              invoice.type == DocumentType.invoice &&
              invoice.remaintopay != "0" &&
              invoice.status == ValidationStatus.validated &&
              invoice.paye == PaidStatus.unpaid)
          .toList();
    }

    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();

    super.onClose();
  }

  search({String searchText = ""}) {
    searchString.value = searchText;
  }

  refreshInvoiceList() async {
    if (!_dataRefreshContoller.refreshing.value) {
      DialogHelper.showLoading('Syncing invoices');
      await _dataRefreshContoller
          .syncInvoices()
          .then((i) => DialogHelper.hideLoading());
    } else {
      SnackBarHelper.errorSnackbar(message: 'Data refresh already running');
    }
  }

  toggleSearch() {
    if (searchController.text.isEmpty) {
      searchIcon.value = !searchIcon.value;
    }
    if (!searchIcon.value) {
      searchController.clear();
      searchString.value = "";
    }
  }
}
