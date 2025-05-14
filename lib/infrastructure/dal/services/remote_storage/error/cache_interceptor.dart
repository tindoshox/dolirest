import 'package:dio/dio.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/error_handler.dart';

class CacheInterceptor extends InterceptorsWrapper {
  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    ErrorHandler.handle(err);
    return super.onError(err, handler);
  }
}
