import 'package:get/get.dart';

import '../../../../presentation/reports/controllers/reports_controller.dart';

class ReportsControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportsController>(
      () => ReportsController(),
    );
  }
}
