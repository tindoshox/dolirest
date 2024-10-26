import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/network_controller.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/remote_services.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage.dart';
import 'package:get/get.dart';

class CashflowController extends GetxController {
  var connected = Get.find<NetworkController>().connected.value;
  final StorageController storageController = Get.find();

  refreshPayments() async {
    var invoices = storageController.getInvoiceList();
    for (InvoiceModel invoice in invoices) {
      await RemoteServices.fetchPaymentsByInvoice(invoice.id).then((value) {
        final List<PaymentModel> payments = value.data;
        if (value.data != null) {
          for (var payment in payments) {
            PaymentModel p = PaymentModel(
              amount: payment.amount,
              type: payment.type,
              date: payment.date,
              num: payment.num,
              fkBankLine: payment.fkBankLine,
              ref: payment.ref,
              invoiceId: invoice.id,
              refExt: payment.refExt,
            );
            storageController.storePayment(payment.ref, p);
          }
        }
      });
    }
  }
}
