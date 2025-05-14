// ignore_for_file: unused_import

import 'dart:developer';

import 'package:dolirest/infrastructure/dal/models/user_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/dio_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/error_handler.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/failure.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/api_path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class UserRepository extends DioService {
  /// Fetch User Info
  Future<Either<Failure, UserModel>> login(
      {String? url, String? apiKey}) async {
    if (url != null && apiKey != null) {
      dio.options.baseUrl = '$url$apiStub';
      final auth = {'DOLAPIKEY': apiKey};
      dio.options.headers.addAll(auth);
    }
    try {
      var response = await dio.get(
        ApiPath.users,
      );

      return right(
        UserModel.fromJson(response.data),
      );
    } catch (error) {
      if (kDebugMode) {
        log(error.toString());
      }
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
