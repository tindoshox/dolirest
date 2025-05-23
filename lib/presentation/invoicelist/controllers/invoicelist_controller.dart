import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/data_refresh_contoller.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_service.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/string_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvoicelistController extends GetxController {
  int drafts = Get.arguments['drafts'] ?? 0;
  final StorageService storage = Get.find();
  final DataRefreshContoller _dataRefreshContoller = Get.find();

  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  var searchString = ''.obs;
  var searchIcon = true.obs;

  var invoices = <InvoiceModel>[].obs;

  @override
  void onInit() {
    _watchBoxes();
    _updateInvoices();
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
    DialogHelper.showLoading('Syncing invoices');
    await _dataRefreshContoller.syncInvoices();
    DialogHelper.hideLoading();
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

  void _watchBoxes() {
    storage.invoicesListenable().addListener(_updateInvoices);
  }

  void _updateInvoices() {
    final list = storage.getInvoiceList();
    list.removeWhere((i) => i.name == null);
    list.sort((a, b) => a.name.compareTo(b.name));
    if (drafts != 0) {
      invoices.value = list
          .where((invoice) => invoice.status == ValidationStatus.draft)
          .toList();
    } else {
      invoices.value = list
          .where((invoice) =>
              invoice.type == DocumentType.invoice &&
              invoice.remaintopay != "0" &&
              invoice.status == ValidationStatus.validated &&
              invoice.paye == PaidStatus.unpaid)
          .toList();
    }
  }
}
