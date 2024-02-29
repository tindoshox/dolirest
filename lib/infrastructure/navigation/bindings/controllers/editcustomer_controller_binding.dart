import 'package:get/get.dart';

import '../../../../presentation/editcustomer/controllers/editcustomer_controller.dart';

class EditcustomerControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditcustomerController>(
      () => EditcustomerController(),
    );
  }
}
