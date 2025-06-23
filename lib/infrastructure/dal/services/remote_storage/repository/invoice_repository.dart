import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dolirest/infrastructure/dal/models/credit_available_model.dart';
import 'package:dolirest/infrastructure/dal/models/discount_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice/invoice_entity.dart';
import 'package:dolirest/infrastructure/dal/models/payment/payment_entity.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/dio_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/dio_safe_request.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/dolibarr_api_error.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/api_path.dart';
import 'package:fpdart/fpdart.dart';

class InvoiceRepository extends DioService {
  Future<Either<DolibarrApiError, List<InvoiceEntity>>> fetchInvoiceList({
    String? customerId,
    String? status,
    String? type,
    required int page,
    required int limit,
    CancelToken? cancelToken,
  }) {
    final properties =
        "id,ref,status,total_ht,total_tva,total_ttc,lines,name,date_modification,totalpaid,type,socid,paye,date,dateLimReglement,totaldeposits,totalcreditnotes,sumpayed,sumdeposit,sumcreditnote,remaintopay,datem,ref_customer,fk_facture_source,mode_reglement_code,cond_reglement_code,date_lim_reglement";

    return dio.safeRequest(
      (token) async {
        var queryParameters = {
          "sortfield": "t.rowid",
          "sortorder": "ASC",
          "page": page,
          "limit": limit,
          "properties": properties,
          if (status != null) "status": status,
          if (type != null) "type": type,
          if (customerId != null) "thirdparty_ids": customerId,
        };

        final response = await dio.get(ApiPath.invoices,
            queryParameters: queryParameters, cancelToken: cancelToken);

        return parseInvoiceListFromJson(response.data);
      },
      token: cancelToken,
    );
  }

  Future<Either<DolibarrApiError, InvoiceEntity>> fetchInvoiceById(
      String documentId) {
    return dio.safeRequest((token) async {
      final response = await dio.get('${ApiPath.invoices}/$documentId');
      return parseInvoiceFromJson(response.data);
    });
  }

  Future<Either<DolibarrApiError, List<PaymentEntity>>> fetchPaymentsByInvoice({
    required String invoiceId,
  }) {
    return dio.safeRequest((token) async {
      final res = await dio.get('${ApiPath.invoices}/$invoiceId/payments');
      return parsePaymentsFromJson(res.data, invoiceId);
    });
  }

  Future<Either<DolibarrApiError, InvoiceEntity>> updateInvoice({
    required String invoiceId,
    required String body,
  }) {
    return dio.safeRequest((token) async {
      final res = await dio.put('${ApiPath.invoices}/$invoiceId', data: body);
      return parseInvoiceFromJson(res.data);
    });
  }

  Future<Either<DolibarrApiError, String>> createInvoice(
      {required String body}) {
    return dio.safeRequest((token) async {
      final res = await dio.post(ApiPath.invoices, data: body);
      return (res.data.toString().replaceAll('"', ''));
    });
  }

  Future<Either<DolibarrApiError, String>> validateInvoice({
    required String body,
    required String docId,
  }) {
    return dio.safeRequest((token) async {
      final res =
          await dio.post('${ApiPath.invoices}/$docId/validate', data: body);
      return res.data['id'];
    });
  }

  Future<Either<DolibarrApiError, String>> deleteInvoice({
    required String documentId,
  }) {
    return dio.safeRequest((token) async {
      final res = await dio.delete('${ApiPath.invoices}/$documentId');
      return res.data.toString().replaceAll('"', '');
    });
  }

  Future<Either<DolibarrApiError, CreditAvailableModel>> markAsCreditAvailable({
    required String creditNoteId,
  }) {
    return dio.safeRequest((token) async {
      final res =
          await dio.post('${ApiPath.invoices}/$creditNoteId/${ApiPath.credit}');
      return creditAvailableModelFromJson(jsonEncode(res.data));
    });
  }

  Future<Either<DolibarrApiError, String>> addPayment({required String body}) {
    return dio.safeRequest((token) async {
      final res =
          await dio.post('${ApiPath.invoices}/paymentsdistributed', data: body);
      return res.data.toString().replaceAll('"', '');
    });
  }

  Future<Either<DolibarrApiError, String>> fetchDiscount({
    required String creditNoteId,
  }) {
    return dio.safeRequest((token) async {
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
    return dio.safeRequest((token) async {
      await dio.post(
        '${ApiPath.invoices}/$invoiceId/${ApiPath.usecreditnote}/$discountId',
      );
      return invoiceId;
    });
  }

  Future<Either<DolibarrApiError, int>> classifyPaid(
      {required String invoiceId}) {
    return dio.safeRequest((token) async {
      final res =
          await dio.post('${ApiPath.invoices}/$invoiceId/${ApiPath.settopaid}');
      return res.statusCode!;
    });
  }

  Future<Either<DolibarrApiError, String>> addProduct({
    required String invoiceId,
    required String body,
  }) {
    return dio.safeRequest((token) async {
      final res = await dio.post(
        '${ApiPath.invoices}/$invoiceId/${ApiPath.lines}',
        data: body,
      );
      return res.data.toString();
    });
  }
}
