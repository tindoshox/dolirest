import 'package:get/get.dart';

import '../../../../presentation/invoicedetail/controllers/invoice_detail_controller.dart';

class InvoicedetailControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvoiceDetailController>(
      () => InvoiceDetailController(),
    );
  }
}
