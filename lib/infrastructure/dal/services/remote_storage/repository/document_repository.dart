// ignore_for_file: unused_import

import 'dart:developer';

import 'package:dolirest/infrastructure/dal/models/build_document_response_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/dio_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/dio_safe_request.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/dolibarr_api_error.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/api_path.dart';

import 'package:fpdart/fpdart.dart';

class DocumentRepository extends DioService {
  Future<Either<DolibarrApiError, BuildDucumentResponseModel>> buildDocument(
          String body) =>
      _build(ApiPath.buildDocument, body);

  Future<Either<DolibarrApiError, BuildDucumentResponseModel>> buildReport(
          String body) =>
      _build(ApiPath.buildReport, body);

  Future<Either<DolibarrApiError, BuildDucumentResponseModel>> buildStatement(
          String body) =>
      _build(ApiPath.statment, body);

  Future<Either<DolibarrApiError, BuildDucumentResponseModel>> _build(
      String url, String body) {
    return dio.safeRequest(() async {
      final response = await dio.put(url, data: body);
      return BuildDucumentResponseModel.fromJson(response.data);
    });
  }
}
