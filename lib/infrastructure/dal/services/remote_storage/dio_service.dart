import 'package:dio/dio.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioService extends GetxService {
  final AuthService auth = Get.find();
  final dio = Dio();
  final String apiStub = "/api/index.php/";

  @override
  void onInit() {
    everAll([auth.url, auth.token], (_) {
      if (auth.url.value.isNotEmpty && auth.token.value.isNotEmpty) {
        configureDio(
          url: '${auth.url.value}$apiStub',
          token: auth.token.value,
        );
      }
    });

    // Initial setup
    if (auth.url.value.isNotEmpty && auth.token.value.isNotEmpty) {
      configureDio(
        url: '${auth.url.value}$apiStub',
        token: auth.token.value,
      );
    }

    super.onInit();
  }

  void configureDio({required String url, required String token}) {
    dio.options.baseUrl = url;
    dio.options.connectTimeout = Duration(seconds: 10);
    dio.options.receiveTimeout = Duration(seconds: 90);
    dio.options.headers.clear();
    dio.options.headers.addAll({
      'HTTP_DOLAPIKEY': token,
      'DOLAPIKEY': token,
    });
    dio.options.responseType = ResponseType.json;

    if (!kReleaseMode) {
      if (dio.interceptors.whereType<PrettyDioLogger>().isEmpty) {
        dio.interceptors.add(
          PrettyDioLogger(error: true, responseBody: false, requestBody: true),
        );
      }
    }
  }
}
