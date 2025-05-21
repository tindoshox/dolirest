import 'package:dolirest/infrastructure/dal/services/remote_storage/dio_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/error_handler.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/failure.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/api_path.dart';
import 'package:fpdart/fpdart.dart';

class ModuleRepository extends DioService {
  Future<Either<Failure, List<String>>> fetchEnabledModules() async {
    try {
      var response = await dio.get(ApiPath.modules);
      if (response.data is List) {
        List<dynamic> l = response.data;

        return right(l.map((i) => i.toString()).toList());
      } else {
        return left(Failure(
          response.statusCode!,
          "Unexpected response format: Expected a List but got ${response.data.runtimeType}",
        ));
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
