import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/api_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/catch_exception.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/failure.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/api_path.dart';
import 'package:fpdart/fpdart.dart';

class InvoiceRepository extends ApiService {
  /// invoiceList
  Future<Either<Failure, List<InvoiceModel>>> fetchInvoiceList({
    String customerId = "",
    String dateModified = '1970-01-01',
    String status = "",
  }) async {
    final Map<String, String> queryParameters = {
      "sortfield": "t.date_lim_reglement",
      "sortorder": "ASC",
      "page": "1",
      "limit": "0",
      "status": status,
      "thirdparty_ids": customerId,
      "sqlfilters": "(t.type:=:0) and (t.tms:>:'$dateModified')"
    };

    try {
      var response = await httpClient.get(
        ApiPath.invoices,
        query: queryParameters,
        decoder: (data) {
          List<dynamic> l = data is List<dynamic> ? data : [];

          return l.map((i) => InvoiceModel.fromJson(i)).toList();
        },
      );

      if (response.statusCode == 200) {
        return right(response.body!);
      } else {
        return left(Failure(response.statusText!));
      }
    } on Exception catch (e) {
      return left(failure(e));
    }
  }

  /// Invoice Payment List
  Future<Either<Failure, List<PaymentModel>>> fetchPaymentsByInvoice(
      String invoiceId) async {
    try {
      var response = await httpClient
          .get('${ApiPath.invoices}/$invoiceId/payments', decoder: (data) {
        List<dynamic> l = data is List<dynamic> ? data : [];
        return l.map((p) => PaymentModel.fromJson(p)).toList();
      });
      if (response.statusCode == 200) {
        return right(response.body!);
      } else {
        return left(Failure(response.statusText!));
      }
    } on Exception catch (e) {
      return left(failure(e));
    }
  }

  /// Update Invoice
  Future<Either<Failure, InvoiceModel>> updateInvoice(
      String invoiceId, String body) async {
    try {
      var response = await httpClient.put(
        '${ApiPath.invoices}/$invoiceId',
        body: body,
        decoder: (data) => InvoiceModel.fromJson(data),
      );
      if (response.statusCode == 200) {
        return right(response.body!);
      } else {
        return left(Failure(response.statusText!));
      }
    } on Exception catch (e) {
      return left(failure(e));
    }
  }

  /// Create Invoice
  Future<Either<Failure, String>> createInvoice(String body) async {
    try {
      var response = await httpClient.post(
        ApiPath.invoices,
        body: body,
        decoder: (data) => data.toString().replaceAll('"', ''),
      );
      if (response.statusCode == 200) {
        return right(response.body!);
      } else {
        return left(Failure(response.statusText!));
      }
    } on Exception catch (e) {
      return left(failure(e));
    }
  }

  //
  //
  /// Validate Invoice
  Future<Either<Failure, String>> validateInvoice(
      String body, String invoiceId) async {
    try {
      var response = await httpClient.post(
        '${ApiPath.invoices}/$invoiceId/validate',
        body: body,
        decoder: (data) => data.toString().replaceAll('"', ''),
      );
      if (response.statusCode == 200) {
        return right(response.body!);
      } else {
        return left(Failure(response.statusText!));
      }
    } on Exception catch (e) {
      return left(failure(e));
    }
  }

  Future<Either<Failure, String>> deleteInvoice(invoiceId) async {
    try {
      var response = await httpClient.delete(
        '${ApiPath.invoices}/$invoiceId',
        decoder: (data) => data.toString().replaceAll('"', ''),
      );
      if (response.statusCode == 200) {
        return right(response.body!);
      } else {
        return left(Failure(response.statusText!));
      }
    } on Exception catch (e) {
      return left(failure(e));
    }
  }

  /// Add Customer payment

  Future<Either<Failure, String>> addpayment(String body) async {
    try {
      var response = await httpClient.post(
        '${ApiPath.invoices}/paymentsdistributed',
        body: body,
        decoder: (data) => data.toString().replaceAll('"', ''),
      );
      if (response.statusCode == 200) {
        return right(response.body!);
      } else {
        return left(Failure(response.statusText!));
      }
    } on Exception catch (e) {
      return left(failure(e));
    }
  }
}
