//Dolibarr api

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dolirest/infrastructure/dal/models/third_party_model.dart';
import 'package:dolirest/infrastructure/dal/services/storage.dart';

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
  static final RetryClient _client = RetryClient(http.Client());
  static const Duration _timeout = Duration(seconds: 60);
  static final String _url = Storage.settings.get('url');
  static final String _apikey = Storage.settings.get('apikey');
  static final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'DOLAPIKEY': _apikey
  };

  /// CustomerList
  static fetchThirdPartyList({String dateModified = '1970-01-01'}) async {
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
    } catch (e) {
      throw Exception('Failed to fetch customer data');
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
        throw const SocketException(
          "No Internet",
        );
      } else if (e is TimeoutException) {
        throw TimeoutException(
          "Timeout error",
        );
      } else {
        throw Exception(
          "Unknown error",
        );
      }
    }
  }

  /// invoiceList
  static fetchInvoiceList({
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
      } else {
        invoices = jsonList.cast();
      }

      return DataOrException(
        data: invoices,
        statusCode: response.statusCode,
      );
    } catch (e) {
      if (e is SocketException) {
        throw const SocketException(
          "No Internet",
        );
      } else if (e is TimeoutException) {
        throw TimeoutException(
          "Timeout error",
        );
      } else {
        throw Exception(
          "Unknown error",
        );
      }
    }
  }

  /// Customer Payment List
  static fetchPaymentsByInvoice(String invoiceId) async {
    try {
      var response = await _client
          .get(
            Uri.https(_url, '${ApiRoutes.invoices}/$invoiceId/payments'),
            headers: _headers,
          )
          .timeout(_timeout);
      if (response.statusCode == 200) {
        var payments = paymentModelFromJson(response.body);
        Storage.payments.put(invoiceId, payments);
      }
    } catch (e) {
      if (e is SocketException) {
        throw const SocketException(
          "No Internet",
        );
      } else if (e is TimeoutException) {
        throw TimeoutException(
          "Timeout error",
        );
      } else {
        throw Exception(
          "Unknown error",
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
        throw const SocketException(
          "No Internet",
        );
      } else if (e is TimeoutException) {
        throw TimeoutException(
          "Timeout error",
        );
      } else {
        throw Exception(
          "Unknown error",
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
        throw const SocketException(
          "No Internet",
        );
      } else if (e is TimeoutException) {
        throw TimeoutException(
          "Timeout error",
        );
      } else {
        throw Exception(
          "Unknown error",
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
        throw const SocketException(
          "No Internet",
        );
      } else if (e is TimeoutException) {
        throw TimeoutException(
          "Timeout error",
        );
      } else {
        throw Exception(
          "Unknown error",
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
        throw const SocketException(
          "No Internet",
        );
      } else if (e is TimeoutException) {
        throw TimeoutException(
          "Timeout error",
        );
      } else {
        throw Exception(
          "Unknown error",
        );
      }
    }
  }

  /// Fetch Groups
  static fetchGroups() async {
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

        List<GroupModel> groups = jsonList
            .map((jsonItem) =>
                GroupModel.fromJson(jsonItem as Map<String, dynamic>))
            .toList();
        for (GroupModel group in groups) {
          Storage.groups.put(group.id, group);
        }
      }
    } catch (e) {
      if (e is SocketException) {
        throw const SocketException(
          "No Internet",
        );
      } else if (e is TimeoutException) {
        throw TimeoutException(
          "Timeout error",
        );
      } else {
        throw Exception(
          "Unknown error",
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
        throw const SocketException(
          "No Internet",
        );
      } else if (e is TimeoutException) {
        throw TimeoutException(
          "Timeout error",
        );
      } else {
        throw Exception(
          "Unknown error",
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
        throw const SocketException(
          "No Internet",
        );
      } else if (e is TimeoutException) {
        throw TimeoutException(
          "Timeout error",
        );
      } else {
        throw Exception(
          "Unknown error",
        );
      }
    }
  }

  /// Fetch Products
  static fetchProducts() async {
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

        List<ProductModel> products = jsonList
            .map((jsonItem) =>
                ProductModel.fromJson(jsonItem as Map<String, dynamic>))
            .toList();

        for (ProductModel product in products) {
          Storage.products.put(product.id, product);
        }
      }
    } catch (e) {
      if (e is SocketException) {
        throw const SocketException(
          "No Internet",
        );
      } else if (e is TimeoutException) {
        throw TimeoutException(
          "Timeout error",
        );
      } else {
        throw Exception(
          "Unknown error",
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
        throw const SocketException(
          "No Internet",
        );
      } else if (e is TimeoutException) {
        throw TimeoutException(
          "Timeout error",
        );
      } else {
        throw Exception(
          "Unknown error",
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
        throw const SocketException(
          "No Internet",
        );
      } else if (e is TimeoutException) {
        throw TimeoutException(
          "Timeout error",
        );
      } else {
        throw Exception(
          "Unknown error",
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
        throw const SocketException(
          "No Internet",
        );
      } else if (e is TimeoutException) {
        throw TimeoutException(
          "Timeout error",
        );
      } else {
        throw Exception(
          "Unknown error",
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
        throw const SocketException(
          "No Internet",
        );
      } else if (e is TimeoutException) {
        throw TimeoutException(
          "Timeout error",
        );
      } else {
        throw Exception(
          "Unknown error",
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
        throw const SocketException(
          "No Internet",
        );
      } else if (e is TimeoutException) {
        throw TimeoutException(
          "Timeout error",
        );
      } else {
        throw Exception(
          "Unknown error",
        );
      }
    }
  }
}
