import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';
import 'package:hive_flutter/hive_flutter.dart';

class InvoicelistController extends GetxController {
  var isLoading = false.obs;

  var isLastPage = false;

  final searchController = TextEditingController();
  final scrollController = ScrollController();

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

  getAllInvoices() async {
    isLoading(true);

    await RemoteServices.fetchInvoiceList().then((value) async {
      isLoading(false);
      if (!value.hasError) {
        var box = await Hive.openBox<InvoiceModel>('invoices');
        for (var invoice in value.data) {
          box.put(invoice.id, invoice);
        }

        SnackBarHelper.successSnackbar(message: 'Inovice data refreshed');
      } else {
        SnackBarHelper.errorSnackbar(message: 'Could not refresh invoice data');
      }
    });
  }
}
