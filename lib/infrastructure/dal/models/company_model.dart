// To parse this JSON data, do
//
//     final companyModel = companyModelFromJson(jsonString);

import 'dart:convert';

import 'package:objectbox/objectbox.dart';

CompanyModel companyModelFromJson(String str) =>
    CompanyModel.fromJson(json.decode(str));

String companyModelToJson(CompanyModel data) => json.encode(data.toJson());

@Entity()
class CompanyModel {
  @Id(assignable: true)
  int? id;
  String? name;

  CompanyModel({
    this.id,
    this.name,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
        id: json['id'] = json["id"] is int ? json["id"] : int.parse(json["id"]),
        name: json['name'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
