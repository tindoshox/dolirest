import 'package:dolirest/infrastructure/dal/models/settings_model.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_key.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_service.dart';
import 'package:dolirest/utils/string_manager.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  final storage = Get.find<StorageService>();
  final RxString url = ''.obs;
  final RxString token = ''.obs;

  @override
  onInit() async {
    // Restore from storage (Hive, ObjectBox, SharedPrefs, etc.)
    url.value = await loadUrlFromStorage();
    token.value = await loadTokenFromStorage();
    super.onInit();
  }

  void updateCredentials(String newUrl, String newToken) {
    url.value = newUrl;
    token.value = newToken;
    saveUrlToStorage(newUrl);
    saveTokenToStorage(newToken);
  }

  Future<void> saveUrlToStorage(String url) async {
    storage.settingsBox.put(SettingsModel(
        id: SettingId.urlSettingId, name: StorageKey.url, strValue: url));
  }

  Future<String> loadUrlFromStorage() async {
    return storage.settingsBox.get(SettingId.urlSettingId)?.strValue! ?? '';
  }

  Future<void> saveTokenToStorage(String token) async {
    storage.settingsBox.put(SettingsModel(
        id: SettingId.tokenSettingId, name: StorageKey.token, strValue: token));
  }

  Future<String> loadTokenFromStorage() async {
    return storage.settingsBox.get(SettingId.tokenSettingId)?.strValue ?? '';
  }
}
