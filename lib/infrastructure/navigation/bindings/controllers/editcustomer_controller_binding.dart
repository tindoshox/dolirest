import 'package:get/get.dart';

import '../../../../presentation/editcustomer/controllers/editcustomer_controller.dart';

class EditCustomerControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditCustomerController>(
      () => EditCustomerController(),
    );
  }
}
