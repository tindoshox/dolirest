// ignore_for_file: unused_import

import 'dart:developer';

import 'package:dolirest/infrastructure/dal/models/user_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/dio_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/dio_safe_request.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/dolibarr_api_error.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/api_path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class UserRepository extends DioService {
  /// Fetch User Info
  Future<Either<DolibarrApiError, UserModel>> login(
      {String? url, String? token}) async {
    if (url != null && token != null) {
      dio.options.baseUrl = '$url$apiStub';
      final auth = {'DOLAPIKEY': token};
      dio.options.headers.addAll(auth);
    }
    return dio.safeRequest((token) async {
      final response = await dio.get(
        ApiPath.users,
      );
      return UserModel.fromJson(response.data);
    });
  }
}
