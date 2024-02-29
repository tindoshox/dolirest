// To parse this JSON data, do
//
//     final payment = paymentFromMap(jsonString);

import 'dart:convert';

List<Payment> paymentFromMap(String str) => List<Payment>.from(json.decode(str).map((x) => Payment.fromMap(x)));

String paymentToMap(List<Payment> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Payment {
    Payment({
        this.amount,
        this.type,
        this.date,
        this.num,
        this.ref,
        this.refExt,
    });

    dynamic amount;
    dynamic type;
    dynamic date;
    dynamic num;
    dynamic ref;
    dynamic refExt;

    factory Payment.fromMap(Map<String, dynamic> json) => Payment(
        amount: json["amount"],
        type: json["type"],
        date: DateTime.parse(json["date"]),
        num: json["num"],
        ref: json["ref"],
        refExt: json["ref_ext"],
    );

    Map<String, dynamic> toMap() => {
        "amount": amount,
        "type": type,
        "date": date.toIso8601String(),
        "num": num,
        "ref": ref,
        "ref_ext": refExt,
    };
}
