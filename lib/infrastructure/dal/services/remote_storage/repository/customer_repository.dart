import 'dart:convert';
import 'dart:developer';

import 'package:dolirest/infrastructure/dal/services/remote_storage/dio_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/error_handler.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/api_path.dart';
import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/failure.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';

class CustomerRepository extends DioService {
  /// CustomerList
  Future<Either<Failure, List<CustomerModel>>> fetchCustomerList() async {
    final Map<String, String> queryParameters = {
      "sortfield": "t.nom",
      "sortorder": "ASC",
      "mode": "1",
      "limit": "0",
      "page": "1",
    };
    try {
      var response = await dio.get(
        ApiPath.customers,
        queryParameters: queryParameters,
      );

      return right(listCustomerModelFromJson(jsonEncode(response.data)));
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  /// Customer By Id

  Future<Either<Failure, CustomerModel>> fetchCustomerById(
      String customerId) async {
    try {
      var response = await dio.get(
        '${ApiPath.customers}/$customerId',
      );

      return right(CustomerModel.fromJson(response.data));
    } catch (error) {
      if (!kReleaseMode) {
        log('Error: $error');
      }
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  /// Create Customer
  Future<Either<Failure, String>> createCustomer(String body) async {
    try {
      var response = await dio.post(
        ApiPath.customers,
        data: body,
      );

      return right(
        response.data.toString().replaceAll('"', ''),
      );
    } catch (error) {
      if (!kReleaseMode) {
        log('Error: $error');
      }
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  /// Update Customer
  Future<Either<Failure, CustomerModel>> updateCustomer(
      String body, String customerId) async {
    try {
      var response = await dio.put(
        '${ApiPath.customers}/$customerId',
        data: body,
      );
      var json = jsonEncode(response.data);

      return right(customerModelFromJson(json));
    } catch (error) {
      if (!kReleaseMode) {
        log('Error: $error');
      }
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  /// Delete Customer
  Future<Either<Failure, String>> deleteCustomer(String customerId) async {
    try {
      var response = await dio.delete(
        '${ApiPath.customers}/$customerId',
      );
      return right(response.statusCode.toString());
    } catch (error) {
      if (!kReleaseMode) {
        log('Error: $error');
      }
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
