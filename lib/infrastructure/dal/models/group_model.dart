// To parse this JSON data, do
//
//     final groupModel = groupModelFromMap(jsonString);

import 'dart:convert';

List<GroupModel> groupModelFromMap(String str) =>
    List<GroupModel>.from(json.decode(str).map((x) => GroupModel.fromMap(x)));

String groupModelToMap(List<GroupModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class GroupModel {
  String? id;
  dynamic rowid;
  String? codeDepartement;
  String? code;
  String? name;
  String? nom;
  dynamic label;
  String? active;

  GroupModel({
    this.id,
    this.rowid,
    this.codeDepartement,
    this.code,
    this.name,
    this.nom,
    this.label,
    this.active,
  });

  factory GroupModel.fromMap(Map<String, dynamic> json) => GroupModel(
        id: json["id"],
        rowid: json["rowid"],
        codeDepartement: json["code_departement"],
        code: json["code"],
        name: json["name"],
        nom: json["nom"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "rowid": rowid,
        "code_departement": codeDepartement,
        "code": code,
        "name": name,
        "nom": nom,
        "label": label,
        "active": active,
      };
}
