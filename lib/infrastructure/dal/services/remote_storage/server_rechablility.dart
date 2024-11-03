import 'package:dolirest/infrastructure/dal/services/remote_storage/api_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/api_path.dart';

class ServerRechablility extends ApiService {
  // Actual HTTP request to check server reachability
  Future<bool> checkServerReachability() async {
    try {
      final response = await httpClient.get(
        ApiPath.status,
      );

      return response.statusCode == 200 || response.statusCode == 401;
    } catch (e) {
      return false;
    }
  }
}
