// To parse this JSON data, do
//
//     final groupModel = groupModelFromJson(jsonString);

import 'package:hive/hive.dart';
import 'dart:convert';

part 'group_model.g.dart';

GroupModel groupModelFromJson(String str) =>
    GroupModel.fromJson(json.decode(str));

String groupModelToJson(GroupModel data) => json.encode(data.toJson());

@HiveType(typeId: 6)
class GroupModel {
  @HiveField(1)
  dynamic id;
  @HiveField(2)
  dynamic rowid;
  @HiveField(3)
  dynamic codeDepartement;
  @HiveField(4)
  dynamic code;
  @HiveField(5)
  dynamic name;
  @HiveField(6)
  dynamic nom;
  @HiveField(7)
  dynamic label;
  @HiveField(8)
  dynamic active;

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

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
        id: json["id"],
        rowid: json["rowid"],
        codeDepartement: json["code_departement"],
        code: json["code"],
        name: json["name"],
        nom: json["nom"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
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
