import 'dart:convert';

import 'package:dolirest/infrastructure/dal/services/remote_storage/dio_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/dio_safe_request.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/dolibarr_api_error.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/api_path.dart';
import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:fpdart/fpdart.dart';

class CustomerRepository extends DioService {
  Future<Either<DolibarrApiError, List<CustomerModel>>> fetchCustomerList(
      {int page = 1, int limit = 0, String? dateModified}) {
    var queryParameters = {
      "sortfield": "t.nom",
      "sortorder": "ASC",
      "mode": "1",
      "limit": limit,
      "page": page,
    };

    if (dateModified != null) {
      queryParameters["sqlfilters"] = "(t.tms:>:'$dateModified')";
    }

    return dio.safeRequest(() async {
      final response =
          await dio.get(ApiPath.customers, queryParameters: queryParameters);
      return listCustomerModelFromJson(jsonEncode(response.data));
    });
  }

  Future<Either<DolibarrApiError, CustomerModel>> fetchCustomerById(String id) {
    return dio.safeRequest(() async {
      final response = await dio.get('${ApiPath.customers}/$id');
      return CustomerModel.fromJson(response.data);
    });
  }

  Future<Either<DolibarrApiError, String>> createCustomer(String body) {
    return dio.safeRequest(() async {
      final response = await dio.post(ApiPath.customers, data: body);
      return response.data.toString().replaceAll('"', '');
    });
  }

  Future<Either<DolibarrApiError, CustomerModel>> updateCustomer(
      String body, String id) {
    return dio.safeRequest(() async {
      final response = await dio.put('${ApiPath.customers}/$id', data: body);
      return customerModelFromJson(jsonEncode(response.data));
    });
  }

  Future<Either<DolibarrApiError, String>> deleteCustomer(String id) {
    return dio.safeRequest(() async {
      final response = await dio.delete('${ApiPath.customers}/$id');
      return response.statusCode.toString();
    });
  }
}
