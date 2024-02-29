import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_list_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';

class InvoicelistController extends GetxController {
  var invoices = <InvoiceList>[].obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var isLastPage = false;

  final searchController = TextEditingController();
  final scrollController = ScrollController();

  int pageNumber = 0;
  String searchString = '';

  @override
  void onInit() {
    initialSearch(searchString);
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
              scrollController.offset &&
          !isLastPage &&
          !isLoadingMore.value) {
        _loadMore();
      }
    });
    super.onInit();
  }

  void initialSearch(String text) {
    pageNumber = 0;
    invoices.value = <InvoiceList>[];
    isLoading(true);
    searchString = '%${text.trim()}%';
    _fetchInvoices();
  }

  Future<void> _loadMore() async {
    isLoadingMore(true);

    pageNumber++;
    await _fetchInvoices().then((value) => isLoadingMore(false));
  }

  Future _fetchInvoices() async {
    await RemoteServices.fetchInvoiceList(searchString, pageNumber)
        .then((value) {
      if (!value.hasError) {
        invoices.addAll(value.data);
      }
      if (value.data.length < 50) {
        isLastPage = true;
      }
      isLoading(false);
      isLoadingMore(false);
    });
  }
}
