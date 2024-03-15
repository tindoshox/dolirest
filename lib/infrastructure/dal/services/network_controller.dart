import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dolirest/infrastructure/dal/services/get_storage.dart';

import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> subscription;
  var connected = true.obs;

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

  void _updateConnectionStatus(ConnectivityResult connectivityResult) async {
    if (connectivityResult == ConnectivityResult.none) {
      connected(false);
      getBox.write('connected', false);
    } else {
      connected(true);
      getBox.write('connected', true);
    }
  }
}
