import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/models/third_party_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DataRefresh {
  static Future refreshCustomers() async {
    await RemoteServices.fetchThirdPartyList().then((value) async {
      if (!value.hasError) {
        var box = await Hive.openBox<ThirdPartyModel>('customers');
        for (var customer in value.data) {
          box.put(customer.id, customer);
        }
      }
    });

    return;
  }

  static Future refreshInvoices() async {
    await RemoteServices.fetchInvoiceList().then((value) async {
      if (!value.hasError) {
        var box = await Hive.openBox<InvoiceModel>('invoices');
        for (var invoice in value.data) {
          box.put(invoice.id, invoice);
        }
      }
    });
    return;
  }

  static Future refreshPayments() async {
    var invoiceBox = await Hive.openBox<InvoiceModel>('invoices');
    var paymentBox = await Hive.openBox<List<PaymentModel>>('payments');
    var invoices = invoiceBox.toMap().values.toList();
    for (InvoiceModel invoice in invoices) {
      await RemoteServices.fetchPaymentsByInvoice(invoice.id).then((value) {
        if (!value.hasError) {
          paymentBox.put(invoice.id, value.data);
        } else {
          debugPrint(value.errorMessage);
        }
      });
    }
    return;
  }
}
