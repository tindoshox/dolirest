import 'dart:convert';

import 'package:dolirest/infrastructure/dal/models/customer/customer_entity.dart';
import 'package:dolirest/infrastructure/dal/models/customer/customer_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/dio_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/dio_safe_request.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/dolibarr_api_error.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/api_path.dart';
import 'package:fpdart/fpdart.dart';

class CustomerRepository extends DioService {
  Future<Either<DolibarrApiError, List<CustomerEntity>>> fetchCustomerList(
      {int page = 1, int limit = 0, String? dateModified}) {
    final properties =
        "id,name,state_id,region_id,date_modification,phone,fax,code_client,address,town";

    var queryParameters = {
      "sortfield": "t.rowid",
      "sortorder": "ASC",
      "mode": "1",
      "limit": limit,
      "page": page,
      "properties": properties
    };

    if (dateModified != null) {
      queryParameters["sqlfilters"] = "(t.tms:>:'$dateModified')";
    }

    return dio.safeRequest(() async {
      final response =
          await dio.get(ApiPath.customers, queryParameters: queryParameters);
      return parseCustomersFromJson(response.data);
    });
  }

  Future<Either<DolibarrApiError, CustomerEntity>> fetchCustomerById(
      String id) {
    return dio.safeRequest(() async {
      final response = await dio.get('${ApiPath.customers}/$id');
      final customer = CustomerModel.fromJson(response.data);
      return CustomerEntity(
        customerId: customer.id,
        name: customer.name,
        stateId: customer.stateId,
        regionId: customer.regionId,
        dateModification: customer.dateModification,
        phone: customer.phone,
        fax: customer.fax,
        codeClient: customer.codeClient,
        address: customer.address,
        town: customer.town,
      );
    });
  }

  Future<Either<DolibarrApiError, String>> createCustomer(String body) {
    return dio.safeRequest(() async {
      final response = await dio.post(ApiPath.customers, data: body);
      return response.data.toString().replaceAll('"', '');
    });
  }

  Future<Either<DolibarrApiError, CustomerEntity>> updateCustomer(
      String body, String id) {
    return dio.safeRequest(() async {
      final response = await dio.put('${ApiPath.customers}/$id', data: body);
      final customer = customerModelFromJson(jsonEncode(response.data));
      return CustomerEntity(
        customerId: customer.id,
        name: customer.name,
        stateId: customer.stateId,
        regionId: customer.regionId,
        dateModification: customer.dateModification,
        phone: customer.phone,
        fax: customer.fax,
        codeClient: customer.codeClient,
        address: customer.address,
        town: customer.town,
      );
    });
  }

  Future<Either<DolibarrApiError, String>> deleteCustomer(int id) {
    return dio.safeRequest(() async {
      final response = await dio.delete('${ApiPath.customers}/$id');
      return response.statusCode.toString();
    });
  }
}
