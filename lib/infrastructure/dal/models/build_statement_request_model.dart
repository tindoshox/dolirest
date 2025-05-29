// To parse this JSON data, do
//
//     final buildStatementRequestModel = buildStatementRequestModelFromJson(jsonString);

import 'dart:convert';

BuildStatementRequestModel buildStatementRequestModelFromJson(String str) =>
    BuildStatementRequestModel.fromJson(json.decode(str));

String buildStatementRequestModelToJson(BuildStatementRequestModel data) =>
    json.encode(data.toJson());

class BuildStatementRequestModel {
  int socid;
  DateTime startdate;
  DateTime enddate;

  BuildStatementRequestModel({
    required this.socid,
    required this.startdate,
    required this.enddate,
  });

  factory BuildStatementRequestModel.fromJson(Map<String, dynamic> json) =>
      BuildStatementRequestModel(
        socid: json["socid"],
        startdate: DateTime.parse(json["startdate"]),
        enddate: DateTime.parse(json["enddate"]),
      );

  Map<String, dynamic> toJson() => {
        "socid": socid,
        "startdate":
            "${startdate.year.toString().padLeft(4, '0')}-${startdate.month.toString().padLeft(2, '0')}-${startdate.day.toString().padLeft(2, '0')}",
        "enddate":
            "${enddate.year.toString().padLeft(4, '0')}-${enddate.month.toString().padLeft(2, '0')}-${enddate.day.toString().padLeft(2, '0')}",
      };
}
