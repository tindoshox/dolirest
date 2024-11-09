import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/network_controller.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/invoice_repository.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:get/get.dart';

class CashflowController extends GetxController {
  var connected = Get.find<NetworkController>().connected.value;
  final StorageService storage = Get.find();
  final InvoiceRepository repository = Get.find();

  refreshPayments() async {
    var invoices = storage.getInvoiceList();
    for (InvoiceModel invoice in invoices) {
      final result = await repository.fetchPaymentsByInvoice(invoice.id!);
      result.fold(
          (failure) => SnackBarHelper.errorSnackbar(message: failure.message),
          (payments) {
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
          storage.storePayment(payment.ref, p);
        }
      });
    }
  }
}