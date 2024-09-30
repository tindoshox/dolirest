//Dolibarr api

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dolirest/infrastructure/dal/models/build_document_response_model.dart';
import 'package:dolirest/infrastructure/dal/models/build_report_response_model.dart';
import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/models/data_or_exception.dart';
import 'package:dolirest/infrastructure/dal/models/group_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/models/product_model.dart';
import 'package:dolirest/infrastructure/dal/models/user_model.dart';
import 'package:dolirest/infrastructure/dal/services/api_routes.dart';
import 'package:dolirest/infrastructure/dal/services/storage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

class RemoteServices {
  static final RetryClient _client = RetryClient(http.Client());
  static const Duration _timeout = Duration(seconds: 60);
  static final String _url = Storage.settings.get('url');
  static final String _apikey = Storage.settings.get('apikey');
  static final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'DOLAPIKEY': _apikey
  };

  static DataOrException _error(Exception e) {
    if (e is SocketException) {
      return DataOrException(
        hasError: true,
        errorMessage: "Unable to connect to server",
      );
    } else if (e is TimeoutException) {
      return DataOrException(
        hasError: true,
        errorMessage: "Timeout error",
      );
    } else {
      return DataOrException(
        hasError: true,
        errorMessage: "Unknown error",
      );
    }
  }

  /// CustomerList
  static Future<DataOrException> fetchThirdPartyList(
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

      String jsonString = response.body;

      List<dynamic> jsonList = json.decode(jsonString);
      List<CustomerModel> customers = List.empty();
      if (jsonList.isNotEmpty) {
        customers = jsonList
            .map((jsonItem) =>
                CustomerModel.fromJson(jsonItem as Map<String, dynamic>))
            .toList();
        for (CustomerModel customer in customers) {
          Storage.customers.put(customer.id, customer);
        }
      }
      return DataOrException();
    } on Exception catch (e) {
      return _error(e);
    }
  }

  /// Customer By Id
  static Future<DataOrException> fetchThirdPartyById(String customerId) async {
    try {
      var response = await _client
          .get(
            Uri.https(_url, '${ApiRoutes.customers}/$customerId'),
            headers: _headers,
          )
          .timeout(_timeout);

      Storage.customers.put(customerId, thirdPartyModelFromJson(response.body));

      return DataOrException();
    } on Exception catch (e) {
      return _error(e);
    }
  }

  /// invoiceList
  static Future<DataOrException> fetchInvoiceList({
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
      String jsonString = response.body;
      List<dynamic> jsonList = json.decode(jsonString);

      List<InvoiceModel> invoices = List.empty();
      if (jsonList.isNotEmpty) {
        invoices = jsonList
            .map((jsonItem) =>
                InvoiceModel.fromJson(jsonItem as Map<String, dynamic>))
            .toList();
        for (InvoiceModel invoice in invoices) {
          Storage.invoices.put(invoice.id, invoice);
        }
      }

      return DataOrException();
    } on Exception catch (e) {
      return _error(e);
    }
  }

  /// Invoice Payment List
  static Future<DataOrException> fetchPaymentsByInvoice(
      String invoiceId) async {
    try {
      var response = await _client
          .get(
            Uri.https(_url, '${ApiRoutes.invoices}/$invoiceId/payments'),
            headers: _headers,
          )
          .timeout(_timeout);
      if (response.statusCode == 200) {
        var payments = paymentModelFromJson(response.body);
        List<PaymentModel> pl = [];
        for (var payment in payments) {
          PaymentModel p = PaymentModel(
            amount: payment.amount,
            type: payment.type,
            date: payment.date,
            num: payment.num,
            fkBankLine: payment.fkBankLine,
            ref: payment.ref,
            invoiceId: invoiceId,
            refExt: payment.refExt,
          );

          pl.add(p);
        }
        Storage.payments.put(invoiceId, pl);
      }
      return DataOrException();
    } on Exception catch (e) {
      return _error(e);
    }
  }

  /// Invoice by ID
  static Future<DataOrException> fetchInvoiceById(String invoiceId) async {
    try {
      var response = await _client
          .get(
            Uri.https(_url, '${ApiRoutes.invoices}/$invoiceId'),
            headers: _headers,
          )
          .timeout(_timeout);
      Storage.invoices.put(invoiceId, invoiceModelFromJson(response.body));
      return DataOrException();
    } on Exception catch (e) {
      return _error(e);
    }
  }

  /// Update Invoice
  static Future<DataOrException> updateInvoice(
      String invoiceId, String body) async {
    try {
      var response = await _client
          .put(
            Uri.https(_url, '${ApiRoutes.invoices}/$invoiceId'),
            body: body,
            headers: _headers,
          )
          .timeout(_timeout);

      return DataOrException(
        data: invoiceModelFromJson(response.body),
        statusCode: response.statusCode,
      );
    } on Exception catch (e) {
      return _error(e);
    }
  }

  /// Create Customer
  static Future<DataOrException> createCustomer(String body) async {
    try {
      var response = await _client
          .post(
            Uri.https(_url, ApiRoutes.customers),
            body: body,
            headers: _headers,
          )
          .timeout(_timeout);

      return DataOrException(
        data: response.body.replaceAll('"', ''),
        statusCode: response.statusCode,
      );
    } on Exception catch (e) {
      return _error(e);
    }
  }

  /// Update Customer
  static Future<DataOrException> updateCustomer(
      String body, String customerId) async {
    try {
      var response = await _client
          .put(
            Uri.https(_url, '${ApiRoutes.customers}/$customerId'),
            body: body,
            headers: _headers,
          )
          .timeout(_timeout);

      return DataOrException(
        data: thirdPartyModelFromJson(response.body),
        statusCode: response.statusCode,
      );
    } on Exception catch (e) {
      return _error(e);
    }
  }

  /// Fetch Groups
  static Future<DataOrException> fetchGroups() async {
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
      String jsonString = response.body;

      List<dynamic> jsonList = json.decode(jsonString);
      List<GroupModel> groups = List.empty();
      if (jsonList.isNotEmpty) {
        groups = jsonList
            .map((jsonItem) =>
                GroupModel.fromJson(jsonItem as Map<String, dynamic>))
            .toList();
        for (GroupModel group in groups) {
          Storage.groups.put(group.id, group);
        }
      }

      return DataOrException();
    } on Exception catch (e) {
      return _error(e);
    }
  }

  /// Fetch User Info
  static Future<DataOrException> fetchUserInfo() async {
    try {
      var response = await _client
          .get(
            Uri.https(_url, ApiRoutes.users),
            headers: _headers,
          )
          .timeout(_timeout);

      return DataOrException(
        data: userModelFromJson(response.body),
        statusCode: response.statusCode,
      );
    } on Exception catch (e) {
      return _error(e);
    }
  }

  /// Add Customer payment

  static Future<DataOrException> addpayment(String body) async {
    var serverURL = _url;
    try {
      var response = await _client
          .post(
            Uri.https(serverURL, '${ApiRoutes.invoices}/paymentsdistributed'),
            body: body,
            headers: _headers,
          )
          .timeout(_timeout);

      return DataOrException(
        data: response.body.replaceAll('"', ''),
        statusCode: response.statusCode,
      );
    } on Exception catch (e) {
      return _error(e);
    }
  }

  /// Fetch Products
  static Future<DataOrException> fetchProducts() async {
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
      String jsonString = response.body;

      List<dynamic> jsonList = json.decode(jsonString);
      List<ProductModel> products = List.empty();
      if (jsonList.isNotEmpty) {
        products = jsonList
            .map((jsonItem) =>
                ProductModel.fromJson(jsonItem as Map<String, dynamic>))
            .toList();
        for (ProductModel product in products) {
          Storage.products.put(product.id, product);
        }
      }
      return DataOrException(
        statusCode: response.statusCode,
      );
    } on Exception catch (e) {
      return _error(e);
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
      return _error(e);
    }
  }

  /// Create Invoice
  static Future<DataOrException> createInvoice(String body) async {
    try {
      var response = await _client
          .post(
            Uri.https(_url, ApiRoutes.invoices),
            body: body,
            headers: _headers,
          )
          .timeout(_timeout);
      return DataOrException(
        data: response.body.replaceAll('"', ''),
        statusCode: response.statusCode,
      );
    } on Exception catch (e) {
      return _error(e);
    }
  }

  //
  //
  /// Validate Invoice
  static Future<DataOrException> validateInvoice(
      String body, String invoiceId) async {
    try {
      var response = await _client
          .post(
            Uri.https(_url, '${ApiRoutes.invoices}/$invoiceId/validate'),
            body: body,
            headers: _headers,
          )
          .timeout(_timeout);
      debugPrint(response.body);
      return DataOrException(
        data: response.body.replaceAll('"', ''),
        statusCode: response.statusCode,
      );
    } on Exception catch (e) {
      return _error(e);
    }
  }

  static deleteInvoice(invoiceId) async {
    try {
      var response = await _client
          .delete(
            Uri.https(_url, '${ApiRoutes.invoices}/$invoiceId'),
            headers: _headers,
          )
          .timeout(_timeout);
      debugPrint(response.body);
      return DataOrException(
        data: response.body.replaceAll('"', ''),
        statusCode: response.statusCode,
      );
    } on Exception catch (e) {
      return _error(e);
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
      return _error(e);
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
      return _error(e);
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
}
