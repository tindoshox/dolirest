import 'package:dolirest/infrastructure/dal/models/product_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/api_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/catch_exception.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/failure.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/api_path.dart';
import 'package:fpdart/fpdart.dart';

class ProductRepository extends ApiService {
  /// Fetch Products
  Future<Either<Failure, List<ProductModel>>> fetchProducts() async {
    final queryParameters = {
      "sortfield": "label",
      "sortorder": "ASC",
    };
    try {
      var response = await httpClient.get(
        ApiPath.products,
        query: queryParameters,
        decoder: (data) {
          List<dynamic> l = data;
          return l.map((p) => ProductModel.fromJson(p)).toList();
        },
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

  /// Check stock Products
  Future<Either<Failure, bool>> checkStock(String productId) async {
    try {
      var response =
          await httpClient.get('${ApiPath.products}/$productId/stock');
      if (response.statusCode == 200) {
        return right(true);
      } else {
        return left(Failure(response.statusText!));
      }
    } on Exception catch (e) {
      return left(failure(e));
    }
  }
}
