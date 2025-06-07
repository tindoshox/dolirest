import 'dart:convert';

import 'package:dolirest/infrastructure/dal/models/credit_available_model.dart';
import 'package:dolirest/infrastructure/dal/models/discount_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice/invoice_entity.dart';
import 'package:dolirest/infrastructure/dal/models/invoice/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment/payment_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/dio_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/dio_safe_request.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/dolibarr_api_error.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/api_path.dart';
import 'package:fpdart/fpdart.dart';

class InvoiceRepository extends DioService {
  Future<Either<DolibarrApiError, List<InvoiceEntity>>> fetchInvoiceList({
    String? customerId,
    String? dateModified,
    String? status,
    String? type,
  }) {
    final properties =
        "id,ref,status,total_ht,total_tva,total_ttc,lines,name,date_modification,totalpaid,type,socid,paye,date,dateLimReglement,totaldeposits,totalcreditnotes,sumpayed,sumdeposit,sumcreditnote,remaintopay,datem,ref_customer,fk_facture_source,mode_reglement_code,cond_reglement_code,date_lim_reglement";

    return dio.safeRequest(() async {
      var invoices = <InvoiceEntity>[];
      int page = 0;
      const int limit = 1000;
      bool hasNextPage = true;

      while (hasNextPage) {
        var queryParameters = {
          "sortfield": "t.rowid",
          "sortorder": "ASC",
          "page": page,
          "limit": limit,
          "properties": properties,
          if (status != null) "status": status,
          if (type != null) "type": type,
          if (customerId != null) "thirdparty_ids": customerId,
          if (dateModified != null) "t.tms": dateModified,
        };
        final response =
            await dio.get(ApiPath.invoices, queryParameters: queryParameters);
        //  debugPrint(response.data.toString());
        final list = parseInvoiceListFromJson(response.data);
        if (list.length < limit) {
          hasNextPage = false;
        } else {
          page++;
        }

        if (list.isNotEmpty) {
          invoices.addAll(list);
        }
      }
      return invoices;
    });
  }

  Future<Either<DolibarrApiError, InvoiceEntity>> fetchInvoiceById(
      String documentId) {
    return dio.safeRequest(() async {
      final response = await dio.get('${ApiPath.invoices}/$documentId');
      return parseInvoiceFromJson(response.data);
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

  Future<Either<DolibarrApiError, int>> createInvoice({required String body}) {
    return dio.safeRequest(() async {
      final res = await dio.post(ApiPath.invoices, data: body);
      return int.parse(res.data.toString().replaceAll('"', ''));
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
