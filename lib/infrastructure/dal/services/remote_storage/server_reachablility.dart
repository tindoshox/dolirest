import 'package:dolirest/infrastructure/dal/services/remote_storage/dio_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/error_handler.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/api_path.dart';

class ServerReachability extends DioService {
  // Actual HTTP request to check server reachability
  Future<bool> checkServerReachability() async {
    try {
      final response = await dio.get(
        ApiPath.status,
      );

      return response.statusCode == 200 || response.statusCode == 401;
    } catch (e) {
      ErrorHandler.handle(e);
      return false;
    }
  }
}
