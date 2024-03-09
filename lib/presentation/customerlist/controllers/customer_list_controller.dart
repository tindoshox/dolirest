import 'package:dolirest/infrastructure/dal/models/third_party_model.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CustomerlistController extends GetxController {
  var customers = <ThirdPartyModel>[].obs;
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var isLastPage = false;

  final searchController = TextEditingController();
  final scrollController = ScrollController();

  int pageNumber = 0;
  String searchString = '';

  @override
  void onInit() async {
    var box = await Hive.openBox<ThirdPartyModel>('customers');
    var list = box.toMap().values.toList();

    if (list.length < 50) {
      await getAllCustomers();
    } else {
      customers.value = list;
    }
    super.onInit();
  }

  Future<void> search({String searchText = ""}) async {
    var box = await Hive.openBox<ThirdPartyModel>('customers');
    isLoading(true);

    if (searchText != "") {
      customers.value = box
          .toMap()
          .values
          .toList()
          .where((customer) =>
              customer.name.contains(searchText) ||
              customer.address.toString().contains(searchText) ||
              customer.town.toString().contains(searchText) ||
              customer.phone.toString().contains(searchText) ||
              customer.fax.toString().contains(searchText))
          .toList();
    } else {
      customers.value = box.toMap().values.toList();
    }

    isLoading(false);
  }

  getAllCustomers() async {
    isLoading(true);

    await RemoteServices.fetchThirdPartyList().then((value) async {
      isLoading(false);
      if (!value.hasError) {
        var box = await Hive.openBox<ThirdPartyModel>('customers');
        for (ThirdPartyModel customer in value.data) {
          box.put(customer.id, customer);
        }
        customers.value = box.toMap().values.toList();
        SnackBarHelper.successSnackbar(message: 'Customer data refreshed');
      } else {
        SnackBarHelper.errorSnackbar(
            message: 'Could not refresh customer data');
      }
    });
  }
}
