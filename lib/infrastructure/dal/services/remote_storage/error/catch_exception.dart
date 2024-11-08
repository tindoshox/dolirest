import 'package:dio/dio.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/failure.dart';

Failure failure(DioException e) {
  if (e.message != null) {
    return Failure(e.message!);
  } else {
    return Failure(e.error.toString());
  }
}
