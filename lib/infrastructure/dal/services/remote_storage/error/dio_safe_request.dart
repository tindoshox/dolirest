import 'package:dio/dio.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/dolibarr_api_error.dart';
import 'package:fpdart/fpdart.dart';

extension DioSafeRequest on Dio {
  Future<Either<DolibarrApiError, T>> safeRequest<T>(
      Future<T> Function() call) async {
    try {
      final result = await call();
      return Right(result);
    } catch (error) {
      return Left(_mapToDolibarrError(error));
    }
  }

  DolibarrApiError _mapToDolibarrError(dynamic error) {
    if (error is DioException) {
      final data = error.response?.data;

      if (data is Map<String, dynamic>) {
        try {
          return DolibarrApiError.fromJson(data);
        } catch (_) {
          return DolibarrApiError(
            code: error.response?.statusCode ?? -1,
            message: 'Error response could not be parsed',
            source: 'Parsing',
          );
        }
      }

      return DolibarrApiError(
        code: error.response?.statusCode ?? -1,
        message: error.message ?? 'Unknown Dio error',
        source: 'Dio',
      );
    }

    return DolibarrApiError.generic(error);
  }
}
