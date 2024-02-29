import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/models/customer_list_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';

class CustomerlistController extends GetxController {
  var customers = <ThirdParty>[].obs;
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
    customers.value = <ThirdParty>[];
    isLoading(true);
    searchString = '%${text.trim()}%';
    _fetchCustomers();
  }

  Future<void> _loadMore() async {
    isLoadingMore(true);

    pageNumber++;
    await _fetchCustomers().then((value) => isLoadingMore(false));
  }

  Future _fetchCustomers() async {
    await RemoteServices.fetchThirdPartyList(searchString, '1', pageNumber)
        .then((value) {
      if (!value.hasError) {
        customers.addAll(value.data);
      }

      if (value.data.length < 50) {
        isLastPage = true;
      }

      isLoading(false);
      isLoadingMore(false);
    });
  }
}
