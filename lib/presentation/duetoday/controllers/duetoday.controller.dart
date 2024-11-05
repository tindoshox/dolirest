import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:get/get.dart';

class DueTodayController extends GetxController {
  final storage = Get.find<StorageService>();
  final dueToday = Get.arguments['dueToday'];
  var dueList = <DueTodayModel>[].obs;

  @override
  void onInit() {
    _dueList();
    super.onInit();
  }

  _dueList() {
    var list = <DueTodayModel>[];
    for (InvoiceModel invoice in dueToday) {
      final customer = storage.getCustomer(invoice.socid);
      list.add(
        DueTodayModel(
          invoiceId: invoice.id,
          customerId: invoice.socid,
          name: customer?.name ?? 'Name not set',
          dueDate: Utils.intToDMY(invoice.dateLimReglement),
          town: customer?.town,
          address: customer?.address,
        ),
      );
    }
    list.sort((a, b) => a.town.compareTo(b.town));
    dueList.value = list;
  }
}

class DueTodayModel {
  final String invoiceId;
  final String customerId;
  final String name;
  final String dueDate;
  final String town;
  final String address;

  DueTodayModel({
    required this.invoiceId,
    required this.customerId,
    required this.name,
    required this.dueDate,
    this.town = '',
    this.address = '',
  });
}
