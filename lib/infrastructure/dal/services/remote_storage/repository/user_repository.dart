import 'package:dolirest/infrastructure/dal/models/user_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/api_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/catch_exception.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/failure.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/api_path.dart';
import 'package:fpdart/fpdart.dart';

class UserRepository extends ApiService {
  /// Fetch User Info
  Future<Either<Failure, UserModel>> login() async {
    try {
      var response = await httpClient.get(
        ApiPath.users,
        decoder: (data) => userModelFromJson(data),
      );
      if (response.statusCode == 200) {
        return right(
          (response.body!),
        );
      } else {
        return left(Failure(response.statusText!));
      }
    } on Exception catch (e) {
      return left(failure(e));
    }
  }
}
