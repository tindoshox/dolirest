import 'package:dio/dio.dart';
import 'package:dolirest/infrastructure/dal/models/customer/customer_entity.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/dio_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/dio_safe_request.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/dolibarr_api_error.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/api_path.dart';
import 'package:fpdart/fpdart.dart';

class CustomerRepository extends DioService {
  Future<Either<DolibarrApiError, List<CustomerEntity>>> fetchCustomerList({
    required int page,
    required int limit,
    CancelToken? cancelToken,
  }) {
    final properties =
        "id,name,state_id,region_id,date_modification,phone,fax,code_client,address,town";

    return dio.safeRequest(
      (token) async {
        var queryParameters = {
          "sortfield": "t.rowid",
          "sortorder": "ASC",
          "mode": "1",
          "limit": limit,
          "page": page,
          "properties": properties,
        };

        final response = await dio.get(ApiPath.customers,
            queryParameters: queryParameters,
            cancelToken: cancelToken ?? token);
        return parseCustomerListFromJson(response.data);
      },
      token: cancelToken,
    );
  }

  Future<Either<DolibarrApiError, CustomerEntity>> fetchCustomerById(
      String id) {
    return dio.safeRequest((token) async {
      final response = await dio.get('${ApiPath.customers}/$id');
      return parseCustomerFromJson(response.data);
    });
  }

  Future<Either<DolibarrApiError, String>> createCustomer(String body) {
    return dio.safeRequest((token) async {
      final response = await dio.post(ApiPath.customers, data: body);
      return response.data.toString().replaceAll('"', '');
    });
  }

  Future<Either<DolibarrApiError, CustomerEntity>> updateCustomer(
      String body, String id) {
    return dio.safeRequest((token) async {
      final response = await dio.put('${ApiPath.customers}/$id', data: body);
      return parseCustomerFromJson(response.data);
    });
  }

  Future<Either<DolibarrApiError, String>> deleteCustomer(String id) {
    return dio.safeRequest((token) async {
      final response = await dio.delete('${ApiPath.customers}/$id');
      return response.statusCode.toString();
    });
  }
}
