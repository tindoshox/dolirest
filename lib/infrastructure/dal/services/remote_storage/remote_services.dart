//Dolibarr api

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dolirest/infrastructure/dal/models/build_document_response_model.dart';
import 'package:dolirest/infrastructure/dal/models/build_report_response_model.dart';
import 'package:dolirest/infrastructure/dal/models/company_model.dart';
import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/models/data_or_exception.dart';
import 'package:dolirest/infrastructure/dal/models/group_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/models/product_model.dart';
import 'package:dolirest/infrastructure/dal/models/user_model.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_key.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/api_routes.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

class RemoteServices {
  static final RetryClient _client = RetryClient(http.Client());
  static const Duration _timeout = Duration(seconds: 10);
  static final String _url =
      Get.find<StorageController>().getSetting(StorageKey.url);
  static final String _apikey =
      Get.find<StorageController>().getSetting(StorageKey.apiKey);
  static final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'DOLAPIKEY': _apikey
  };

  static DataOrException _error(Exception e, int statusCode) {
    switch (e) {
      case TimeoutException():
        return DataOrException(
            hasError: true,
            errorMessage: "Timeout error",
            statusCode: statusCode);
      case SocketException():
        return DataOrException(
          hasError: true,
          errorMessage: "Unable to connect to server",
        );
      case HttpException():
        return DataOrException(
          hasError: true,
          errorMessage: e.message,
        );
      default:
        return DataOrException(
          hasError: true,
          errorMessage: 'Uknown Error',
        );
    }
  }

  static Failure _failure(Exception e) {
    switch (e) {
      case TimeoutException():
        return Failure("Timeout error");
      case SocketException():
        return Failure("Unable to connect to server");
      case HttpException():
        return Failure(e.message);
      default:
        return Failure('Uknown Error');
    }
  }

  /// CustomerList
  static Future<Either<Failure, List<CustomerModel>>> fetchThirdPartyList(
      {String dateModified = '1970-01-01'}) async {
    final Map<String, String> queryParameters = {
      "sortfield": "t.nom",
      "sortorder": "ASC",
      "mode": "1",
      "limit": "0",
      "page": "1",
      "sqlfilters": "(t.tms:>:'$dateModified')",
    };
    try {
      var response = await _client
          .get(
            Uri.https(_url, ApiRoutes.customers, queryParameters),
            headers: _headers,
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        String jsonString = response.body;

        List<dynamic> jsonList = json.decode(jsonString);
        List<CustomerModel> customers = List.empty();
        if (jsonList.isNotEmpty) {
          customers = jsonList
              .map((jsonItem) =>
                  CustomerModel.fromJson(jsonItem as Map<String, dynamic>))
              .toList();
        }
        return right(customers);
      } else {
        return left(Failure(response.reasonPhrase!));
      }
    } on Exception catch (e) {
      return left(_failure(e));
    }
  }

  /// Customer By Id
  static Future<Either<Failure, CustomerModel>> fetchThirdPartyById(
      String customerId) async {
    try {
      var response = await _client
          .get(
            Uri.https(_url, '${ApiRoutes.customers}/$customerId'),
            headers: _headers,
          )
          .timeout(_timeout);
      if (response.statusCode == 200) {
        return right(customerModelFromJson(response.body));
      } else {
        return left(Failure(response.reasonPhrase!));
      }
    } on Exception catch (e) {
      return left(Failure(e.toString()));
    }
  }

  /// invoiceList
  static Future<Either<Failure, List<InvoiceModel>>> fetchInvoiceList({
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
      var response = await _client
          .get(
            Uri.https(_url, ApiRoutes.invoices, queryParameters),
            headers: _headers,
          )
          .timeout(_timeout);
      List<InvoiceModel> invoices = List.empty();
      if (response.statusCode == 200) {
        String jsonString = response.body;
        List<dynamic> jsonList = json.decode(jsonString);

        if (jsonList.isNotEmpty) {
          invoices = jsonList
              .map((jsonItem) =>
                  InvoiceModel.fromJson(jsonItem as Map<String, dynamic>))
              .toList();
        }
        return right(invoices);
      } else {
        return left(Failure(response.reasonPhrase!));
      }
    } on Exception catch (e) {
      return left(_failure(e));
    }
  }

  /// Invoice Payment List
  static Future<Either<Failure, List<PaymentModel>>> fetchPaymentsByInvoice(
      String invoiceId) async {
    try {
      var response = await _client
          .get(
            Uri.https(_url, '${ApiRoutes.invoices}/$invoiceId/payments'),
            headers: _headers,
          )
          .timeout(_timeout);
      if (response.statusCode == 200) {
        return right(paymentModelFromJson(response.body));
      } else {
        return left(Failure(response.reasonPhrase!));
      }
    } on Exception catch (e) {
      return left(_failure(e));
    }
  }

  /// Update Invoice
  static Future<Either<Failure, InvoiceModel>> updateInvoice(
      String invoiceId, String body) async {
    try {
      var response = await _client
          .put(
            Uri.https(_url, '${ApiRoutes.invoices}/$invoiceId'),
            body: body,
            headers: _headers,
          )
          .timeout(_timeout);
      if (response.statusCode == 200) {
        return right(invoiceModelFromJson(response.body));
      } else {
        return left(Failure(response.reasonPhrase!));
      }
    } on Exception catch (e) {
      return left(_failure(e));
    }
  }

  /// Create Customer
  static Future<Either<Failure, String>> createCustomer(String body) async {
    try {
      var response = await _client
          .post(
            Uri.https(_url, ApiRoutes.customers),
            body: body,
            headers: _headers,
          )
          .timeout(_timeout);
      if (response.statusCode == 200) {
        return right(response.body.replaceAll('"', ''));
      } else {
        return left(Failure(response.reasonPhrase!));
      }
    } on Exception catch (e) {
      return left(_failure(e));
    }
  }

  /// Update Customer
  static Future<Either<Failure, CustomerModel>> updateCustomer(
      String body, String customerId) async {
    try {
      var response = await _client
          .put(
            Uri.https(_url, '${ApiRoutes.customers}/$customerId'),
            body: body,
            headers: _headers,
          )
          .timeout(_timeout);
      if (response.statusCode == 200) {
        return right(customerModelFromJson(response.body));
      } else {
        return left(Failure(response.reasonPhrase!));
      }
    } on Exception catch (e) {
      return left(_failure(e));
    }
  }

  /// Fetch Groups
  static Future<Either<Failure, List<GroupModel>>> fetchGroups() async {
    final queryParameters = {
      "sortfield": "nom",
      "sortorder": "ASC",
      "sqlfilters": "(t.active:=:1)",
    };
    try {
      var response = await _client
          .get(
            Uri.https(_url, ApiRoutes.groups, queryParameters),
            headers: _headers,
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        String jsonString = response.body;
        List<dynamic> jsonList = json.decode(jsonString);
        List<GroupModel> groups = List.empty();
        if (jsonList.isNotEmpty) {
          groups = jsonList
              .map((jsonItem) =>
                  GroupModel.fromJson(jsonItem as Map<String, dynamic>))
              .toList();
        }

        return right(groups);
      } else {
        return left(Failure(response.reasonPhrase!));
      }
    } on Exception catch (e) {
      return left(_failure(e));
    }
  }

  /// Fetch User Info
  static Future<Either<Failure, UserModel>> login() async {
    try {
      var response = await _client
          .get(
            Uri.https(_url, ApiRoutes.users),
            headers: _headers,
          )
          .timeout(_timeout);
      if (response.statusCode == 200) {
        return right(
          userModelFromJson(response.body),
        );
      } else {
        log('Login Status code: ${response.statusCode}');
        return left(Failure(response.reasonPhrase!));
      }
    } on Exception catch (e) {
      return left(_failure(e));
    }
  }

  /// Add Customer payment

  static Future<Either<Failure, String>> addpayment(String body) async {
    var serverURL = _url;
    try {
      var response = await _client
          .post(
            Uri.https(serverURL, '${ApiRoutes.invoices}/paymentsdistributed'),
            body: body,
            headers: _headers,
          )
          .timeout(_timeout);
      if (response.statusCode == 200) {
        return right(response.body.replaceAll('"', ''));
      } else {
        return left(Failure(response.reasonPhrase!));
      }
    } on Exception catch (e) {
      return left(_failure(e));
    }
  }

  /// Fetch Products
  static Future<Either<Failure, List<ProductModel>>> fetchProducts() async {
    final queryParameters = {
      "sortfield": "label",
      "sortorder": "ASC",
    };
    try {
      var response = await _client
          .get(
            Uri.https(_url, ApiRoutes.products, queryParameters),
            headers: _headers,
          )
          .timeout(_timeout);
      if (response.statusCode == 200) {
        String jsonString = response.body;

        List<dynamic> jsonList = json.decode(jsonString);
        List<ProductModel> products = List.empty();
        if (jsonList.isNotEmpty) {
          products = jsonList
              .map((jsonItem) =>
                  ProductModel.fromJson(jsonItem as Map<String, dynamic>))
              .toList();
        }
        return right(products);
      } else {
        return left(Failure(response.reasonPhrase!));
      }
    } on Exception catch (e) {
      return left(_failure(e));
    }
  }

  /// Check stock Products
  static Future<DataOrException> checkStock(String productId) async {
    try {
      var response = await _client
          .get(
            Uri.https(_url, '${ApiRoutes.products}/$productId/stock'),
            headers: _headers,
          )
          .timeout(_timeout);

      return DataOrException(
        data: response.statusCode,
        statusCode: response.statusCode,
      );
    } on Exception catch (e) {
      return _error(e, 700);
    }
  }

  /// Create Invoice
  static Future<Either<Failure, String>> createInvoice(String body) async {
    try {
      var response = await _client
          .post(
            Uri.https(_url, ApiRoutes.invoices),
            body: body,
            headers: _headers,
          )
          .timeout(_timeout);
      if (response.statusCode == 200) {
        return right(response.body.replaceAll('"', ''));
      } else {
        return left(Failure(response.reasonPhrase!));
      }
    } on Exception catch (e) {
      return left(_failure(e));
    }
  }

  //
  //
  /// Validate Invoice
  static Future<Either<Failure, String>> validateInvoice(
      String body, String invoiceId) async {
    try {
      var response = await _client
          .post(
            Uri.https(_url, '${ApiRoutes.invoices}/$invoiceId/validate'),
            body: body,
            headers: _headers,
          )
          .timeout(_timeout);
      if (response.statusCode == 200) {
        return right(response.body.replaceAll('"', ''));
      } else {
        return left(Failure(response.reasonPhrase!));
      }
    } on Exception catch (e) {
      return left(_failure(e));
    }
  }

  static Future<Either<Failure, String>> deleteInvoice(invoiceId) async {
    try {
      var response = await _client
          .delete(
            Uri.https(_url, '${ApiRoutes.invoices}/$invoiceId'),
            headers: _headers,
          )
          .timeout(_timeout);
      if (response.statusCode == 200) {
        return right(response.body.replaceAll('"', ''));
      } else {
        return left(Failure(response.reasonPhrase!));
      }
    } on Exception catch (e) {
      return left(_failure(e));
    }
  }

