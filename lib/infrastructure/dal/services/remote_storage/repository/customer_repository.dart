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
      {String? dateModified}) {
    final properties =
        "id,name,state_id,region_id,date_modification,phone,fax,code_client,address,town";

    return dio.safeRequest(() async {
      var customers = <CustomerEntity>[];
      int page = 0;
      const int limit = 1000;
      bool hasNextPage = true;
      while (hasNextPage) {
        var queryParameters = {
          "sortfield": "t.rowid",
          "sortorder": "ASC",
          "mode": "1",
          "limit": limit,
          "page": page,
          "properties": properties,
          if (dateModified != null) "sqlfilters": "(t.tms:>=:'$dateModified')",
        };

        final response =
            await dio.get(ApiPath.customers, queryParameters: queryParameters);
        final list = parseCustomerListFromJson(response.data);
        if (list.length < limit) {
          hasNextPage = false;
        } else {
          page++;
        }

        if (list.isNotEmpty) {
          customers.addAll(list);
        }
      }
      return customers;
    });
  }

  Future<Either<DolibarrApiError, CustomerEntity>> fetchCustomerById(
      String id) {
    return dio.safeRequest(() async {
      final response = await dio.get('${ApiPath.customers}/$id');
      return parseCustomerFromJson(response.data);
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
        customerId: customer.id ?? '',
        name: customer.name ?? '',
        stateId: customer.stateId ?? '',
        regionId: customer.regionId ?? '',
        dateModification: customer.dateModification ?? 0,
        phone: customer.phone ?? '',
        fax: customer.fax ?? '',
        codeClient: customer.codeClient ?? '',
        address: customer.address ?? '',
        town: customer.town ?? '',
      );
    });
  }

  Future<Either<DolibarrApiError, String>> deleteCustomer(String id) {
    return dio.safeRequest(() async {
      final response = await dio.delete('${ApiPath.customers}/$id');
      return response.statusCode.toString();
    });
  }
}
