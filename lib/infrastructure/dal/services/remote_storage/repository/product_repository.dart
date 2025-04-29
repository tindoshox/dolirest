import 'package:dolirest/infrastructure/dal/models/product_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/dio_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/error_handler.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/failure.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/api_path.dart';
import 'package:fpdart/fpdart.dart';

class ProductRepository extends DioService {
  /// Fetch Products
  Future<Either<Failure, List<ProductModel>>> fetchProducts() async {
    final queryParameters = {
      "sortfield": "label",
      "sortorder": "ASC",
    };
    try {
      var response =
          await dio.get(ApiPath.products, queryParameters: queryParameters);
 
        List<dynamic> l = response.data;
        return right(l.map((p) => ProductModel.fromJson(p)).toList());
     
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  /// Check stock Products
  Future<Either<Failure, bool>> checkStock(String productId) async {
    try {
      var response = await dio.get('${ApiPath.products}/$productId/stock');
      if (response.statusCode == 200) {
        return right(true);
      } else {
        return left(Failure(response.statusCode!, response.statusMessage!));
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
