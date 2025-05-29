import 'package:dolirest/infrastructure/dal/models/customer/customer_entity.dart';
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
  final DataRefreshContoller _dataRefreshContoller = Get.find();

  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  var searchString = ''.obs;
  var searchIcon = true.obs;

  var invoices = <InvoiceEntity>[].obs;

  @override
  void onInit() {
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

  void _updateInvoices() {
    final list = storage.getInvoiceList();
    for (InvoiceEntity l in list) {
      CustomerEntity? customer = storage.getCustomer(l.socid!);
      if (customer != null) {
        l.name = customer.name;
      }
    }
    list.removeWhere((i) => i.name == null);
    list.sort((a, b) => a.name!.compareTo(b.name!));
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
