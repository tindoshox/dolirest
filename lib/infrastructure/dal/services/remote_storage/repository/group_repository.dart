import 'package:dolirest/infrastructure/dal/models/group_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/dio_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/error_handler.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/failure.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/api_path.dart';
import 'package:fpdart/fpdart.dart';

class GroupRepository extends DioService {
  Future<Either<Failure, List<GroupModel>>> fetchGroups() async {
    final queryParameters = {
      "sortfield": "nom",
      "sortorder": "ASC",
      "sqlfilters": "(t.active:=:1)",
    };
    try {
      var response =
          await dio.get(ApiPath.groups, queryParameters: queryParameters);

      if (response.statusCode == 200) {
        List<dynamic> l = response.data;
        return right(l
            .map((g) => GroupModel.fromJson(g as Map<String, dynamic>))
            .toList());
      } else {
        return left(Failure(response.statusCode!, response.statusMessage!));
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
