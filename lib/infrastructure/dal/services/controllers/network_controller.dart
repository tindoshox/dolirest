import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/server_reachablility.dart';

import 'package:get/get.dart';

class NetworkController extends GetxController {
  final ServerReachablility reachablility = Get.put(ServerReachablility());
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> subscription;
  Timer? _serverCheckTimer;
  var connected = false.obs;

  @override
  void onInit() {
    super.onInit();
    subscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      _updateConnectionStatus(result);
    });
  }

  @override
  void onReady() {
    _startServerReachabilityCheck();
    super.onReady();
  }

  @override
  dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future<void> _updateConnectionStatus(
      List<ConnectivityResult> connectivityResult) async {
    if (connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.mobile)) {
      connected.value = await reachablility.checkServerReachability();
    }
  }

  // Start a periodic check to see if the server is reachable
  void _startServerReachabilityCheck() {
    _serverCheckTimer?.cancel(); // Cancel any existing timer
    _serverCheckTimer =
        Timer.periodic(const Duration(seconds: 30), (timer) async {
      connected.value = await reachablility.checkServerReachability();
    });
  }
}