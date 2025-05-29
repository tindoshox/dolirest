// To parse this JSON data, do
//
//     final thirdPartyModel = thirdPartyModelFromJson(jsonString);

import 'dart:convert';

List<CustomerModel> listCustomerModelFromJson(String str) =>
    List<CustomerModel>.from(
        json.decode(str).map((x) => CustomerModel.fromJson(x)));

String listCustomerModelToJson(List<CustomerModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

CustomerModel customerModelFromJson(String str) =>
    CustomerModel.fromJson(json.decode(str));

String customerModelToJson(CustomerModel data) => json.encode(data.toJson());

class CustomerModel {
  String? id;
  String? stateId;
  String? regionId;
  String? name;
  int? dateModification;
  String? phone;
  String? fax;
  String? codeClient;
  String? address;
  String? town;
  String? client;
  CustomerModel({
    this.id,
    this.stateId,
    this.regionId,
    this.name,
    this.dateModification,
    this.phone,
    this.fax,
    this.codeClient,
    this.address,
    this.town,
    this.client,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        id: json["id"],
        stateId: json["state_id"] = json["state_id"] is int
            ? json["state_id"]
            : int.parse(json["state_id"]),
        regionId: json["region_id"] = json["region_id"] is int
            ? json["region_id"]
            : int.parse(json["region_id"]),
        name: json["name"],
        dateModification: json["date_modification"],
        phone: json["phone"],
        fax: json["fax"],
        codeClient: json["code_client"],
        address: json["address"],
        town: json["town"],
        client: json["client"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "state_id": stateId,
        "region_id": regionId,
        "name": name,
        "date_modification": dateModification,
        "phone": phone,
        "fax": fax,
        "code_client": codeClient,
        "address": address,
        "town": town,
        "client": client,
      };
}
