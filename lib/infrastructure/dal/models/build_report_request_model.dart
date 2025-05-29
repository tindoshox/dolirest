// To parse this JSON data, do
//
//     final buildReportRequestModel = buildReportRequestModelFromJson(jsonString);

import 'dart:convert';

BuildReportRequestModel buildReportRequestModelFromJson(String str) =>
    BuildReportRequestModel.fromJson(json.decode(str));

String buildReportRequestModelToJson(BuildReportRequestModel data) =>
    json.encode(data.toJson());

class BuildReportRequestModel {
  String? reportid;
  String? groupid;
  String? salesperson;
  String? startdate;
  String? enddate;
  String? startperiod;
  String? endperiod;
  String? startreceipt;
  String? endreceipt;

  BuildReportRequestModel({
    this.reportid,
    this.groupid,
    this.salesperson,
    this.startdate,
    this.enddate,
    this.startperiod,
    this.endperiod,
    this.startreceipt,
    this.endreceipt,
  });

  factory BuildReportRequestModel.fromJson(Map<String, dynamic> json) =>
      BuildReportRequestModel(
        reportid: json["reportid"] as String?,
        groupid: json["groupid"] as String?,
        salesperson: json["salesperson"] as String?,
        startdate: json["startdate"] as String?,
        enddate: json["enddate"] as String?,
        startperiod: json["startperiod"] as String?,
        endperiod: json["endperiod"] as String?,
        startreceipt: json["startreceipt"] as String?,
        endreceipt: json["endreceipt"] as String?,
      );

  Map<String, dynamic> toJson() => {
        "reportid": reportid,
        "groupid": groupid,
        "salesperson": salesperson,
        "startdate": startdate,
        "enddate": enddate,
        "startperiod": startperiod,
        "endperiod": endperiod,
        "startreceipt": startreceipt,
        "endreceipt": endreceipt,
      };
}
