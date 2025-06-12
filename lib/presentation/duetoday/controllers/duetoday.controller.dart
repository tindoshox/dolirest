import 'package:dolirest/infrastructure/dal/models/customer/customer_entity.dart';
import 'package:dolirest/infrastructure/dal/models/invoice/invoice_entity.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/data_refresh_service.dart';
import 'package:dolirest/utils/string_manager.dart'
    show DocumentType, PaidStatus;
import 'package:dolirest/utils/utils.dart';
import 'package:get/get.dart';

class DueTodayController extends GetxController {
  final data = Get.find<DataRefreshService>();
  var dueToday = <InvoiceEntity>[].obs;
  var customers = <CustomerEntity>[].obs;

  @override
  void onInit() {
    everAll([data.invoices, data.customers], (_) {
      dueToday.value = data.invoices
          .where((i) =>
              i.type == DocumentType.invoice &&
              i.remaintopay != "0" &&
              i.paye == PaidStatus.unpaid &&
              Utils.intToDateTime(i.dateLimReglement).day ==
                  DateTime.now().day &&
              Utils.intToDateTime(i.dateLimReglement)
                  .isBefore(DateTime.now().add(Duration(days: 1))))
          .toList();
      customers.value = data.customers;
    });

    super.onInit();
  }
}
