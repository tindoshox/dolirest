// To parse this JSON data, do
//
//     final creditAvailableModel = creditAvailableModelFromJson(jsonString);

import 'dart:convert';

CreditAvailableModel creditAvailableModelFromJson(String str) =>
    CreditAvailableModel.fromJson(json.decode(str));

String creditAvailableModelToJson(CreditAvailableModel data) =>
    json.encode(data.toJson());

class CreditAvailableModel {
  String? id;
  String? fkFacture;
  String? fkFactureSource;

  CreditAvailableModel({
    this.id,
    this.fkFacture,
    this.fkFactureSource,
  });

  factory CreditAvailableModel.fromJson(Map<String, dynamic> json) =>
      CreditAvailableModel(
        id: json["id"],
        fkFacture: json["fk_facture"],
        fkFactureSource: json["fk_facture_source"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fk_facture": fkFacture,
        "fk_facture_source": fkFactureSource,
      };
}
