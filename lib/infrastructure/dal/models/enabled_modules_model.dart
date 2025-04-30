// To parse this JSON data, do
//
//     final enabledModulesModel = enabledModulesModelFromJson(jsonString);

import 'dart:convert';

List<String> enabledModulesModelFromJson(String str) =>
    List<String>.from(json.decode(str).map((x) => x));

String enabledModulesModelToJson(List<String> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x)));
