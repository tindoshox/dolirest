import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/models/user_model.dart';
import 'package:dolirest/infrastructure/dal/services/get_storage.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';

class HomeController extends GetxController {
  var currentUser = DolibarrUserModel().obs;
  var baseUrl = ''.obs;
  var isLoading = false.obs;

  @override
  void onReady() {
    baseUrl.value = box.read('url');
    _fetchUserInfo();
    super.onReady();
  }

  Future _fetchUserInfo() async {
    isLoading.value = true;
    await RemoteServices.fetchUserInfo().then((value) {
      isLoading.value = false;
      if (!value.hasError) {
        currentUser(value.data);
        isLoading.value = false;
      }
    });
  }
}
