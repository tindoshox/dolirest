import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_service.dart';
import 'package:dolirest/utils/string_manager.dart' show DocumentType;
import 'package:dolirest/utils/utils.dart';
import 'package:get/get.dart';

class DueTodayController extends GetxController {
  final storage = Get.find<StorageService>();
  var dueToday = <InvoiceModel>[].obs;

  @override
  void onInit() {
    _watchBoxes();
    _updateInvoices();
    super.onInit();
  }

  void _watchBoxes() {
    storage.invoicesListenable().addListener(_updateInvoices);
  }

  void _updateInvoices() {
    var invoices = storage.getInvoiceList();
    dueToday.value = invoices
        .where((invoice) =>
            invoice.type == DocumentType.invoice &&
            invoice.remaintopay != "0" &&
            Utils.intToDateTime(invoice.dateLimReglement!).day ==
                DateTime.now().day)
        .toList();
  }
}
