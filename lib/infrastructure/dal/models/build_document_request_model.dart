import 'dart:convert';

class BuildDocumentRequestModel {
  String modulepart;
  String originalFile;
  String? doctemplate;
  String? langcode;

  BuildDocumentRequestModel({
    required this.modulepart,
    required this.originalFile,
    this.doctemplate = "",
    this.langcode = "",
  });

  factory BuildDocumentRequestModel.fromRawJson(String str) =>
      BuildDocumentRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BuildDocumentRequestModel.fromJson(Map<String, dynamic> json) =>
      BuildDocumentRequestModel(
        modulepart: json["modulepart"],
        originalFile: json["original_file"],
        doctemplate: json["doctemplate"],
        langcode: json["langcode"],
      );

  Map<String, dynamic> toJson() => {
        "modulepart": modulepart,
        "original_file": originalFile,
        "doctemplate": doctemplate,
        "langcode": langcode,
      };
}
