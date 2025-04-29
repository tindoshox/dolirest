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
  bool hasGroupParam;
  bool hasSalesParam;
  bool hasStartDateParam;
  bool hasEndDateParam;
  bool groupIsRequired;
  bool hasStartPeriodParam;
  bool hasEndPeriodParam;
  bool hasWarehouseParam;
  bool hasStartReceiptParam;
  bool hasEndReceiptParam;

  ReportIdModel({
    this.reportid = '',
    this.displayName = '',
    this.hasGroupParam = false,
    this.hasSalesParam = false,
    this.hasStartDateParam = false,
    this.hasEndDateParam = false,
    this.groupIsRequired = false,
    this.hasEndPeriodParam = false,
    this.hasEndReceiptParam = false,
    this.hasStartPeriodParam = false,
    this.hasStartReceiptParam = false,
    this.hasWarehouseParam = false,
  });

  factory ReportIdModel.fromJson(Map<String, dynamic> json) => ReportIdModel(
        reportid: json['reportid'],
        displayName: json['displayName'],
        hasGroupParam: json['hasGroupParam'],
        hasSalesParam: json['hasSalesParam'],
        hasStartDateParam: json['hasEndDateParam'],
        hasEndDateParam: json['hasStartDateParam'],
        groupIsRequired: json['groupIsRequired'],
        hasStartPeriodParam: json['hasStartPeriodParam'],
        hasEndPeriodParam: json['hasEndPeriodParam'],
        hasWarehouseParam: json['hasWarehouseParam'],
        hasStartReceiptParam: json['hasStartReceiptParam'],
        hasEndReceiptParam: json['hasEndReceiptParam'],
      );

  Map<String, dynamic> toJson() => {
        "reportid": reportid,
        "displayName": displayName,
        "hasGroupParam": hasGroupParam,
        "hasStartDateParam": hasStartDateParam,
        "hasEndDateParam": hasEndDateParam,
        "groupIsRequired": groupIsRequired,
        "hasStartPeriodParam": hasStartPeriodParam,
        "hasEndPeriodParam": hasEndPeriodParam,
        "hasWarehouseParam": hasWarehouseParam,
        "hasStartReceiptParam": hasStartReceiptParam,
        "hasEndReceiptParam": hasEndReceiptParam,
      };
}
