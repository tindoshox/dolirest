import 'package:get/get.dart';

import '../../../../presentation/createinvoice/controllers/create_invoice_controller.dart';

class CreateinvoiceControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateinvoiceController>(
      () => CreateinvoiceController(),
    );
  }
}
