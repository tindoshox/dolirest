import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dolirest/infrastructure/dal/services/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      getBox.write('connected', false);
      Get.rawSnackbar(
          backgroundColor: Colors.amber,
          messageText: const Text(
            'No Internet: Data Capture is Disabled',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          isDismissible: false,
          duration: const Duration(days: 1),
          icon: const Icon(
            Icons.wifi_off_outlined,
            color: Colors.white,
            size: 35,
          ),
          padding: const EdgeInsets.only(left: 40),
          snackStyle: SnackStyle.GROUNDED);
    } else {
      getBox.write('connected', true);
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    }
  }
}
