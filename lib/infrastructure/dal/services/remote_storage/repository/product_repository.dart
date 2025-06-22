import 'package:dolirest/infrastructure/dal/models/product/product_entity.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/dio_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/dio_safe_request.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/dolibarr_api_error.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/api_path.dart';
import 'package:fpdart/fpdart.dart';

class ProductRepository extends DioService {
  /// Fetch Products
  Future<Either<DolibarrApiError, List<ProductEntity>>> fetchProducts() {
    final queryParameters = {
      "sortfield": "label",
      "sortorder": "ASC",
    };

    return dio.safeRequest((token) async {
      final response =
          await dio.get(ApiPath.products, queryParameters: queryParameters);

      return productEntityListFromJson(response.data);
    });
  }
}
