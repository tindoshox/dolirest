import 'package:get/get.dart';

import '../../../../presentation/customerdetail/controllers/customer_detail_controller.dart';

class CustomerdetailControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerDetailController>(
      () => CustomerDetailController(),
    );
  }
}
