import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';
import 'package:hive_flutter/hive_flutter.dart';

class InvoicelistController extends GetxController {
  var invoices = <InvoiceModel>[].obs;
  var isLoading = false.obs;

  var isLastPage = false;

  final searchController = TextEditingController();
  final scrollController = ScrollController();

  int page = 0;
  String searchString = '';

  @override
  void onInit() async {
    var box = await Hive.openBox<InvoiceModel>('invoices');
    var list = box.toMap().values.toList();
    if (list.length < 50) {
      getAllInvoices();
    } else {
      invoices.value = list;
    }

    super.onInit();
  }

  Future<void> search({String searchText = ""}) async {
    var box = await Hive.openBox<InvoiceModel>('invoices');
    isLoading(true);

    if (searchText != "") {
      invoices.value = box
          .toMap()
          .values
          .toList()
          .where((invoice) =>
              invoice.nom!.contains(searchText) ||
              invoice.ref!.contains(searchText))
          .toList();
    } else {
      invoices.value = box.toMap().values.toList();
    }

    isLoading(false);
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
        invoices.value = box.toMap().values.toList();
        SnackBarHelper.successSnackbar(message: 'Inovice data refreshed');
      } else {
        SnackBarHelper.errorSnackbar(message: 'Could not refresh invoice data');
      }
    });
  }
}
