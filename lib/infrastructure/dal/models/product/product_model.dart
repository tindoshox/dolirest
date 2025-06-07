// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(
    json.decode(str).map((x) => ProductModel.fromJson(x)));

String productModelToJson(List<ProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
  String? id;
  String? ref;
  String? status;
  int? dateModification;
  String? label;
  String? description;
  String? type;
  String? price;
  String? priceTtc;
  String? pmp;
  String? statusBuy;
  String? finished;
  String? barcode;
  String? fkDefaultWarehouse;
  String? fkPriceExpression;
  String? stockReel;

  ProductModel({
    this.id,
    this.ref,
    this.status,
    this.dateModification,
    this.label,
    this.description,
    this.type,
    this.price,
    this.priceTtc,
    this.pmp,
    this.statusBuy,
    this.finished,
    this.barcode,
    this.fkDefaultWarehouse,
    this.fkPriceExpression,
    this.stockReel,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'],
        ref: json['ref'],
        status: json['status'],
        dateModification: json['date_modification'],
        label: json['label'],
        description: json['description'],
        type: json['type'],
        price: json['price'],
        priceTtc: json['price_ttc'],
        pmp: json['pmp'],
        statusBuy: json['status_buy'],
        finished: json['finished'],
        barcode: json['barcode'],
        fkDefaultWarehouse: json['fk_default_warehouse'],
        fkPriceExpression: json['fk_price_expression'],
        stockReel: json['stock_reel'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'ref': ref,
        'status': status,
        'date_modification': dateModification,
        'label': label,
        'description': description,
        'type': type,
        'price': price,
        'price_ttc': priceTtc,
        'pmp': pmp,
        'status_buy': statusBuy,
        'finished': finished,
        'barcode': barcode,
        'fk_default_warehouse': fkDefaultWarehouse,
        'fk_price_expression': fkPriceExpression,
        'stock_reel': stockReel,
      };
}
