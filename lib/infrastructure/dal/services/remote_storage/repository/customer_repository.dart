import 'dart:convert';

import 'package:dolirest/infrastructure/dal/services/remote_storage/api_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/catch_exception.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/api_path.dart';
import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/failure.dart';
import 'package:fpdart/fpdart.dart';

class CustomerRepository extends ApiService {
  /// CustomerList
  Future<Either<Failure, List<CustomerModel>>> fetchCustomerList(
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
      var response = await httpClient.get(
        ApiPath.customers,
        query: queryParameters,
      );

      if (response.statusCode == 200) {
        String jsonString = response.bodyString!;
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
        return left(Failure(response.statusText!));
      }
    } on Exception catch (e) {
      return left(Failure(e.toString()));
    }
  }

  /// Customer By Id

  Future<Either<Failure, CustomerModel>> fetchCustomerById(
      String customerId) async {
    try {
      var response = await httpClient.get('${ApiPath.customers}/$customerId');
      if (response.statusCode == 200) {
        return right(customerModelFromJson(response.bodyString!));
      } else {
        return left(Failure(response.statusText!));
      }
    } on Exception catch (e) {
      return left(failure(e));
    }
  }

  /// Create Customer
  Future<Either<Failure, String>> createCustomer(String body) async {
    try {
      var response = await httpClient.post(
        ApiPath.customers,
        body: body,
      );
      if (response.statusCode == 200) {
        return right(response.bodyString!.replaceAll('"', ''));
      } else {
        return left(Failure(response.statusText!));
      }
    } on Exception catch (e) {
      return left(failure(e));
    }
  }

  /// Update Customer
  Future<Either<Failure, CustomerModel>> updateCustomer(
      String body, String customerId) async {
    try {
      var response = await httpClient.put(
        '/$customerId',
        body: body,
      );

      if (response.statusCode == 200) {
        return right(customerModelFromJson(response.bodyString!));
      } else {
        return left(Failure(response.statusText!));
      }
    } on Exception catch (e) {
      return left(failure(e));
    }
  }
}
