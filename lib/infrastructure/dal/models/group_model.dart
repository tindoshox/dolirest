// To parse this JSON data, do
//
//     final groupModel = groupModelFromJson(jsonString);

import 'dart:convert';

import 'package:objectbox/objectbox.dart';

GroupModel groupModelFromJson(String str) =>
    GroupModel.fromJson(json.decode(str));

String groupModelToJson(GroupModel data) => json.encode(data.toJson());

@Entity()
class GroupModel {
  @Id(assignable: true)
  int id = 0;
  String? groupId;
  String? name;
  String? value;
  int? codeDepartement;
  String? code;
  String? label;
  String? active;

  GroupModel({
    this.groupId,
    this.name,
    this.value,
    this.codeDepartement,
    this.code,
    this.label,
    this.active,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
        groupId: json["id"],
        name: json["name"],
        value: json["value"],
        codeDepartement: json["code_departement"] =
            json["code_departement"] is int
                ? json["code_departement"]
                : int.parse(json["code_departement"]),
        code: json["code"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "value": value,
        "code_departement": codeDepartement,
        "code": code,
        "label": label,
        "active": active,
      };
}
