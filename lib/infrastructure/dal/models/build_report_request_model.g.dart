// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'build_report_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BuildReportRequestModel _$BuildReportRequestModelFromJson(
        Map<String, dynamic> json) =>
    BuildReportRequestModel(
      reportid: json['reportid'] as String?,
      groupid: json['groupid'] as String?,
      salesperson: json['salesperson'] as String?,
      startdate: json['startdate'] as String?,
      enddate: json['enddate'] as String?,
      startperiod: json['startperiod'] as String?,
      endperiod: json['endperiod'] as String?,
      startreceipt: json['startreceipt'] as String?,
      endreceipt: json['endreceipt'] as String?,
    );

Map<String, dynamic> _$BuildReportRequestModelToJson(
        BuildReportRequestModel instance) =>
    <String, dynamic>{
      'reportid': instance.reportid,
      'groupid': instance.groupid,
      'salesperson': instance.salesperson,
      'startdate': instance.startdate,
      'enddate': instance.enddate,
      'startperiod': instance.startperiod,
      'endperiod': instance.endperiod,
      'startreceipt': instance.startreceipt,
      'endreceipt': instance.endreceipt,
    };
