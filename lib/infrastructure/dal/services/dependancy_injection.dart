import 'package:dolirest/infrastructure/dal/services/network_controller.dart';
import 'package:dolirest/infrastructure/dal/services/storage/storage.dart';
import 'package:get/get.dart';

class DependencyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
    Get.put<StorageController>(StorageController(), permanent: true);
  }
}
