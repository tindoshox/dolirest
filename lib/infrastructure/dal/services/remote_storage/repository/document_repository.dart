import 'package:dolirest/infrastructure/dal/models/build_document_response_model.dart';
import 'package:dolirest/infrastructure/dal/models/build_report_response_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/api_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/catch_exception.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/error/failure.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/api_path.dart';
import 'package:fpdart/fpdart.dart';

class DocumentRepository extends ApiService {
//Build Document
  Future<Either<Failure, BuildDucumentResponseModel>> buildDocument(
      String body) async {
    try {
      var response = await httpClient.put(
        ApiPath.buildDocument,
        body: body,
      );
      if (response.statusCode == 200) {
        return right(
          buildDucumentResponseModelFromJson(response.bodyString!),
        );
      } else {
        return left(Failure(response.statusText!));
      }
    } on Exception catch (e) {
      return left(failure(e));
    }
  }

  //Build Report
  Future<Either<Failure, BuildReportResponseModel>> buildReport(
      String body) async {
    try {
      var response = await httpClient.put(
        ApiPath.buildReport,
        body: body,
      );
      if (response.statusCode == 200) {
        return right(
          buildReportResponseModelFromJson(response.bodyString!),
        );
      } else {
        return left(Failure(response.statusText!));
      }
    } on Exception catch (e) {
      return left(failure(e));
    }
  }
}
