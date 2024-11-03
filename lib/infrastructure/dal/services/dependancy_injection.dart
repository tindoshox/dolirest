import 'package:dolirest/infrastructure/dal/services/controllers/network_controller.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/api_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/company_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/customer_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/document_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/group_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/invoice_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/product_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/user_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/server_rechablility.dart';
import 'package:get/get.dart';

class DependencyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
    Get.put<StorageController>(StorageController(), permanent: true);
    Get.put<ApiService>(ApiService(), permanent: true);
    Get.put<ServerRechablility>(ServerRechablility(), permanent: true);
    Get.put<CustomerRepository>(CustomerRepository());
    Get.put<InvoiceRepository>(InvoiceRepository());
    Get.put<ProductRepository>(ProductRepository());
    Get.put<GroupRepository>(GroupRepository());
    Get.put<CompanyRepository>(CompanyRepository());
    Get.put<UserRepository>(UserRepository());
    Get.put<DocumentRepository>(DocumentRepository());
  }
}
