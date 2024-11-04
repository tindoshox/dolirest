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
      var response = await httpClient
          .get(ApiPath.customers, query: queryParameters, decoder: (data) {
        List<dynamic> l = data is List<dynamic> ? data : [];
        return l.map((c) => CustomerModel.fromJson(c)).toList();
      }).timeout(Duration(seconds: 60));

      if (response.statusCode == 200) {
        return right(response.body!);
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
      var response = await httpClient.get('${ApiPath.customers}/$customerId',
          decoder: (data) => CustomerModel.fromJson(data));

      return right(response.body!);
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
        decoder: (data) => data.toString().replaceAll('"', ''),
      );
      if (response.statusCode == 200) {
        return right(response.body!);
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
        decoder: (data) => CustomerModel.fromJson(data),
      );

      if (response.statusCode == 200) {
        return right(response.body!);
      } else {
        return left(Failure(response.statusText!));
      }
    } on Exception catch (e) {
      return left(failure(e));
    }
  }
}
