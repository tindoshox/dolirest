import 'package:dolirest/infrastructure/dal/models/company_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/dio_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/error_handler.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/failure.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/api_path.dart';
import 'package:fpdart/fpdart.dart';

class CompanyRepository extends DioService {
  Future<Either<Failure, CompanyModel>> fetchCompany() async {
    try {
      final response = await dio.get(
        ApiPath.company,
      );
      if (response.statusCode == 200) {
        return right(CompanyModel.fromJson(response.data));
      } else {
        return left(Failure(response.statusCode!, response.statusMessage!));
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}