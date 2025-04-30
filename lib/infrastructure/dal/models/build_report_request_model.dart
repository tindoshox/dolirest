// To parse this JSON data, do
//
//     final buildReportRequestModel = buildReportRequestModelFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'build_report_request_model.g.dart';

BuildReportRequestModel buildReportRequestModelFromJson(String str) =>
    BuildReportRequestModel.fromJson(json.decode(str));

String buildReportRequestModelToJson(BuildReportRequestModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class BuildReportRequestModel {
  @JsonKey(name: "reportid")
  String? reportid;
  @JsonKey(name: "groupid")
  String? groupid;
  @JsonKey(name: "salesperson")
  String? salesperson;
  @JsonKey(name: "startdate")
  String? startdate;
  @JsonKey(name: "enddate")
  String? enddate;
  @JsonKey(name: "startperiod")
  String? startperiod;
  @JsonKey(name: "endperiod")
  String? endperiod;
  @JsonKey(name: "startreceipt")
  String? startreceipt;
  @JsonKey(name: "endreceipt")
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
      _$BuildReportRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$BuildReportRequestModelToJson(this);
}
