import 'package:dolirest/infrastructure/dal/services/controllers/auth_service.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/data_refresh_service.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/network_service.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/dio_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/company_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/customer_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/document_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/group_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/invoice_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/module_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/product_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/user_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/server_reachablility.dart';
import 'package:get/get.dart';

class DependencyInjection {
  static Future<void> init() async {
    final storageService = await StorageService.create();

    Get.put<StorageService>(storageService, permanent: true);
    Get.put<AuthService>(AuthService(), permanent: true);

    Get.put(DioService(), permanent: true);
    Get.put<NetworkService>(NetworkService(), permanent: true);
    Get.put<ServerReachability>(ServerReachability(), permanent: true);
    Get.put<CustomerRepository>(CustomerRepository(), permanent: true);
    Get.put<InvoiceRepository>(InvoiceRepository(), permanent: true);
    Get.put<ProductRepository>(ProductRepository(), permanent: true);
    Get.put<GroupRepository>(GroupRepository(), permanent: true);
    Get.put<CompanyRepository>(CompanyRepository(), permanent: true);
    Get.put<UserRepository>(UserRepository(), permanent: true);
    Get.put<DocumentRepository>(DocumentRepository(), permanent: true);
    Get.put<ModuleRepository>(ModuleRepository(), permanent: true);
    Get.put<DataRefreshService>(DataRefreshService(), permanent: true);
  }
}
