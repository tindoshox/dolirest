import 'dart:async';
import 'dart:io';

import 'package:dolirest/infrastructure/dal/services/remote_storage/error/failure.dart';

Failure failure(Exception e) {
  switch (e) {
    case TimeoutException():
      return Failure("Timeout error");
    case SocketException():
      return Failure("Unable to connect to server");
    case HttpException():
      return Failure(e.message);
    default:
      return Failure('Uknown Error');
  }
}
