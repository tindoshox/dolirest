import 'package:dio/dio.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioService extends GetxService {
  final AuthService auth = Get.find();
  final dio = Dio();
  final String apiStub = "/api/index.php/";

  // 🔐 Tracks all active CancelTokens
  final Map<String, CancelToken> _activeTokens = {};

  @override
  void onInit() {
    // Observe URL or token changes
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

  void configureDio({
    required String url,
    required String token,
  }) {
    dio.options.baseUrl = url;
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 90);
    dio.options.headers.clear();
    dio.options.headers.addAll({
      'HTTP_DOLAPIKEY': token,
      'DOLAPIKEY': token,
    });
    dio.options.responseType = ResponseType.json;

    if (!kReleaseMode) {
      if (dio.interceptors.whereType<PrettyDioLogger>().isEmpty) {
        dio.interceptors.add(
          PrettyDioLogger(
            error: true,
            responseBody: false,
            requestBody: true,
          ),
        );
      }
    }
  }

  /// Create or reuse a CancelToken by key
  CancelToken createToken([String key = 'default']) {
    final token = CancelToken();
    _activeTokens[key] = token;

    //  token.whenCancel.then((_) => _activeTokens.remove(key));
    return token;
  }

  /// Cancel a specific token by key
  void cancelRequest(String key) {
    _activeTokens[key]?.cancel("Cancelled: $key");
    _activeTokens.remove(key);
  }

  /// Cancel all in-flight Dio requests
  void cancelAllRequests() {
    for (final token in _activeTokens.values) {
      token.cancel("Cancelled by logout");
    }
    _activeTokens.clear();
  }
}
