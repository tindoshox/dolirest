import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/services/storage.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';

class InvoicelistController extends GetxController {
  RxBool isLoading = false.obs;

  bool isLastPage = false;

  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  RxString searchString = ''.obs;
  RxBool searchIcon = true.obs;

  @override
  void onClose() {
    searchController.dispose();

    super.onClose();
  }

  search({String searchText = ""}) {
    searchString.value = searchText;
  }

  getAllInvoices() async {
    isLoading(true);

    await RemoteServices.fetchInvoiceList(status: "unpaid").then((value) async {
      isLoading(false);
      if (!value.hasError) {
        for (InvoiceModel invoice in value.data) {
          Storage.invoices.put(invoice.id, invoice);
        }

        SnackBarHelper.successSnackbar(message: 'Invoice data refreshed');
      } else {
        SnackBarHelper.errorSnackbar(message: 'Could not refresh invoice data');
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
