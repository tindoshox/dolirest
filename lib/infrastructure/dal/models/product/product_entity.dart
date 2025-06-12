import 'package:objectbox/objectbox.dart';

@Entity()
class ProductEntity {
  @Id(assignable: true)
  int id = 0;
  @Unique(onConflict: ConflictStrategy.replace)
  String? productId;
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

  ProductEntity({
    this.productId,
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
}

List<ProductEntity> productEntityListFromJson(List<dynamic> jsonList) {
  return jsonList.map((productJson) {
    ProductEntity product = ProductEntity(
      productId: productJson['id'],
      ref: productJson['ref'],
      status: productJson['status'],
      dateModification: productJson['date_modification'],
      label: productJson['label'],
      description: productJson['description'],
      type: productJson['type'],
      price: productJson['price'],
      priceTtc: productJson['price_ttc'],
      pmp: productJson['pmp'],
      statusBuy: productJson['status_buy'],
      finished: productJson['finished'],
      barcode: productJson['barcode'],
      fkDefaultWarehouse: productJson['fk_default_warehouse'],
      fkPriceExpression: productJson['fk_price_expression'],
      stockReel: productJson['stock_reel'],
    );
    return product;
  }).toList();
}
