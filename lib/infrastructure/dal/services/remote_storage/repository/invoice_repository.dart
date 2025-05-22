import 'dart:convert';

import 'package:dolirest/infrastructure/dal/models/credit_available_model.dart';
import 'package:dolirest/infrastructure/dal/models/discount_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/dio_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/dio_safe_request.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/dolibarr_api_error.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/api_path.dart';
import 'package:fpdart/fpdart.dart';

class InvoiceRepository extends DioService {
  Future<Either<DolibarrApiError, List<InvoiceModel>>> fetchInvoiceList({
    String? customerId,
    String? dateModified,
    String? status,
    String? type,
  }) {
    final modified = dateModified ?? '1970-01-01';
    String sqlfilters = "(t.tms:>:'$modified')";
    if (type != null) {
      sqlfilters += "and (t.type:=:'$type')";
    }

    final queryParameters = {
      "sortfield": "t.date_lim_reglement",
      "sortorder": "ASC",
      "page": "1",
      "limit": "0",
      "status": status ?? '',
      "thirdparty_ids": customerId ?? '',
      "sqlfilters": sqlfilters,
    };

    return dio.safeRequest(() async {
      final res =
          await dio.get(ApiPath.invoices, queryParameters: queryParameters);
      return listInvoiceModelFromJson(jsonEncode(res.data));
    });
  }

  Future<Either<DolibarrApiError, List<PaymentModel>>> fetchPaymentsByInvoice({
    required String invoiceId,
  }) {
    return dio.safeRequest(() async {
      final res = await dio.get('${ApiPath.invoices}/$invoiceId/payments');
      final list = res.data as List;
      return list.map((e) => PaymentModel.fromJson(e)).toList();
    });
  }

  Future<Either<DolibarrApiError, InvoiceModel>> updateInvoice({
    required String invoiceId,
    required String body,
  }) {
    return dio.safeRequest(() async {
      final res = await dio.put('${ApiPath.invoices}/$invoiceId', data: body);
      return InvoiceModel.fromJson(res.data);
    });
  }

  Future<Either<DolibarrApiError, String>> createInvoice(
      {required String body}) {
    return dio.safeRequest(() async {
      final res = await dio.post(ApiPath.invoices, data: body);
      return res.data.toString().replaceAll('"', '');
    });
  }

  Future<Either<DolibarrApiError, String>> validateInvoice({
    required String body,
    required String docId,
  }) {
    return dio.safeRequest(() async {
      final res =
          await dio.post('${ApiPath.invoices}/$docId/validate', data: body);
      return res.data['id'];
    });
  }

  Future<Either<DolibarrApiError, String>> deleteInvoice({
    required String documentId,
  }) {
    return dio.safeRequest(() async {
      final res = await dio.delete('${ApiPath.invoices}/$documentId');
      return res.data.toString().replaceAll('"', '');
    });
  }

  Future<Either<DolibarrApiError, CreditAvailableModel>> markAsCreditAvailable({
    required String creditNoteId,
  }) {
    return dio.safeRequest(() async {
      final res =
          await dio.post('${ApiPath.invoices}/$creditNoteId/${ApiPath.credit}');
      return creditAvailableModelFromJson(jsonEncode(res.data));
    });
  }

  Future<Either<DolibarrApiError, String>> addPayment({required String body}) {
    return dio.safeRequest(() async {
      final res =
          await dio.post('${ApiPath.invoices}/paymentsdistributed', data: body);
      return res.data.toString().replaceAll('"', '');
    });
  }

  Future<Either<DolibarrApiError, String>> fetchDiscount({
    required String creditNoteId,
  }) {
    return dio.safeRequest(() async {
      final res = await dio
          .get('${ApiPath.invoices}/$creditNoteId/${ApiPath.discount}');
      final discount = discountModelFromJson(json.encode(res.data));
      return discount.id;
    });
  }

  Future<Either<DolibarrApiError, String>> useCreditNote({
    required String invoiceId,
    required String discountId,
  }) {
    return dio.safeRequest(() async {
      await dio.post(
        '${ApiPath.invoices}/$invoiceId/${ApiPath.usecreditnote}/$discountId',
      );
      return invoiceId;
    });
  }

  Future<Either<DolibarrApiError, int>> classifyPaid(
      {required String invoiceId}) {
    return dio.safeRequest(() async {
      final res =
          await dio.post('${ApiPath.invoices}/$invoiceId/${ApiPath.settopaid}');
      return res.statusCode!;
    });
  }

  Future<Either<DolibarrApiError, String>> addProduct({
    required String invoiceId,
    required String body,
  }) {
    return dio.safeRequest(() async {
      final res = await dio.post(
        '${ApiPath.invoices}/$invoiceId/${ApiPath.lines}',
        data: body,
      );
      return res.data.toString();
    });
  }
}
