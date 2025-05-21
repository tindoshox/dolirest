// ignore_for_file: unused_import

import 'dart:developer';

import 'package:dolirest/infrastructure/dal/models/build_document_response_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/dio_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/error_handler.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/failure.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/api_path.dart';

import 'package:fpdart/fpdart.dart';

class DocumentRepository extends DioService {
//Build Document
  Future<Either<Failure, BuildDucumentResponseModel>> buildDocument(
      String body) async {
    try {
      var response = await dio.put(
        ApiPath.buildDocument,
        data: body,
      );

      return right(BuildDucumentResponseModel.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  //Build Report
  Future<Either<Failure, BuildDucumentResponseModel>> buildReport(
      String body) async {
    try {
      var response = await dio.put(
        ApiPath.buildReport,
        data: body,
      );
      return right(BuildDucumentResponseModel.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  //Build custom statement
//Build Document
  Future<Either<Failure, BuildDucumentResponseModel>> buildStatement(
      String body) async {
    log(body);
    try {
      var response = await dio.put(
        ApiPath.statment,
        data: body,
      );

      return right(BuildDucumentResponseModel.fromJson(response.data));
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
