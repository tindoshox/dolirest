// To parse this JSON data, do
//
//     final paymentModel = paymentModelFromJson(jsonString);

import 'package:hive/hive.dart';
import 'dart:convert';

part 'payment_model.g.dart';

List<PaymentModel> paymentModelFromJson(String str) => List<PaymentModel>.from(
    json.decode(str).map((x) => PaymentModel.fromJson(x)));

String paymentModelToJson(List<PaymentModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@HiveType(typeId: 4)
class PaymentModel {
  @HiveField(1)
  dynamic amount;
  @HiveField(2)
  dynamic type;
  @HiveField(3)
  DateTime? date;
  @HiveField(4)
  dynamic num;
  @HiveField(5)
  dynamic ref;
  @HiveField(6)
  dynamic refExt;
  @HiveField(7)
  dynamic fkBankLine;

  PaymentModel({
    this.amount,
    this.type,
    this.date,
    this.num,
    this.ref,
    this.refExt,
    this.fkBankLine,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        amount: json["amount"],
        type: json["type"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        num: json["num"],
        ref: json["ref"],
        refExt: json["ref_ext"],
        fkBankLine: json["fk_bank_line"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "type": type,
        "date": date?.toIso8601String(),
        "num": num,
        "ref": ref,
        "ref_ext": refExt,
        "fk_bank_line": fkBankLine,
      };
}
