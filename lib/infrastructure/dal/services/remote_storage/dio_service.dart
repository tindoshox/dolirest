import 'package:dio/dio.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_key.dart';
import 'package:get/get.dart';

class DioService extends GetxService {
  final StorageService storage = Get.find();
  final dio = Dio(); // With default `Options`.
  final String apiStub = "/api/index.php/";

  @override
  void onInit() {
    var url = storage.getSetting(StorageKey.url);
    var apiKey = storage.getSetting(StorageKey.apiKey);
    if (url != null && apiKey != null) {
      configureDio(url: url, apiKey: apiKey);
    }
    super.onInit();
  }

  void configureDio({required String url, required String apiKey}) {
    var auth = {
      'DOLAPIKEY': apiKey,
    };
    // Set default configs
    dio.options.baseUrl = '$url$apiStub';
    dio.options.connectTimeout = Duration(seconds: 30);
    dio.options.receiveTimeout = Duration(seconds: 60);
    dio.options.headers.addAll(auth);
  }
}
