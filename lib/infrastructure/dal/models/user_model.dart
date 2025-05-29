// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

import 'package:objectbox/objectbox.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

@Entity()
class UserModel {
  @Id(assignable: true)
  int? id;
  String? lastname;
  String? firstname;
  String? admin;
  String? login;

  UserModel({
    this.id,
    this.lastname,
    this.firstname,
    this.admin,
    this.login,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"] = json["id"] != null ? int.parse(json["id"]) : null,
        lastname: json["lastname"],
        firstname: json["firstname"],
        admin: json["admin"],
        login: json["login"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "lastname": lastname,
        "firstname": firstname,
        "admin": admin,
        "login": login,
      };
}
