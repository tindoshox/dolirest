// To parse this JSON data, do
//
//     final creditAvailableModel = creditAvailableModelFromJson(jsonString);

import 'dart:convert';

CreditAvailableModel creditAvailableModelFromJson(String str) =>
    CreditAvailableModel.fromJson(json.decode(str));

String creditAvailableModelToJson(CreditAvailableModel data) =>
    json.encode(data.toJson());

class CreditAvailableModel {
  int? id;
  int? fkFacture;
  int? fkFactureSource;

  CreditAvailableModel({
    this.id,
    this.fkFacture,
    this.fkFactureSource,
  });

  factory CreditAvailableModel.fromJson(Map<String, dynamic> json) =>
      CreditAvailableModel(
        id: json["id"] =
            json["id"] is int ? json["id"] : int.tryParse(json["id"]),
        fkFacture: json["fk_facture"] = json["fk_facture"] is int
            ? json["fk_facture"]
            : int.tryParse(json["fk_facture"]),
        fkFactureSource: json["fk_facture_source"] =
            json["fk_facture_source"] is int
                ? json["fk_facture_source"]
                : int.tryParse(json["fk_facture_source"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fk_facture": fkFacture,
        "fk_facture_source": fkFactureSource,
      };
}
