// To parse this JSON data, do
//
//     final buildReportResponseModel = buildReportResponseModelFromJson(jsonString);

import 'dart:convert';

BuildReportResponseModel buildReportResponseModelFromJson(String str) =>
    BuildReportResponseModel.fromJson(json.decode(str));

String buildReportResponseModelToJson(BuildReportResponseModel data) =>
    json.encode(data.toJson());

class BuildReportResponseModel {
  String filename;
  String contentType;
  int filesize;
  String content;
  String encoding;

  BuildReportResponseModel({
    required this.filename,
    required this.contentType,
    required this.filesize,
    required this.content,
    required this.encoding,
  });

  factory BuildReportResponseModel.fromJson(Map<String, dynamic> json) =>
      BuildReportResponseModel(
        filename: json["filename"],
        contentType: json["content-type"],
        filesize: json["filesize"],
        content: json["content"],
        encoding: json["encoding"],
      );

  Map<String, dynamic> toJson() => {
        "filename": filename,
        "content-type": contentType,
        "filesize": filesize,
        "content": content,
        "encoding": encoding,
      };
}
