import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dolirest/infrastructure/dal/services/storage.dart';

import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> subscription;

  @override
  void onInit() {
    super.onInit();
    subscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _updateConnectionStatus(result);
    });
  }

  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      Storage.settings.put('connected', false);
    } else {
      Storage.settings.put('connected', true);
    }
  }
}
