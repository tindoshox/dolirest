// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'product_model.g.dart';

List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(
    json.decode(str).map((x) => ProductModel.fromJson(x)));

String productModelToJson(List<ProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@HiveType(typeId: 8)
@JsonSerializable()
class ProductModel {
  @HiveField(1)
  @JsonKey(name: "module")
  dynamic module;
  @HiveField(3)
  @JsonKey(name: "id")
  dynamic id;
  @HiveField(5)
  @JsonKey(name: "entity")
  dynamic entity;
  @HiveField(7)
  @JsonKey(name: "import_key")
  dynamic importKey;
  @HiveField(9)
  @JsonKey(name: "array_options")
  List<dynamic>? arrayOptions;
  @HiveField(11)
  @JsonKey(name: "array_languages")
  dynamic arrayLanguages;
  @HiveField(13)
  @JsonKey(name: "contacts_ids")
  dynamic contactsIds;
  @HiveField(15)
  @JsonKey(name: "canvas")
  dynamic canvas;
  @HiveField(17)
  @JsonKey(name: "origin_type")
  dynamic originType;
  @HiveField(19)
  @JsonKey(name: "ref")
  dynamic ref;
  @HiveField(21)
  @JsonKey(name: "ref_ext")
  dynamic refExt;
  @HiveField(23)
  @JsonKey(name: "status")
  dynamic status;
  @HiveField(25)
  @JsonKey(name: "country_id")
  dynamic countryId;
  @HiveField(27)
  @JsonKey(name: "country_code")
  dynamic countryCode;
  @HiveField(29)
  @JsonKey(name: "state_id")
  dynamic stateId;
  @HiveField(31)
  @JsonKey(name: "region_id")
  dynamic regionId;
  @HiveField(33)
  @JsonKey(name: "barcode_type")
  dynamic barcodeType;
  @HiveField(35)
  @JsonKey(name: "barcode_type_coder")
  dynamic barcodeTypeCoder;
  @HiveField(37)
  @JsonKey(name: "shipping_method")
  dynamic shippingMethod;
  @HiveField(39)
  @JsonKey(name: "fk_multicurrency")
  dynamic fkMulticurrency;
  @HiveField(41)
  @JsonKey(name: "multicurrency_code")
  dynamic multicurrencyCode;
  @HiveField(43)
  @JsonKey(name: "multicurrency_tx")
  dynamic multicurrencyTx;
  @HiveField(45)
  @JsonKey(name: "multicurrency_total_ht")
  dynamic multicurrencyTotalHt;
  @HiveField(47)
  @JsonKey(name: "multicurrency_total_tva")
  dynamic multicurrencyTotalTva;
  @HiveField(49)
  @JsonKey(name: "multicurrency_total_ttc")
  dynamic multicurrencyTotalTtc;
  @HiveField(51)
  @JsonKey(name: "multicurrency_total_localtax1")
  dynamic multicurrencyTotalLocaltax1;
  @HiveField(53)
  @JsonKey(name: "multicurrency_total_localtax2")
  dynamic multicurrencyTotalLocaltax2;
  @HiveField(55)
  @JsonKey(name: "total_ttc")
  dynamic totalTtc;
  @HiveField(57)
  @JsonKey(name: "actiontypecode")
  dynamic actiontypecode;
  @HiveField(59)
  @JsonKey(name: "date_creation")
  dynamic dateCreation;
  @HiveField(61)
  @JsonKey(name: "date_validation")
  dynamic dateValidation;
  @HiveField(63)
  @JsonKey(name: "date_modification")
  dynamic dateModification;
  @HiveField(65)
  @JsonKey(name: "tms")
  dynamic tms;
  @HiveField(67)
  @JsonKey(name: "date_cloture")
  dynamic dateCloture;
  @HiveField(69)
  @JsonKey(name: "specimen")
  dynamic specimen;
  @HiveField(71)
  @JsonKey(name: "totalpaid")
  dynamic totalpaid;
  @HiveField(73)
  @JsonKey(name: "product")
  dynamic product;
  @HiveField(75)
  @JsonKey(name: "cond_reglement_supplier_id")
  dynamic condReglementSupplierId;
  @HiveField(77)
  @JsonKey(name: "retained_warranty_fk_cond_reglement")
  dynamic retainedWarrantyFkCondReglement;
  @HiveField(79)
  @JsonKey(name: "warehouse_id")
  dynamic warehouseId;
  @HiveField(81)
  @JsonKey(name: "label")
  dynamic label;
  @HiveField(83)
  @JsonKey(name: "other")
  dynamic other;
  @HiveField(85)
  @JsonKey(name: "type")
  dynamic type;
  @HiveField(87)
  @JsonKey(name: "price")
  dynamic price;
  @HiveField(89)
  @JsonKey(name: "price_formated")
  dynamic priceFormated;
  @HiveField(91)
  @JsonKey(name: "price_ttc")
  dynamic priceTtc;
  @HiveField(93)
  @JsonKey(name: "price_ttc_formated")
  dynamic priceTtcFormated;
  @HiveField(95)
  @JsonKey(name: "price_min")
  dynamic priceMin;
  @HiveField(97)
  @JsonKey(name: "price_min_ttc")
  dynamic priceMinTtc;
  @HiveField(99)
  @JsonKey(name: "price_base_type")
  dynamic priceBaseType;
  @HiveField(101)
  @JsonKey(name: "price_label")
  dynamic priceLabel;
  @HiveField(103)
  @JsonKey(name: "multiprices")
  List<dynamic>? multiprices;
  @HiveField(105)
  @JsonKey(name: "multiprices_ttc")
  List<dynamic>? multipricesTtc;
  @HiveField(107)
  @JsonKey(name: "multiprices_base_type")
  List<dynamic>? multipricesBaseType;
  @HiveField(109)
  @JsonKey(name: "multiprices_default_vat_code")
  List<dynamic>? multipricesDefaultVatCode;
  @HiveField(111)
  @JsonKey(name: "multiprices_min")
  List<dynamic>? multipricesMin;
  @HiveField(113)
  @JsonKey(name: "multiprices_min_ttc")
  List<dynamic>? multipricesMinTtc;
  @HiveField(115)
  @JsonKey(name: "multiprices_tva_tx")
  List<dynamic>? multipricesTvaTx;
  @HiveField(117)
  @JsonKey(name: "prices_by_qty")
  List<dynamic>? pricesByQty;
  @HiveField(119)
  @JsonKey(name: "prices_by_qty_list")
  List<dynamic>? pricesByQtyList;
  @HiveField(121)
  @JsonKey(name: "level")
  dynamic level;
  @HiveField(123)
  @JsonKey(name: "default_vat_code")
  dynamic defaultVatCode;
  @HiveField(125)
  @JsonKey(name: "tva_tx")
  dynamic tvaTx;
  @HiveField(127)
  @JsonKey(name: "remise_percent")
  dynamic remisePercent;
  @HiveField(129)
  @JsonKey(name: "localtax1_tx")
  dynamic localtax1Tx;
  @HiveField(131)
  @JsonKey(name: "localtax2_tx")
  dynamic localtax2Tx;
  @HiveField(133)
  @JsonKey(name: "localtax1_type")
  dynamic localtax1Type;
  @HiveField(135)
  @JsonKey(name: "localtax2_type")
  dynamic localtax2Type;
  @HiveField(137)
  @JsonKey(name: "desc_supplier")
  dynamic descSupplier;
  @HiveField(139)
  @JsonKey(name: "vatrate_supplier")
  dynamic vatrateSupplier;
  @HiveField(141)
  @JsonKey(name: "default_vat_code_supplier")
  dynamic defaultVatCodeSupplier;
  @HiveField(143)
  @JsonKey(name: "fourn_multicurrency_price")
  dynamic fournMulticurrencyPrice;
  @HiveField(145)
  @JsonKey(name: "fourn_multicurrency_unitprice")
  dynamic fournMulticurrencyUnitprice;
  @HiveField(147)
  @JsonKey(name: "fourn_multicurrency_tx")
  dynamic fournMulticurrencyTx;
  @HiveField(149)
  @JsonKey(name: "fourn_multicurrency_id")
  dynamic fournMulticurrencyId;
  @HiveField(151)
  @JsonKey(name: "fourn_multicurrency_code")
  dynamic fournMulticurrencyCode;
  @HiveField(153)
  @JsonKey(name: "packaging")
  dynamic packaging;
  @HiveField(155)
  @JsonKey(name: "lifetime")
  dynamic lifetime;
  @HiveField(157)
  @JsonKey(name: "qc_frequency")
  dynamic qcFrequency;
  @HiveField(159)
  @JsonKey(name: "stock_reel")
  dynamic stockReel;
  @HiveField(161)
  @JsonKey(name: "stock_theorique")
  dynamic stockTheorique;
  @HiveField(163)
  @JsonKey(name: "cost_price")
  dynamic costPrice;
  @HiveField(165)
  @JsonKey(name: "pmp")
  dynamic pmp;
  @HiveField(167)
  @JsonKey(name: "seuil_stock_alerte")
  dynamic seuilStockAlerte;
  @HiveField(169)
  @JsonKey(name: "desiredstock")
  dynamic desiredstock;
  @HiveField(171)
  @JsonKey(name: "duration_value")
  dynamic durationValue;
  @HiveField(173)
  @JsonKey(name: "duration_unit")
  dynamic durationUnit;
  @HiveField(175)
  @JsonKey(name: "duration")
  dynamic duration;
  @HiveField(177)
  @JsonKey(name: "tosell")
  dynamic tosell;
  @HiveField(179)
  @JsonKey(name: "status_buy")
  dynamic statusBuy;
  @HiveField(181)
  @JsonKey(name: "tobuy")
  dynamic tobuy;
  @HiveField(183)
  @JsonKey(name: "finished")
  dynamic finished;
  @HiveField(185)
  @JsonKey(name: "fk_default_bom")
  dynamic fkDefaultBom;
  @HiveField(187)
  @JsonKey(name: "product_fourn_price_id")
  dynamic productFournPriceId;
  @HiveField(189)
  @JsonKey(name: "buyprice")
  dynamic buyprice;
  @HiveField(191)
  @JsonKey(name: "tobatch")
  dynamic tobatch;
  @HiveField(193)
  @JsonKey(name: "status_batch")
  dynamic statusBatch;
  @HiveField(195)
  @JsonKey(name: "sell_or_eat_by_mandatory")
  dynamic sellOrEatByMandatory;
  @HiveField(197)
  @JsonKey(name: "batch_mask")
  dynamic batchMask;
  @HiveField(199)
  @JsonKey(name: "customcode")
  dynamic customcode;
  @HiveField(201)
  @JsonKey(name: "url")
  dynamic url;
  @HiveField(203)
  @JsonKey(name: "weight")
  dynamic weight;
  @HiveField(205)
  @JsonKey(name: "weight_units")
  dynamic weightUnits;
  @HiveField(207)
  @JsonKey(name: "length")
  dynamic length;
  @HiveField(209)
  @JsonKey(name: "length_units")
  dynamic lengthUnits;
  @HiveField(211)
  @JsonKey(name: "width")
  dynamic width;
  @HiveField(213)
  @JsonKey(name: "width_units")
  dynamic widthUnits;
  @HiveField(215)
  @JsonKey(name: "height")
  dynamic height;
  @HiveField(217)
  @JsonKey(name: "height_units")
  dynamic heightUnits;
  @HiveField(219)
  @JsonKey(name: "surface")
  dynamic surface;
  @HiveField(221)
  @JsonKey(name: "surface_units")
  dynamic surfaceUnits;
  @HiveField(223)
  @JsonKey(name: "volume")
  dynamic volume;
  @HiveField(225)
  @JsonKey(name: "volume_units")
  dynamic volumeUnits;
  @HiveField(227)
  @JsonKey(name: "net_measure")
  dynamic netMeasure;
  @HiveField(229)
  @JsonKey(name: "net_measure_units")
  dynamic netMeasureUnits;
  @HiveField(231)
  @JsonKey(name: "barcode")
  dynamic barcode;
  @HiveField(233)
  @JsonKey(name: "stock_warehouse")
  List<dynamic>? stockWarehouse;
  @HiveField(235)
  @JsonKey(name: "fk_default_warehouse")
  dynamic fkDefaultWarehouse;
  @HiveField(237)
  @JsonKey(name: "fk_price_expression")
  dynamic fkPriceExpression;
  @HiveField(239)
  @JsonKey(name: "fourn_qty")
  dynamic fournQty;
  @HiveField(241)
  @JsonKey(name: "fk_unit")
  dynamic fkUnit;
  @HiveField(243)
  @JsonKey(name: "price_autogen")
  dynamic priceAutogen;
  @HiveField(245)
  @JsonKey(name: "sousprods")
  dynamic sousprods;
  @HiveField(247)
  @JsonKey(name: "res")
  dynamic res;
  @HiveField(249)
  @JsonKey(name: "is_object_used")
  dynamic isObjectUsed;
  @HiveField(251)
  @JsonKey(name: "is_sousproduit_qty")
  dynamic isSousproduitQty;
  @HiveField(253)
  @JsonKey(name: "is_sousproduit_incdec")
  dynamic isSousproduitIncdec;
  @HiveField(255)
  @JsonKey(name: "mandatory_period")
  dynamic mandatoryPeriod;

  ProductModel({
    this.module,
    this.id,
    this.entity,
    this.importKey,
    this.arrayOptions,
    this.arrayLanguages,
    this.contactsIds,
    this.canvas,
    this.originType,
    this.ref,
    this.refExt,
    this.status,
    this.countryId,
    this.countryCode,
    this.stateId,
    this.regionId,
    this.barcodeType,
    this.barcodeTypeCoder,
    this.shippingMethod,
    this.fkMulticurrency,
    this.multicurrencyCode,
    this.multicurrencyTx,
    this.multicurrencyTotalHt,
    this.multicurrencyTotalTva,
    this.multicurrencyTotalTtc,
    this.multicurrencyTotalLocaltax1,
    this.multicurrencyTotalLocaltax2,
    this.totalTtc,
    this.actiontypecode,
    this.dateCreation,
    this.dateValidation,
    this.dateModification,
    this.tms,
    this.dateCloture,
    this.specimen,
    this.totalpaid,
    this.product,
    this.condReglementSupplierId,
    this.retainedWarrantyFkCondReglement,
    this.warehouseId,
    this.label,
    this.other,
    this.type,
    this.price,
    this.priceFormated,
    this.priceTtc,
    this.priceTtcFormated,
    this.priceMin,
    this.priceMinTtc,
    this.priceBaseType,
    this.priceLabel,
    this.multiprices,
    this.multipricesTtc,
    this.multipricesBaseType,
    this.multipricesDefaultVatCode,
    this.multipricesMin,
    this.multipricesMinTtc,
    this.multipricesTvaTx,
    this.pricesByQty,
    this.pricesByQtyList,
    this.level,
    this.defaultVatCode,
    this.tvaTx,
    this.remisePercent,
    this.localtax1Tx,
    this.localtax2Tx,
    this.localtax1Type,
    this.localtax2Type,
    this.descSupplier,
    this.vatrateSupplier,
    this.defaultVatCodeSupplier,
    this.fournMulticurrencyPrice,
    this.fournMulticurrencyUnitprice,
    this.fournMulticurrencyTx,
    this.fournMulticurrencyId,
    this.fournMulticurrencyCode,
    this.packaging,
    this.lifetime,
    this.qcFrequency,
    this.stockReel,
    this.stockTheorique,
    this.costPrice,
    this.pmp,
    this.seuilStockAlerte,
    this.desiredstock,
    this.durationValue,
    this.durationUnit,
    this.duration,
    this.tosell,
    this.statusBuy,
    this.tobuy,
    this.finished,
    this.fkDefaultBom,
    this.productFournPriceId,
    this.buyprice,
    this.tobatch,
    this.statusBatch,
    this.sellOrEatByMandatory,
    this.batchMask,
    this.customcode,
    this.url,
    this.weight,
    this.weightUnits,
    this.length,
    this.lengthUnits,
    this.width,
    this.widthUnits,
    this.height,
    this.heightUnits,
    this.surface,
    this.surfaceUnits,
    this.volume,
    this.volumeUnits,
    this.netMeasure,
    this.netMeasureUnits,
    this.barcode,
    this.stockWarehouse,
    this.fkDefaultWarehouse,
    this.fkPriceExpression,
    this.fournQty,
    this.fkUnit,
    this.priceAutogen,
    this.sousprods,
    this.res,
    this.isObjectUsed,
    this.isSousproduitQty,
    this.isSousproduitIncdec,
    this.mandatoryPeriod,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
