import 'package:dolirest/infrastructure/dal/services/controllers/network_controller.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/dio_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/company_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/customer_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/document_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/group_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/invoice_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/product_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/user_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/server_reachablility.dart';
import 'package:get/get.dart';

class DependencyInjection {
  static void init() {
    Get.put<StorageService>(StorageService(), permanent: true);
    Get.put<NetworkController>(NetworkController(), permanent: true);
    Get.put(DioService());
    Get.put<ServerReachablility>(ServerReachablility(), permanent: true);
    Get.put<CustomerRepository>(CustomerRepository());
    Get.put<InvoiceRepository>(InvoiceRepository());
    Get.put<ProductRepository>(ProductRepository());
    Get.put<GroupRepository>(GroupRepository());
    Get.put<CompanyRepository>(CompanyRepository());
    Get.put<UserRepository>(UserRepository());
    Get.put<DocumentRepository>(DocumentRepository());
  }
}