//Build Document
  static Future<DataOrException> buildDocument(String body) async {
    try {
      var response = await _client
          .put(
            Uri.https(_url, ApiRoutes.buildDocument),
            body: body,
            headers: _headers,
          )
          .timeout(_timeout);

      return DataOrException(
        data: buildDucumentResponseModelFromJson(response.body),
        statusCode: response.statusCode,
      );
    } on Exception catch (e) {
      return _error(e, 700);
    }
  }

  //Build Report
  static Future<DataOrException> buildReport(String body) async {
    try {
      var response = await _client
          .put(
            Uri.https(_url, ApiRoutes.buildReport),
            body: body,
            headers: _headers,
          )
          .timeout(const Duration(seconds: 60));

      return DataOrException(
        data: buildReportResponseModelFromJson(response.body),
        statusCode: response.statusCode,
      );
    } on Exception catch (e) {
      return _error(e, 700);
    }
  }

  // Actual HTTP request to check server reachability
  static Future<bool> checkServerReachability() async {
    try {
      final response = await _client
          .get(
            Uri.https(_url, ApiRoutes.status),
            headers: _headers,
          )
          .timeout(_timeout);

      return response.statusCode == 200 || response.statusCode == 401;
    } catch (e) {
      return false;
    }
  }

  static Future<Either<Failure, CompanyModel>> fetchCompany() async {
    try {
      final response = await _client
          .get(Uri.https(_url, ApiRoutes.company), headers: _headers)
          .timeout(_timeout);
      if (response.statusCode == 200) {
        return right(companyModelFromJson(response.body));
      } else {
        return left(Failure(response.reasonPhrase!));
      }
    } on Exception catch (e) {
      return left(_failure(e));
    }
  }
}
