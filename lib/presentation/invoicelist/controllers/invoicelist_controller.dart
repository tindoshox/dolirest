import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/invoice_repository.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/string_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvoicelistController extends GetxController {
  int drafts = Get.arguments['drafts'] ?? 0;
  final StorageService storage = Get.find();
  final InvoiceRepository _invoiceRepository = Get.find();
  var isLoading = false.obs;

  bool isLastPage = false;

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

  refreshInvoiceList({bool all = true}) async {
    isLoading(true);

    final result = await _invoiceRepository.fetchInvoiceList(status: "unpaid");
    result.fold((failure) {
      isLoading(false);
      SnackBarHelper.errorSnackbar(message: failure.message);
    }, (invoices) {
      isLoading(false);
      for (InvoiceModel invoice in invoices) {
        final customer = storage.getCustomer(invoice.socid);
        invoice.name = customer!.name;
        storage.storeInvoice(invoice.id, invoice);
      }

      final apiIds = invoices.map((invoice) => invoice.id).toSet();
      List<InvoiceModel> localInvoices = storage.getInvoiceList();
      final keysToDelete = <dynamic>[];
      for (var localInvoice in localInvoices) {
        if (!apiIds.contains(localInvoice.id)) {
          keysToDelete.add(localInvoice.id);
        }
      }

      storage.deleteAllInvoices(keysToDelete);
      storage.deleteAllPayments(keysToDelete);
    });
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
