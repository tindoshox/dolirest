import 'package:dolirest/infrastructure/dal/models/product_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/dio_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/dio_safe_request.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/dolibarr_api_error.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/api_path.dart';
import 'package:fpdart/fpdart.dart';

class ProductRepository extends DioService {
  /// Fetch Products
  Future<Either<DolibarrApiError, List<ProductModel>>> fetchProducts() {
    final queryParameters = {
      "sortfield": "label",
      "sortorder": "ASC",
    };

    return dio.safeRequest(() async {
      final response =
          await dio.get(ApiPath.products, queryParameters: queryParameters);
      final list = response.data as List;
      return list.map((p) => ProductModel.fromJson(p)).toList();
    });
  }

  /// Check stock for a product
  Future<Either<DolibarrApiError, bool>> checkStock(String productId) {
    return dio.safeRequest(() async {
      await dio.get('${ApiPath.products}/$productId/stock');
      // If it reaches here, statusCode is OK (200); otherwise, DioError would be thrown
      return true;
    });
  }
}
