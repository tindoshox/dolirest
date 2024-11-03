import 'package:dolirest/infrastructure/dal/models/group_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/api_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/catch_exception.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/failure.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/api_path.dart';
import 'package:fpdart/fpdart.dart';

class GroupRepository extends ApiService {
  Future<Either<Failure, List<GroupModel>>> fetchGroups() async {
    final queryParameters = {
      "sortfield": "nom",
      "sortorder": "ASC",
      "sqlfilters": "(t.active:=:1)",
    };
    try {
      var response = await httpClient
          .get(ApiPath.groups, query: queryParameters, decoder: (data) {
        List<dynamic> l = data;
        return l
            .map((g) => GroupModel.fromJson(g as Map<String, dynamic>))
            .toList();
      });

      if (response.statusCode == 200) {
        // String jsonString = response.bodyString!;
        // List<dynamic> jsonList = json.decode(jsonString);
        // List<GroupModel> groups = List.empty();
        // if (jsonList.isNotEmpty) {
        //   groups = jsonList
        //       .map((jsonItem) =>
        //           GroupModel.fromJson(jsonItem as Map<String, dynamic>))
        //       .toList();
        // }

        return right(response.body!);
      } else {
        return left(Failure(response.statusText!));
      }
    } on Exception catch (e) {
      return left(failure(e));
    }
  }
}
