// To parse this JSON data, do
//
//     final documenListModel = documenListModelFromJson(jsonString);

import 'dart:convert';

List<DocumentListModel> documenListModelFromJson(String str) =>
    List<DocumentListModel>.from(
        json.decode(str).map((x) => DocumentListModel.fromJson(x)));

String documenListModelToJson(List<DocumentListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DocumentListModel {
  String name;
  String path;
  String level1Name;
  String relativename;
  String fullname;
  int date;
  int size;
  String type;
  String label;
  String entity;
  String filename;
  String filepath;
  String fullpathOrig;
  String description;
  String keywords;
  dynamic cover;
  String position;
  String genOrUploaded;
  dynamic extraparams;
  int dateC;
  int dateM;
  dynamic fkUserC;
  dynamic fkUserM;
  dynamic acl;
  String srcObjectType;
  String srcObjectId;
  String id;
  String ref;
  String share;

  DocumentListModel({
    required this.name,
    required this.path,
    required this.level1Name,
    required this.relativename,
    required this.fullname,
    required this.date,
    required this.size,
    required this.type,
    required this.label,
    required this.entity,
    required this.filename,
    required this.filepath,
    required this.fullpathOrig,
    required this.description,
    required this.keywords,
    required this.cover,
    required this.position,
    required this.genOrUploaded,
    required this.extraparams,
    required this.dateC,
    required this.dateM,
    required this.fkUserC,
    this.fkUserM,
    required this.acl,
    required this.srcObjectType,
    required this.srcObjectId,
    required this.id,
    required this.ref,
    required this.share,
  });

  factory DocumentListModel.fromJson(Map<String, dynamic> json) =>
      DocumentListModel(
        name: json["name"],
        path: json["path"],
        level1Name: json["level1name"],
        relativename: json["relativename"],
        fullname: json["fullname"],
        date: json["date"],
        size: json["size"],
        type: json["type"],
        label: json["label"],
        entity: json["entity"],
        filename: json["filename"],
        filepath: json["filepath"],
        fullpathOrig: json["fullpath_orig"],
        description: json["description"],
        keywords: json["keywords"],
        cover: json["cover"],
        position: json["position"],
        genOrUploaded: json["gen_or_uploaded"],
        extraparams: json["extraparams"],
        dateC: json["date_c"],
        dateM: json["date_m"],
        fkUserC: json["fk_user_c"],
        fkUserM: json["fk_user_m"],
        acl: json["acl"],
        srcObjectType: json["src_object_type"],
        srcObjectId: json["src_object_id"],
        id: json["id"],
        ref: json["ref"],
        share: json["share"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "path": path,
        "level1name": level1Name,
        "relativename": relativename,
        "fullname": fullname,
        "date": date,
        "size": size,
        "type": type,
        "label": label,
        "entity": entity,
        "filename": filename,
        "filepath": filepath,
        "fullpath_orig": fullpathOrig,
        "description": description,
        "keywords": keywords,
        "cover": cover,
        "position": position,
        "gen_or_uploaded": genOrUploaded,
        "extraparams": extraparams,
        "date_c": dateC,
        "date_m": dateM,
        "fk_user_c": fkUserC,
        "fk_user_m": fkUserM,
        "acl": acl,
        "src_object_type": srcObjectType,
        "src_object_id": srcObjectId,
        "id": id,
        "ref": ref,
        "share": share,
      };
}
