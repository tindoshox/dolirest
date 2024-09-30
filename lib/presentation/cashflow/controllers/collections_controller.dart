import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/services/network_controller.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';
import 'package:dolirest/infrastructure/dal/services/storage.dart';
import 'package:get/get.dart';

class CashflowController extends GetxController {
  var connected = Get.find<NetworkController>().connected.value;

  refreshPayments() async {
    var invoices = Storage.invoices.values.toList();
    for (InvoiceModel invoice in invoices) {
      await RemoteServices.fetchPaymentsByInvoice(invoice.id);
    }
  }
}
