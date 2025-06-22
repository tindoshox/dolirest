import 'dart:convert';

import 'package:dolirest/infrastructure/dal/models/company_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/dio_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/dio_safe_request.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/dolibarr_api_error.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/api_path.dart';
import 'package:fpdart/fpdart.dart';

class CompanyRepository extends DioService {
  Future<Either<DolibarrApiError, CompanyModel>> fetchCompany() {
    return dio.safeRequest((token) async {
      final response = await dio.get(ApiPath.company);
      return companyModelFromJson(jsonEncode(response.data));
    });
  }
}
