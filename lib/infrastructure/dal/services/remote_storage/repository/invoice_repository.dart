import 'dart:convert';
import 'dart:developer';

import 'package:dolirest/infrastructure/dal/models/credit_available_model.dart';
import 'package:dolirest/infrastructure/dal/models/discount_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/dio_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/error_handler.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/failure.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/api_path.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';

class InvoiceRepository extends DioService {
  /// invoiceList
  Future<Either<Failure, List<InvoiceModel>>> fetchInvoiceList({
    String? customerId,
    String? dateModified,
    String? status,
    String? type,
  }) async {
    String sqlfilters = "";

    if (dateModified != null) {
      sqlfilters += "(t.tms:>:'$dateModified')";
    } else {
      sqlfilters += "(t.tms:>:'1970-01-01')";
    }

    if (type != null) {
      sqlfilters += "and (t.type:=:'$type')";
    }

    final Map<String, String> queryParameters = {
      "sortfield": "t.date_lim_reglement",
      "sortorder": "ASC",
      "page": "1",
      "limit": "0",
      "status": status ?? '',
      "thirdparty_ids": customerId ?? '',
      "sqlfilters": sqlfilters
      // "sqlfilters": "(t.type:=:'$type') and (t.tms:>:'$dateModified')"
    };

    try {
      var response = await dio.get(
        ApiPath.invoices,
        queryParameters: queryParameters,
      );

      return right(listInvoiceModelFromJson(jsonEncode(response.data)));
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  /// Invoice Payment List
  Future<Either<Failure, List<PaymentModel>>> fetchPaymentsByInvoice(
      {required String invoiceId}) async {
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
      {required String invoiceId, required String body}) async {
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
  Future<Either<Failure, String>> createInvoice({required String body}) async {
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
      {required String body, required String docId}) async {
    try {
      var response = await dio.post(
        '${ApiPath.invoices}/$docId/validate',
        data: body,
      );

      Map<String, dynamic> s = response.data;
      String id = s['id'];
      return right(id);
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

//Delete invoice
  Future<Either<Failure, String>> deleteInvoice(
      {required String documentId}) async {
    try {
      var response = await dio.delete(
        '${ApiPath.invoices}/$documentId',
      );

      return right(response.data.toString().replaceAll('"', ''));
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  //Mark as credit available
  Future<Either<Failure, CreditAvailableModel>> markAsCreditAvailable(
      {required String creditNoteId}) async {
    try {
      var response =
          await dio.post('${ApiPath.invoices}/$creditNoteId/${ApiPath.credit}');
      final String json = jsonEncode(response.data);
      final CreditAvailableModel invoice = creditAvailableModelFromJson(json);
      return right(invoice);
    } catch (error) {
      log(error.toString());
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  /// Add Customer payment

  Future<Either<Failure, String>> addpayment({required String body}) async {
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

//Get discount
  Future<Either<Failure, String>> fetchDiscount(
      {required String creditNoteId}) async {
    try {
      var response = await dio
          .get('${ApiPath.invoices}/$creditNoteId/${ApiPath.discount}');
      final discount = discountModelFromJson(json.encode(response.data));

      return right(discount.id);
    } catch (error) {
      if (!kReleaseMode) {
        log('Error: $error');
      }
      return Left(ErrorHandler.handle(error).failure);
    }
  }

//Use Credit Note
  Future<Either<Failure, String>> useCreditNote(
      {required invoiceId, required String discountId}) async {
    try {
      var response = await dio.post(
          '${ApiPath.invoices}/$invoiceId/${ApiPath.usecreditnote}/$discountId');
      if (response.statusCode == 200) {
        return right(invoiceId);
      } else {
        return Left(Failure(response.statusCode!, response.statusMessage!));
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

//classify paid
  Future<Either<Failure, int>> classifyPaid({required String invoiceId}) async {
    try {
      var response =
          await dio.post('${ApiPath.invoices}/$invoiceId/${ApiPath.settopaid}');
      if (response.statusCode == 200) {
        return right(response.statusCode!);
      } else {
        return Left(Failure(response.statusCode!, response.statusMessage!));
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  //Add product line
  Future<Either<Failure, String>> addProduct(
      {required String invoiceId, required String body}) async {
    try {
      var response = await dio.post(
        '${ApiPath.invoices}/$invoiceId/${ApiPath.lines}',
        data: body,
      );
      if (response.statusCode == 200) {
        return right(response.data.toString());
      } else {
        return Left(Failure(response.statusCode!, response.statusMessage!));
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
