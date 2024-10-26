import 'package:get/get.dart';

import '../../../../presentation/duetoday/controllers/duetoday.controller.dart';

class DuetodayControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DuetodayController>(
      () => DuetodayController(),
    );
  }
}
