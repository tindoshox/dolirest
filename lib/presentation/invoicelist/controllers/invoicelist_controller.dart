import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/invoice_repository.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvoicelistController extends GetxController {
  final StorageService storage = Get.find();
  final InvoiceRepository repository = Get.find();
  var isLoading = false.obs;

  bool isLastPage = false;

  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  var searchString = ''.obs;
  var searchIcon = true.obs;

  @override
  void onClose() {
    searchController.dispose();

    super.onClose();
  }

  search({String searchText = ""}) {
    searchString.value = searchText;
  }

  refreshInvoiceList() async {
    isLoading(true);

    final result = await repository.fetchInvoiceList(status: "unpaid");
    result.fold((failure) {
      isLoading(false);
      SnackBarHelper.errorSnackbar(message: failure.message);
    }, (invoices) {
      isLoading(false);
      for (InvoiceModel invoice in invoices) {
        storage.storeInvoice(invoice.id, invoice);
      }
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
}
