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
      final statusCode = error.response?.statusCode ?? -1;
      final data = error.response?.data;

      switch (error.type) {
        case DioExceptionType.connectionError:
        case DioExceptionType.unknown:
          return DolibarrApiError(
            code: -1,
            message: 'No internet connection or server unreachable.',
            source: 'Network',
          );

        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return DolibarrApiError(
            code: -1,
            message: 'Request timed out. Please try again.',
            source: 'Timeout',
          );

        case DioExceptionType.badResponse:
          if (data is Map<String, dynamic>) {
            try {
              return DolibarrApiError.fromJson(data);
            } catch (_) {
              return DolibarrApiError(
                code: statusCode,
                message: 'Invalid error response from server.',
                source: 'Parsing',
              );
            }
          } else {
            return DolibarrApiError(
              code: statusCode,
              message: 'Unexpected server error.',
              source: 'Server',
            );
          }

        default:
          return DolibarrApiError(
            code: statusCode,
            message: 'An unexpected error occurred.',
            source: 'Unknown',
          );
      }
    }

    // Non-Dio exceptions
    return DolibarrApiError(
      code: -1,
      message: error.toString(),
      source: 'Unhandled',
    );
  }
}
