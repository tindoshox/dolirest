import 'package:get/get.dart';

import '../../../../presentation/customerlist/controllers/customer_list_controller.dart';

class CustomerlistControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerListController>(
      () => CustomerListController(),
    );
  }
}
