import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_key.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';

class ApiService extends GetConnect {
  final StorageController storage = Get.put(StorageController());
  final String apiStub = "/api/index.php/";
  @override
  void onInit() {
    final auth = {
      'DOLAPIKEY': storage.getSetting(StorageKey.apiKey).toString()
    };
    httpClient.baseUrl =
        'https://${storage.getSetting(StorageKey.url)}$apiStub';
    httpClient.addRequestModifier((Request request) {
      request.headers.addAll(auth);
      return request;
    });
    httpClient.defaultContentType = 'application/json';
    httpClient.errorSafety = true;
    httpClient.timeout = Duration(seconds: 30);
    httpClient.removeResponseModifier((request, response) {});
    super.onInit();
  }
}
