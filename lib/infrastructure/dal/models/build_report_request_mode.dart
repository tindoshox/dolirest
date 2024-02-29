// To parse this JSON data, do
//
//     final buildReportRequestModel = buildReportRequestModelFromMap(jsonString);

import 'dart:convert';

BuildReportRequestModel buildReportRequestModelFromMap(String str) =>
    BuildReportRequestModel.fromMap(json.decode(str));

String buildReportRequestModelToMap(BuildReportRequestModel data) =>
    json.encode(data.toMap());

class BuildReportRequestModel {
  String? reportid;
  String? groupid;
  String? salesperson;
  String? fromdate;
  String? todate;

  BuildReportRequestModel({
    this.reportid,
    this.groupid,
    this.salesperson,
    this.fromdate,
    this.todate,
  });

  factory BuildReportRequestModel.fromMap(Map<String, dynamic> json) =>
      BuildReportRequestModel(
        reportid: json["reportid"],
        groupid: json["groupid"],
        salesperson: json["salesperson"],
        fromdate: json["fromdate"],
        todate: json["todate"],
      );

  Map<String, dynamic> toMap() => {
        "reportid": reportid,
        "groupid": groupid,
        "salesperson": salesperson,
        "fromdate": fromdate,
        "todate": todate,
      };
}
