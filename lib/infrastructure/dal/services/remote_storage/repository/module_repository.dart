import 'package:dio/dio.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/dio_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/dio_safe_request.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/dolibarr_api_error.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/api_path.dart';
import 'package:fpdart/fpdart.dart';

class ModuleRepository extends DioService {
  Future<Either<DolibarrApiError, List<String>>> fetchEnabledModules() {
    return dio.safeRequest(() async {
      final response = await dio.get(ApiPath.modules);

      if (response.data is List) {
        final list = (response.data as List).map((e) => e.toString()).toList();
        return list;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message:
              'Unexpected response format: Expected List but got ${response.data.runtimeType}',
          type: DioExceptionType.badResponse,
        );
      }
    });
  }
}
