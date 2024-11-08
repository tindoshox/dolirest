// To parse this JSON data, do
//
//     final reportIdModel = reportIdModelFromJson(jsonString);

import 'dart:convert';

ReportIdModel reportIdModelFromJson(String str) =>
    ReportIdModel.fromJson(json.decode(str));

String reportIdModelToJson(ReportIdModel data) => json.encode(data.toJson());

class ReportIdModel {
  String reportid;
  String displayName;
  bool hasGroupParameter;
  bool hasSalesParameter;
  bool hasFromDateParameter;
  bool hasToDateParameter;
  bool groupIsRequired;

  ReportIdModel({
    this.reportid = '',
    this.displayName = '',
    this.hasGroupParameter = false,
    this.hasSalesParameter = false,
    this.hasFromDateParameter = false,
    this.hasToDateParameter = false,
    this.groupIsRequired = false,
  });

  factory ReportIdModel.fromJson(Map<String, dynamic> json) => ReportIdModel(
      reportid: json["reportid"],
      displayName: json["displayName"],
      hasGroupParameter: json["hasGroupParameter"],
      hasSalesParameter: json["hasSalesParameter"],
      hasFromDateParameter: json["hasFromDateParameter"],
      hasToDateParameter: json["hasToDateParameter"],
      groupIsRequired: json["groupIsRequired"]);

  Map<String, dynamic> toJson() => {
        "reportid": reportid,
        "displayName": displayName,
        "hasGroupParameter": hasGroupParameter,
        "hasSalesParameter": hasSalesParameter,
        "hasFromDateParameter": hasFromDateParameter,
        "hasToDateParameter": hasToDateParameter,
        "groupIsRequired": groupIsRequired,
      };
}
