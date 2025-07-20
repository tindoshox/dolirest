// To parse this JSON data, do
//
//     final settingsModel = settingsModelFromJson(jsonString);

import 'dart:convert';

import 'package:objectbox/objectbox.dart';

SettingsModel settingsModelFromJson(String str) =>
    SettingsModel.fromJson(json.decode(str));

String settingsModelToJson(SettingsModel data) => json.encode(data.toJson());

@Entity()
class SettingsModel {
  @Id(assignable: true)
  int id;
  String name;
  String? strValue;
  List<String>? listValue;

  SettingsModel({
    required this.id,
    required this.name,
    this.strValue,
    this.listValue,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
        id: json['id'],
        name: json['name'] ?? '',
        strValue: json['str_value'],
        listValue: json['list_value'] != null
            ? List<String>.from(json['list_value'].map((x) => x.toString()))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "str_value": strValue,
        "list_value": listValue != null
            ? List<dynamic>.from(listValue!.map((x) => x))
            : null,
      };
}
