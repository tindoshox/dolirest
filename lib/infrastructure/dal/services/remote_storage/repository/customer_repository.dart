import 'package:dolirest/infrastructure/dal/services/remote_storage/dio_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/error_handler.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/api_path.dart';
import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/failure.dart';
import 'package:fpdart/fpdart.dart';

class CustomerRepository extends DioService {
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
      var response = await dio.get(
        ApiPath.customers,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        List<dynamic> l = response.data;
        return right(l.map((c) => CustomerModel.fromJson(c)).toList());
      } else {
        return left(Failure(response.statusCode!, response.statusMessage!));
      }
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
      if (response.statusCode == 200) {
        return right(
          response.data.toString().replaceAll('"', ''),
        );
      } else {
        return left(Failure(response.statusCode!, response.statusMessage!));
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  /// Update Customer
  Future<Either<Failure, CustomerModel>> updateCustomer(
      String body, String customerId) async {
    try {
      var response = await dio.put(
        '/$customerId',
        data: body,
      );

      if (response.statusCode == 200) {
        return right(customerModelFromJson(response.data));
      } else {
        return left(Failure(response.statusCode!, response.statusMessage!));
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
