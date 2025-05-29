// To parse this JSON data, do
//
//     final paymentModel = paymentModelFromJson(jsonString);

import 'dart:convert';

import 'package:objectbox/objectbox.dart';

List<PaymentModel> paymentModelFromJson(String str) => List<PaymentModel>.from(
    json.decode(str).map((x) => PaymentModel.fromJson(x)));

String paymentModelToJson(List<PaymentModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Entity()
class PaymentModel {
  int id;
  String amount;

  String type;

  DateTime date;

  String? num;

  String? ref;

  String? refExt;

  String? fkBankLine;

  String? invoiceId;

  PaymentModel({
    this.id = 0,
    required this.amount,
    required this.type,
    required this.date,
    this.num,
    this.ref,
    this.refExt,
    this.fkBankLine,
    required this.invoiceId,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
      amount: json["amount"],
      type: json["type"],
      date: json["date"] = DateTime.parse(json["date"]),
      num: json["num"],
      ref: json["ref"],
      refExt: json["ref_ext"],
      fkBankLine: json["fk_bank_line"],
      invoiceId: json["invoiceId"]);

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "type": type,
        "date": date.toLocal(),
        "num": num,
        "ref": ref,
        "ref_ext": refExt,
        "fk_bank_line": fkBankLine,
        "invoiceId": invoiceId
      };
}
