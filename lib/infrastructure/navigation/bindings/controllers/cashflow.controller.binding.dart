import 'package:get/get.dart';

import '../../../../presentation/cashflow/controllers/collections_controller.dart';

class CashflowControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CashflowController>(
      () => CashflowController(),
    );
  }
}
