import 'package:get/get.dart';

import '../../../../presentation/invoicelist/controllers/invoicelist_controller.dart';

class InvoicelistControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvoicelistController>(
      () => InvoicelistController(),
    );
  }
}
