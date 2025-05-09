import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/dio_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/error_handler.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/failure.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/api_path.dart';
import 'package:fpdart/fpdart.dart';

class InvoiceRepository extends DioService {
  /// invoiceList
  Future<Either<Failure, List<InvoiceModel>>> fetchInvoiceList({
    String? customerId,
    String dateModified = '1970-01-01',
    String? status,
  }) async {
    final Map<String, String> queryParameters = {
      "sortfield": "t.date_lim_reglement",
      "sortorder": "ASC",
      "page": "1",
      "limit": "0",
      "status": status ?? '',
      "thirdparty_ids": customerId ?? '',
      "sqlfilters": "(t.type:=:0) and (t.tms:>:'$dateModified')"
    };

    try {
      var response = await dio.get(
        ApiPath.invoices,
        queryParameters: queryParameters,
      );

      if (response.data is List) {
        List<dynamic> l = response.data;
        return right(l.map((i) => InvoiceModel.fromJson(i)).toList());
      } else {
        return left(Failure(
          response.statusCode!,
          "Unexpected response format: Expected a List but got ${response.data.runtimeType}",
        ));
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  /// Invoice Payment List
  Future<Either<Failure, List<PaymentModel>>> fetchPaymentsByInvoice(
      String invoiceId) async {
    try {
      var response = await dio.get(
        '${ApiPath.invoices}/$invoiceId/payments',
      );

      List<dynamic> l = response.data;
      return right(l.map((p) => PaymentModel.fromJson(p)).toList());
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  /// Update Invoice
  Future<Either<Failure, InvoiceModel>> updateInvoice(
      String invoiceId, String body) async {
    try {
      var response = await dio.put(
        '${ApiPath.invoices}/$invoiceId',
        data: body,
      );

      return right(InvoiceModel.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  /// Create Invoice
  Future<Either<Failure, String>> createInvoice(String body) async {
    try {
      var response = await dio.post(
        ApiPath.invoices,
        data: body,
      );

      return right(response.data.toString().replaceAll('"', ''));
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  //
  //
  /// Validate Invoice
  Future<Either<Failure, String>> validateInvoice(
      String body, String invoiceId) async {
    try {
      var response = await dio.post(
        '${ApiPath.invoices}/$invoiceId/validate',
        data: body,
      );

      return right(response.data.toString().replaceAll('"', ''));
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  Future<Either<Failure, String>> deleteInvoice(invoiceId) async {
    try {
      var response = await dio.delete(
        '${ApiPath.invoices}/$invoiceId',
      );

      return right(response.data.toString().replaceAll('"', ''));
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  /// Add Customer payment

  Future<Either<Failure, String>> addpayment(String body) async {
    try {
      var response = await dio.post(
        '${ApiPath.invoices}/paymentsdistributed',
        data: body,
      );

      return right(response.data.toString().replaceAll('"', ''));
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
