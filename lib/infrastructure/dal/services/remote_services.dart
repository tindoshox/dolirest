//Dolibarr api

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dolirest/infrastructure/dal/models/third_party_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:dolirest/infrastructure/dal/models/build_document_response_model.dart';
import 'package:dolirest/infrastructure/dal/models/build_report_response_model.dart';
import 'package:dolirest/infrastructure/dal/models/data_or_exception.dart';
import 'package:dolirest/infrastructure/dal/models/group_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_by_id_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_list_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_list_model.dart';
import 'package:dolirest/infrastructure/dal/models/products_model.dart';
import 'package:dolirest/infrastructure/dal/models/user_model.dart';
import 'package:dolirest/infrastructure/dal/services/api_routes.dart';
import 'package:dolirest/infrastructure/dal/services/get_storage.dart';

class RemoteServices {
  //static final _client = http.Client();
  static final _client = RetryClient(http.Client());
  static const timeout = Duration(seconds: 20);
  static final url = box.read('url');
  static final apikey = box.read('apikey');

  /// CustomerList
  static Future<DataOrException> fetchThirdPartyList(
      String sqlfilters, String mode, int page) async {
    final queryParameters = {
      "sortfield": "t.nom",
      "sortorder": "ASC",
      "mode": mode,
      "limit": "50",
      "page": page.toString(),
      "sqlfilters":
          "(t.nom:like:'$sqlfilters') or (t.phone:like:'$sqlfilters') or (t.fax:like:'$sqlfilters') or (t.town:like:'$sqlfilters')or (t.address:like:'$sqlfilters')",
    };
    try {
      var response = await _client.get(
        Uri.https(url, ApiRoutes.customers, queryParameters),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'DOLAPIKEY': apikey
        },
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final customers = List<ThirdPartyModel>.from(
            json.decode(response.body).map((x) => ThirdPartyModel.fromJson(x)));

        return DataOrException(
          data: customers,
          statusCode: response.statusCode,
        );
      } else {
        return DataOrException(
          errorMessage: 'Customer Not Found',
          hasError: true,
          data: [],
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          data: [],
          errorMessage: "Connection error",
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

  /// invoiceList
  static Future<DataOrException> fetchInvoiceList(
      String sqlfilters, int page) async {
    final queryParameters = {
      "sortfield": "t.date_lim_reglement",
      "sortorder": "ASC",
      "status": "unpaid",
      "page": page.toString(),
      "limit": "50",
      "sqlfilters":
          "(t.type:=:0) and ((t.ref:like:'$sqlfilters') or (nom:like:'$sqlfilters'))"

      // To enable filtering by customer name we need to modify htdocs/compta/facture/class/api_invoices.class.php
      // To have customer name on invoice data we need to modify htdocs/compta/facture/class/facture.class.php
    };

    try {
      var response = await _client.get(
        Uri.https(url, ApiRoutes.invoices, queryParameters),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'DOLAPIKEY': apikey
        },
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return DataOrException(
          data: invoiceFromJson(response.body),
          statusCode: response.statusCode,
        );
      } else {
        return DataOrException(
          errorMessage: response.reasonPhrase,
          data: [],
          hasError: true,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Connection error",
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

  /// Customers By Id
  static Future<DataOrException> fetchThirdPartyById(String customerId) async {
    try {
      var response = await _client.get(
        Uri.https(url, '${ApiRoutes.customers}/$customerId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'DOLAPIKEY': apikey
        },
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return DataOrException(
          data: thirdPartyModelFromJson(response.body),
          statusCode: response.statusCode,
        );
      } else {
        return DataOrException(
          errorMessage: response.reasonPhrase,
          hasError: true,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Connection error",
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

  /// invoice by customer
  static Future<DataOrException> fetchInvoicesByCustomerId(
      String customerId) async {
    final queryParameters = {
      "sortfield": "t.rowid",
      "sortorder": "DESC",
      "limit": "20",
      "thirdparty_ids": customerId,
      "sqlfilters": "(t.type:=:0)",
    };
    try {
      var response = await _client.get(
        Uri.https(url, ApiRoutes.invoices, queryParameters),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'DOLAPIKEY': apikey
        },
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return DataOrException(
          data: invoiceFromJson(response.body),
          statusCode: response.statusCode,
        );
      } else {
        return DataOrException(
          errorMessage: response.reasonPhrase,
          hasError: true,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Connection error",
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

  /// Customer Payment List
  static Future<DataOrException> fetchPaymentsByInvoice(
      String invoiceId) async {
    try {
      var response = await _client.get(
        Uri.https(url, '${ApiRoutes.invoices}/$invoiceId/payments'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'DOLAPIKEY': apikey
        },
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return DataOrException(
          data: paymentFromMap(response.body),
          statusCode: response.statusCode,
        );
      } else {
        return DataOrException(
          errorMessage: response.reasonPhrase,
          hasError: true,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Connection error",
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
      var response = await _client.get(
        Uri.https(url, '${ApiRoutes.invoices}/$invoiceId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'DOLAPIKEY': apikey
        },
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return DataOrException(
          data: invoiceByIdFromMap(response.body),
          statusCode: response.statusCode,
        );
      } else {
        return DataOrException(
          errorMessage: response.reasonPhrase,
          hasError: true,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Connection error",
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
      var response = await _client.put(
        Uri.https(url, '${ApiRoutes.invoices}/$invoiceId'),
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'DOLAPIKEY': apikey
        },
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return DataOrException(
          data: invoiceByIdFromMap(response.body),
          statusCode: response.statusCode,
        );
      } else {
        return DataOrException(
          errorMessage: response.reasonPhrase,
          hasError: true,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Connection error",
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
      var response = await _client.post(
        Uri.https(url, ApiRoutes.customers),
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'DOLAPIKEY': apikey
        },
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return DataOrException(
          data: response.body.replaceAll('"', ''),
          statusCode: response.statusCode,
        );
      } else {
        return DataOrException(
          errorMessage: response.reasonPhrase,
          hasError: true,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Connection error",
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
      var response = await _client.put(
        Uri.https(url, '${ApiRoutes.customers}/$customerId'),
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'DOLAPIKEY': apikey
        },
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return DataOrException(
          data: thirdPartyModelFromJson(response.body),
          statusCode: response.statusCode,
        );
      } else {
        return DataOrException(
          errorMessage: response.reasonPhrase,
          hasError: true,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Connection error",
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
  static Future<DataOrException> fetchGroups(String searchString) async {
    final queryParameters = {
      "sortfield": "nom",
      "sortorder": "ASC",
      "sqlfilters": "(t.active:=:1) and (t.nom:like:'$searchString')",
    };
    try {
      var response = await _client.get(
        Uri.https(url, ApiRoutes.groups, queryParameters),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'DOLAPIKEY': apikey
        },
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return DataOrException(
          data: groupModelFromMap(response.body),
          statusCode: response.statusCode,
        );
      } else {
        return DataOrException(
          errorMessage: response.reasonPhrase,
          hasError: true,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Connection error",
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
      var response = await _client.get(
        Uri.https(url, ApiRoutes.users),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'DOLAPIKEY': apikey
        },
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return DataOrException(
          data: userModelFromJson(response.body),
          statusCode: response.statusCode,
        );
      } else {
        return DataOrException(
          errorMessage: response.reasonPhrase,
          hasError: true,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Connection error",
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
    var serverURL = url;
    try {
      var response = await _client.post(
        Uri.https(serverURL, '${ApiRoutes.invoices}/paymentsdistributed'),
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'DOLAPIKEY': apikey
        },
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return DataOrException(
          data: response.body.replaceAll('"', ''),
          statusCode: response.statusCode,
        );
      } else {
        return DataOrException(
          errorMessage: response.reasonPhrase,
          hasError: true,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Connection error",
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
  static Future<DataOrException> fetchProducts(String searchString) async {
    final queryParameters = {
      "sortfield": "label",
      "sortorder": "ASC",
      "sqlfilters": "(t.label:like:'$searchString')",
    };
    try {
      var response = await _client.get(
        Uri.https(url, ApiRoutes.products, queryParameters),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'DOLAPIKEY': apikey
        },
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return DataOrException(
          data: productFromMap(response.body),
          statusCode: response.statusCode,
        );
      } else {
        return DataOrException(
          errorMessage: response.reasonPhrase,
          hasError: true,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Connection error",
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
      var response = await _client.get(
        Uri.https(url, '${ApiRoutes.products}/$productId/stock'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'DOLAPIKEY': apikey
        },
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return DataOrException(
          data: response.statusCode,
          statusCode: response.statusCode,
        );
      } else {
        return DataOrException(
          errorMessage: response.reasonPhrase,
          hasError: true,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Connection error",
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
      var response = await _client.post(
        Uri.https(url, ApiRoutes.invoices),
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'DOLAPIKEY': apikey
        },
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return DataOrException(
          data: response.body.replaceAll('"', ''),
          statusCode: response.statusCode,
        );
      } else {
        return DataOrException(
          errorMessage: response.reasonPhrase,
          hasError: true,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Connection error",
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
      var response = await _client.post(
        Uri.https(url, '${ApiRoutes.invoices}/$invoiceId/validate'),
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'DOLAPIKEY': apikey
        },
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return DataOrException(
          data: response.body.replaceAll('"', ''),
          statusCode: response.statusCode,
        );
      } else {
        return DataOrException(
          errorMessage: response.reasonPhrase,
          hasError: true,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Connection error",
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
      var response = await _client.put(
        Uri.https(url, ApiRoutes.buildDocument),
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'DOLAPIKEY': apikey
        },
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return DataOrException(
          data: buildDucumentResponseModelFromJson(response.body),
          statusCode: response.statusCode,
        );
      } else {
        return DataOrException(
          errorMessage: response.reasonPhrase,
          hasError: true,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Connection error",
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
      var response = await _client.put(
        Uri.https(url, ApiRoutes.buildReport),
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'DOLAPIKEY': apikey
        },
      ).timeout(timeout);

      if (response.statusCode == 200) {
        return DataOrException(
          data: buildReportResponseModelFromJson(response.body),
          statusCode: response.statusCode,
        );
      } else {
        return DataOrException(
          errorMessage: response.reasonPhrase,
          hasError: true,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is SocketException) {
        return DataOrException(
          hasError: true,
          errorMessage: "Connection error",
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
