import 'package:dio/dio.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_service.dart';
import 'package:dolirest/utils/string_manager.dart' show SettingId;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioService extends GetxService {
  final StorageService storage = Get.find();
  final dio = Dio();
  final String apiStub = "/api/index.php/";

  @override
  void onInit() {
    String? url = storage.getSetting(SettingId.urlSettingId)?.strValue;
    String? token = storage.getSetting(SettingId.tokenSettingId)?.strValue;

    if (url != null && token != null) {
      configureDio(url: '$url$apiStub', token: token);
    }

    super.onInit();
  }

  void configureDio({required String url, required String token}) {
    var auth = {'HTTP_DOLAPIKEY': token, 'DOLAPIKEY': token};
    // Set default configs
    dio.options.baseUrl = url;
    dio.options.connectTimeout = Duration(seconds: 10);
    dio.options.receiveTimeout = Duration(seconds: 90);
    dio.options.headers.addAll(auth);
    dio.options.responseType = ResponseType.json;

    if (!kReleaseMode) {
      dio.interceptors.add(
        PrettyDioLogger(error: true, responseBody: false, requestBody: false),
      );
    }
  }
}
