//Dolibarr api

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dolirest/infrastructure/dal/models/third_party_model.dart';
import 'package:dolirest/infrastructure/dal/services/get_storage.dart';

import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:dolirest/infrastructure/dal/models/build_document_response_model.dart';
import 'package:dolirest/infrastructure/dal/models/build_report_response_model.dart';
import 'package:dolirest/infrastructure/dal/models/data_or_exception.dart';
import 'package:dolirest/infrastructure/dal/models/group_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/models/product_model.dart';
import 'package:dolirest/infrastructure/dal/models/user_model.dart';
import 'package:dolirest/infrastructure/dal/services/api_routes.dart';

class RemoteServices {
  static final _client = RetryClient(http.Client());
  static const _timeout = Duration(seconds: 60);
  static final _url = getBox.read('url');
  static final _apikey = getBox.read('apikey');
  static final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'DOLAPIKEY': _apikey
  };

  /// CustomerList
  static Future<DataOrException> fetchThirdPartyList() async {
    final queryParameters = {
      "sortfield": "t.nom",
      "sortorder": "ASC",
      "mode": "1",
      "limit": "0",
      "page": "1",
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

      List<ThirdPartyModel> customers = jsonList
          .map((jsonItem) =>
              ThirdPartyModel.fromJson(jsonItem as Map<String, dynamic>))
          .toList();

      return DataOrException(
        data: customers,
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          data: [],
          errorMessage: "No Internet",
        );
      } else if (e is TimeoutException) {
        return DataOrException(
          hasError: true,
          data: [],
          errorMessage: "Timeout error",
        );
      } else {
        return DataOrException(
          hasError: true,
          data: [],
          errorMessage: "Unkown error",
        );
      }
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

      return DataOrException(
        data: thirdPartyModelFromJson(response.body),
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "No Internet",
        );
      } else if (e is TimeoutException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Timeout error",
        );
      } else {
        return DataOrException(
          hasError: true,
          errorMessage: "Unkown error",
        );
      }
    }
  }

  /// invoiceList
  static Future<DataOrException> fetchInvoiceList(
      {String customerId = ""}) async {
    final queryParameters = {
      "sortfield": "t.date_lim_reglement",
      "sortorder": "ASC",
      "page": "1",
      "limit": "0",
      "thirdparty_ids": customerId,
      "sqlfilters": "(t.type:=:0)"
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

      List<InvoiceModel> invoices = jsonList
          .map((jsonItem) =>
              InvoiceModel.fromJson(jsonItem as Map<String, dynamic>))
          .toList();

      return DataOrException(
        data: invoices,
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "No Internet",
          data: [],
        );
      } else if (e is TimeoutException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Timeout error",
          data: [],
        );
      } else {
        return DataOrException(
          hasError: true,
          errorMessage: "Unkown error",
          data: [],
        );
      }
    }
  }

  /// Customer Payment List
  static Future<DataOrException> fetchPaymentsByInvoice(
      String invoiceId) async {
    try {
      var response = await _client
          .get(
            Uri.https(_url, '${ApiRoutes.invoices}/$invoiceId/payments'),
            headers: _headers,
          )
          .timeout(_timeout);
      return DataOrException(
        data: paymentModelFromJson(response.body),
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "No Internet",
        );
      } else if (e is TimeoutException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Timeout error",
        );
      } else {
        return DataOrException(
          hasError: true,
          errorMessage: "Unkown error",
        );
      }
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

      return DataOrException(
        data: invoiceModelFromJson(response.body),
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "No Internet",
        );
      } else if (e is TimeoutException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Timeout error",
        );
      } else {
        return DataOrException(
          hasError: true,
          errorMessage: "Unkown error",
        );
      }
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
        //data: invoiceModelFromJson(response.body),
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "No Internet",
        );
      } else if (e is TimeoutException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Timeout error",
        );
      } else {
        return DataOrException(
          hasError: true,
          errorMessage: "Unkown error",
        );
      }
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
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "No Internet",
        );
      } else if (e is TimeoutException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Timeout error",
        );
      } else {
        return DataOrException(
          hasError: true,
          errorMessage: "Unkown error",
        );
      }
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
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "No Internet",
        );
      } else if (e is TimeoutException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Timeout error",
        );
      } else {
        return DataOrException(
          hasError: true,
          errorMessage: "Unkown error",
        );
      }
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

      List<GroupModel> groups = jsonList
          .map((jsonItem) =>
              GroupModel.fromJson(jsonItem as Map<String, dynamic>))
          .toList();
      return DataOrException(
        data: groups,
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "No Internet",
        );
      } else if (e is TimeoutException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Timeout error",
        );
      } else {
        return DataOrException(
          hasError: true,
          errorMessage: "Unkown error",
        );
      }
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
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "No Internet",
        );
      } else if (e is TimeoutException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Timeout error",
        );
      } else {
        return DataOrException(
          hasError: true,
          errorMessage: "Unkown error",
        );
      }
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
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "No Internet",
        );
      } else if (e is TimeoutException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Timeout error",
        );
      } else {
        return DataOrException(
          hasError: true,
          errorMessage: "Unkown error",
        );
      }
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

      List<ProductModel> products = jsonList
          .map((jsonItem) =>
              ProductModel.fromJson(jsonItem as Map<String, dynamic>))
          .toList();

      return DataOrException(
        data: products,
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "No Internet",
        );
      } else if (e is TimeoutException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Timeout error",
        );
      } else {
        return DataOrException(
          hasError: true,
          errorMessage: "Unkown error",
        );
      }
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
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "No Internet",
        );
      } else if (e is TimeoutException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Timeout error",
        );
      } else {
        return DataOrException(
          hasError: true,
          errorMessage: "Unkown error",
        );
      }
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
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "No Internet",
        );
      } else if (e is TimeoutException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Timeout error",
        );
      } else {
        return DataOrException(
          hasError: true,
          errorMessage: "Unkown error",
        );
      }
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

      return DataOrException(
        data: response.body.replaceAll('"', ''),
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "No Internet",
        );
      } else if (e is TimeoutException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Timeout error",
        );
      } else {
        return DataOrException(
          hasError: true,
          errorMessage: "Unkown error",
        );
      }
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
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "No Internet",
        );
      } else if (e is TimeoutException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Timeout error",
        );
      } else {
        return DataOrException(
          hasError: true,
          errorMessage: "Unkown error",
        );
      }
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
          .timeout(_timeout);

      return DataOrException(
        data: buildReportResponseModelFromJson(response.body),
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "No Internet",
        );
      } else if (e is TimeoutException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Timeout error",
        );
      } else {
        return DataOrException(
          hasError: true,
          errorMessage: "Unkown error",
        );
      }
    }
  }
}
