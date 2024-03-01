// To parse this JSON data, do
//
//     final buildDucumentResponseModel = buildDucumentResponseModelFromJson(jsonString);

import 'dart:convert';

BuildDucumentResponseModel buildDucumentResponseModelFromJson(String str) =>
    BuildDucumentResponseModel.fromJson(json.decode(str));

String buildDucumentResponseModelToJson(BuildDucumentResponseModel data) =>
    json.encode(data.toJson());

class BuildDucumentResponseModel {
  String filename;
  String contentType;
  int filesize;
  String content;
  String? langcode;
  String? template;
  String? encoding;

  BuildDucumentResponseModel({
    required this.filename,
    required this.contentType,
    required this.filesize,
    required this.content,
    this.langcode = "",
    this.template = "",
    this.encoding = "base64",
  });

  factory BuildDucumentResponseModel.fromJson(Map<String, dynamic> json) =>
      BuildDucumentResponseModel(
        filename: json["filename"],
        contentType: json["content-type"],
        filesize: json["filesize"],
        content: json["content"],
        langcode: json["langcode"],
        template: json["template"],
        encoding: json["encoding"],
      );

  Map<String, dynamic> toJson() => {
        "filename": filename,
        "content-type": contentType,
        "filesize": filesize,
        "content": content,
        "langcode": langcode,
        "template": template,
        "encoding": encoding,
      };
}
