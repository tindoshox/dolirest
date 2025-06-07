import 'package:dolirest/infrastructure/dal/models/group/group_entity.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/dio_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/dio_safe_request.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/dolibarr_api_error.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/api_path.dart';
import 'package:fpdart/fpdart.dart';

class GroupRepository extends DioService {
  Future<Either<DolibarrApiError, List<GroupEntity>>> fetchGroups() {
    final queryParameters = {
      "sortfield": "nom",
      "sortorder": "ASC",
      "sqlfilters": "(t.active:=:1)",
    };

    return dio.safeRequest(() async {
      final response = await dio.get(
        ApiPath.groups,
        queryParameters: queryParameters,
      );

      return parseGroupsFromJson(response.data);
    });
  }
}
