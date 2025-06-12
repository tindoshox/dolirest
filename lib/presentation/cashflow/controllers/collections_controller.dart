import 'package:dolirest/infrastructure/dal/models/invoice/invoice_entity.dart';
import 'package:dolirest/infrastructure/dal/models/payment/payment_entity.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/data_refresh_service.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/network_service.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/invoice_repository.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/utils.dart' show Utils;
import 'package:get/get.dart';

class CashflowController extends GetxController {
  var connected = Get.find<NetworkService>().connected.value;
  final StorageService storage = Get.find();
  final InvoiceRepository repository = Get.find();
  var dayCashflow = <PaymentEntity>[].obs;
  final DataRefreshService data = Get.find();

  @override
  void onInit() {
    _updatePayments();
    super.onInit();
  }

  refreshPayments() async {
    var invoices = data.invoices;
    for (InvoiceEntity invoice in invoices) {
      final result = await repository.fetchPaymentsByInvoice(
          invoiceId: invoice.documentId);
      result.fold(
          (failure) => SnackBarHelper.errorSnackbar(message: failure.message),
          (payments) {
        for (var payment in payments) {
          storage.paymentBox.put(payment);
        }
      });
    }
  }

  void _updatePayments() {
    final list = storage.paymentBox.getAll();
    //Day Cashflow
    dayCashflow.value = list
        .where((f) => Utils.datePaid(f.date) == Utils.datePaid(DateTime.now()))
        .cast<PaymentEntity>()
        .toList();
  }
}
