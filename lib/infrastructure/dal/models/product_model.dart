// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'package:hive_ce/hive.dart';
import 'dart:convert';

part 'product_model.g.dart';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

@HiveType(typeId: 8)
class ProductModel {
  @HiveField(1)
  String? label;
  @HiveField(2)
  String? description;
  @HiveField(3)
  dynamic other;
  @HiveField(4)
  String? type;
  @HiveField(5)
  String? price;
  @HiveField(6)
  dynamic priceFormated;
  @HiveField(7)
  String? priceTtc;
  @HiveField(8)
  dynamic priceTtcFormated;
  @HiveField(9)
  String? priceMin;
  @HiveField(10)
  String? priceMinTtc;
  @HiveField(11)
  String? priceBaseType;
  @HiveField(12)
  List<dynamic>? multiprices;
  @HiveField(13)
  List<dynamic>? multipricesTtc;
  @HiveField(14)
  List<dynamic>? multipricesBaseType;
  @HiveField(15)
  List<dynamic>? multipricesMin;
  @HiveField(16)
  List<dynamic>? multipricesMinTtc;
  @HiveField(17)
  List<dynamic>? multipricesTvaTx;
  @HiveField(18)
  List<dynamic>? pricesByQty;
  @HiveField(19)
  List<dynamic>? pricesByQtyList;
  @HiveField(20)
  List<dynamic>? multilangs;
  @HiveField(21)
  dynamic defaultVatCode;
  @HiveField(22)
  String? tvaTx;
  @HiveField(23)
  dynamic remisePercent;
  @HiveField(24)
  String? localtax1Tx;
  @HiveField(25)
  String? localtax2Tx;
  @HiveField(26)
  String? localtax1Type;
  @HiveField(27)
  String? localtax2Type;
  @HiveField(28)
  dynamic descSupplier;
  @HiveField(29)
  dynamic vatrateSupplier;
  @HiveField(30)
  dynamic defaultVatCodeSupplier;
  @HiveField(31)
  dynamic fournMulticurrencyPrice;
  @HiveField(32)
  dynamic fournMulticurrencyUnitprice;
  @HiveField(33)
  dynamic fournMulticurrencyTx;
  @HiveField(34)
  dynamic fournMulticurrencyId;
  @HiveField(35)
  dynamic fournMulticurrencyCode;
  @HiveField(36)
  dynamic packaging;
  @HiveField(37)
  dynamic lifetime;
  @HiveField(38)
  dynamic qcFrequency;
  @HiveField(39)
  dynamic stockReel;
  @HiveField(40)
  dynamic stockTheorique;
  @HiveField(41)
  dynamic costPrice;
  @HiveField(42)
  String? pmp;
  @HiveField(43)
  String? seuilStockAlerte;
  @HiveField(44)
  String? desiredstock;
  @HiveField(45)
  dynamic durationValue;
  @HiveField(46)
  dynamic durationUnit;
  @HiveField(47)
  String? duration;
  @HiveField(48)
  dynamic fkDefaultWorkstation;
  @HiveField(49)
  String? status;
  @HiveField(50)
  dynamic tosell;
  @HiveField(51)
  String? statusBuy;
  @HiveField(52)
  dynamic tobuy;
  @HiveField(53)
  String? finished;
  @HiveField(54)
  dynamic fkDefaultBom;
  @HiveField(55)
  String? statusBatch;
  @HiveField(56)
  String? batchMask;
  @HiveField(57)
  String? customcode;
  @HiveField(58)
  dynamic url;
  @HiveField(59)
  dynamic weight;
  @HiveField(60)
  dynamic weightUnits;
  @HiveField(61)
  dynamic length;
  @HiveField(62)
  dynamic lengthUnits;
  @HiveField(63)
  dynamic width;
  @HiveField(64)
  dynamic widthUnits;
  @HiveField(65)
  dynamic height;
  @HiveField(66)
  dynamic heightUnits;
  @HiveField(67)
  dynamic surface;
  @HiveField(68)
  dynamic surfaceUnits;
  @HiveField(69)
  dynamic volume;
  @HiveField(70)
  dynamic volumeUnits;
  @HiveField(71)
  dynamic netMeasure;
  @HiveField(72)
  dynamic netMeasureUnits;
  @HiveField(73)
  String? accountancyCodeSell;
  @HiveField(74)
  String? accountancyCodeSellIntra;
  @HiveField(75)
  String? accountancyCodeSellExport;
  @HiveField(76)
  String? accountancyCodeBuy;
  @HiveField(77)
  String? accountancyCodeBuyIntra;
  @HiveField(78)
  String? accountancyCodeBuyExport;
  @HiveField(79)
  dynamic barcode;
  @HiveField(80)
  dynamic barcodeType;
  @HiveField(81)
  List<dynamic>? statsProposalSupplier;
  @HiveField(82)
  List<dynamic>? statsExpedition;
  @HiveField(83)
  List<dynamic>? statsMo;
  @HiveField(84)
  List<dynamic>? statsBom;
  @HiveField(85)
  List<dynamic>? statsFacturerec;
  @HiveField(86)
  List<dynamic>? statsFactureFournisseur;
  @HiveField(87)
  DateTime? dateCreation;
  @HiveField(88)
  DateTime? dateModification;
  @HiveField(89)
  List<dynamic>? stockWarehouse;
  @HiveField(90)
  String? fkDefaultWarehouse;
  @HiveField(91)
  dynamic fkPriceExpression;
  @HiveField(92)
  dynamic fournQty;
  @HiveField(93)
  dynamic fkUnit;
  @HiveField(94)
  String? priceAutogen;
  @HiveField(95)
  dynamic sousprods;
  @HiveField(96)
  dynamic res;
  @HiveField(97)
  dynamic isObjectUsed;
  @HiveField(98)
  String? mandatoryPeriod;
  @HiveField(99)
  dynamic module;
  @HiveField(100)
  String? id;
  @HiveField(101)
  String? entity;
  @HiveField(102)
  dynamic importKey;
  @HiveField(103)
  List<dynamic>? arrayOptions;
  @HiveField(104)
  dynamic arrayLanguages;
  @HiveField(105)
  dynamic contactsIds;
  @HiveField(106)
  dynamic linkedObjects;
  @HiveField(107)
  dynamic linkedObjectsIds;
  @HiveField(108)
  dynamic oldref;
  @HiveField(109)
  String? canvas;
  @HiveField(110)
  String? ref;
  @HiveField(111)
  dynamic refExt;
  @HiveField(112)
  dynamic countryId;
  @HiveField(113)
  String? countryCode;
  @HiveField(114)
  dynamic stateId;
  @HiveField(115)
  dynamic regionId;
  @HiveField(116)
  dynamic barcodeTypeCoder;
  @HiveField(117)
  dynamic shippingMethod;
  @HiveField(118)
  dynamic multicurrencyCode;
  @HiveField(119)
  dynamic multicurrencyTx;
  @HiveField(120)
  dynamic lastMainDoc;
  @HiveField(121)
  dynamic notePublic;
  @HiveField(122)
  String? notePrivate;
  @HiveField(123)
  dynamic totalHt;
  @HiveField(124)
  dynamic totalTva;
  @HiveField(125)
  dynamic totalLocaltax1;
  @HiveField(126)
  dynamic totalLocaltax2;
  @HiveField(127)
  dynamic totalTtc;
  @HiveField(128)
  dynamic dateValidation;
  @HiveField(129)
  dynamic dateUpdate;
  @HiveField(130)
  dynamic dateCloture;
  @HiveField(131)
  dynamic userAuthor;
  @HiveField(132)
  dynamic userCreation;
  @HiveField(133)
  dynamic userCreationId;
  @HiveField(134)
  dynamic userValid;
  @HiveField(135)
  dynamic userValidation;
  @HiveField(136)
  dynamic userValidationId;
  @HiveField(137)
  dynamic userClosingId;
  @HiveField(138)
  dynamic userModification;
  @HiveField(139)
  dynamic userModificationId;
  @HiveField(140)
  int? specimen;
  @HiveField(141)
  dynamic labelStatus;
  @HiveField(142)
  dynamic showphotoOnPopup;
  @HiveField(143)
  List<dynamic>? nb;
  @HiveField(144)
  dynamic output;
  @HiveField(145)
  List<dynamic>? extraparams;

  ProductModel({
    this.label,
    this.description,
    this.other,
    this.type,
    this.price,
    this.priceFormated,
    this.priceTtc,
    this.priceTtcFormated,
    this.priceMin,
    this.priceMinTtc,
    this.priceBaseType,
    this.multiprices,
    this.multipricesTtc,
    this.multipricesBaseType,
    this.multipricesMin,
    this.multipricesMinTtc,
    this.multipricesTvaTx,
    this.pricesByQty,
    this.pricesByQtyList,
    this.multilangs,
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
    this.fkDefaultWorkstation,
    this.status,
    this.tosell,
    this.statusBuy,
    this.tobuy,
    this.finished,
    this.fkDefaultBom,
    this.statusBatch,
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
    this.accountancyCodeSell,
    this.accountancyCodeSellIntra,
    this.accountancyCodeSellExport,
    this.accountancyCodeBuy,
    this.accountancyCodeBuyIntra,
    this.accountancyCodeBuyExport,
    this.barcode,
    this.barcodeType,
    this.statsProposalSupplier,
    this.statsExpedition,
    this.statsMo,
    this.statsBom,
    this.statsFacturerec,
    this.statsFactureFournisseur,
    this.dateCreation,
    this.dateModification,
    this.stockWarehouse,
    this.fkDefaultWarehouse,
    this.fkPriceExpression,
    this.fournQty,
    this.fkUnit,
    this.priceAutogen,
    this.sousprods,
    this.res,
    this.isObjectUsed,
    this.mandatoryPeriod,
    this.module,
    this.id,
    this.entity,
    this.importKey,
    this.arrayOptions,
    this.arrayLanguages,
    this.contactsIds,
    this.linkedObjects,
    this.linkedObjectsIds,
    this.oldref,
    this.canvas,
    this.ref,
    this.refExt,
    this.countryId,
    this.countryCode,
    this.stateId,
    this.regionId,
    this.barcodeTypeCoder,
    this.shippingMethod,
    this.multicurrencyCode,
    this.multicurrencyTx,
    this.lastMainDoc,
    this.notePublic,
    this.notePrivate,
    this.totalHt,
    this.totalTva,
    this.totalLocaltax1,
    this.totalLocaltax2,
    this.totalTtc,
    this.dateValidation,
    this.dateUpdate,
    this.dateCloture,
    this.userAuthor,
    this.userCreation,
    this.userCreationId,
    this.userValid,
    this.userValidation,
    this.userValidationId,
    this.userClosingId,
    this.userModification,
    this.userModificationId,
    this.specimen,
    this.labelStatus,
    this.showphotoOnPopup,
    this.nb,
    this.output,
    this.extraparams,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        label: json["label"],
        description: json["description"],
        other: json["other"],
        type: json["type"],
        price: json["price"],
        priceFormated: json["price_formated"],
        priceTtc: json["price_ttc"],
        priceTtcFormated: json["price_ttc_formated"],
        priceMin: json["price_min"],
        priceMinTtc: json["price_min_ttc"],
        priceBaseType: json["price_base_type"],
        multiprices: json["multiprices"] == null
            ? []
            : List<dynamic>.from(json["multiprices"]!.map((x) => x)),
        multipricesTtc: json["multiprices_ttc"] == null
            ? []
            : List<dynamic>.from(json["multiprices_ttc"]!.map((x) => x)),
        multipricesBaseType: json["multiprices_base_type"] == null
            ? []
            : List<dynamic>.from(json["multiprices_base_type"]!.map((x) => x)),
        multipricesMin: json["multiprices_min"] == null
            ? []
            : List<dynamic>.from(json["multiprices_min"]!.map((x) => x)),
        multipricesMinTtc: json["multiprices_min_ttc"] == null
            ? []
            : List<dynamic>.from(json["multiprices_min_ttc"]!.map((x) => x)),
        multipricesTvaTx: json["multiprices_tva_tx"] == null
            ? []
            : List<dynamic>.from(json["multiprices_tva_tx"]!.map((x) => x)),
        pricesByQty: json["prices_by_qty"] == null
            ? []
            : List<dynamic>.from(json["prices_by_qty"]!.map((x) => x)),
        pricesByQtyList: json["prices_by_qty_list"] == null
            ? []
            : List<dynamic>.from(json["prices_by_qty_list"]!.map((x) => x)),
        multilangs: json["multilangs"] == null
            ? []
            : List<dynamic>.from(json["multilangs"]!.map((x) => x)),
        defaultVatCode: json["default_vat_code"],
        tvaTx: json["tva_tx"],
        remisePercent: json["remise_percent"],
        localtax1Tx: json["localtax1_tx"],
        localtax2Tx: json["localtax2_tx"],
        localtax1Type: json["localtax1_type"],
        localtax2Type: json["localtax2_type"],
        descSupplier: json["desc_supplier"],
        vatrateSupplier: json["vatrate_supplier"],
        defaultVatCodeSupplier: json["default_vat_code_supplier"],
        fournMulticurrencyPrice: json["fourn_multicurrency_price"],
        fournMulticurrencyUnitprice: json["fourn_multicurrency_unitprice"],
        fournMulticurrencyTx: json["fourn_multicurrency_tx"],
        fournMulticurrencyId: json["fourn_multicurrency_id"],
        fournMulticurrencyCode: json["fourn_multicurrency_code"],
        packaging: json["packaging"],
        lifetime: json["lifetime"],
        qcFrequency: json["qc_frequency"],
        stockReel: json["stock_reel"],
        stockTheorique: json["stock_theorique"],
        costPrice: json["cost_price"],
        pmp: json["pmp"],
        seuilStockAlerte: json["seuil_stock_alerte"],
        desiredstock: json["desiredstock"],
        durationValue: json["duration_value"],
        durationUnit: json["duration_unit"],
        duration: json["duration"],
        fkDefaultWorkstation: json["fk_default_workstation"],
        status: json["status"],
        tosell: json["tosell"],
        statusBuy: json["status_buy"],
        tobuy: json["tobuy"],
        finished: json["finished"],
        fkDefaultBom: json["fk_default_bom"],
        statusBatch: json["status_batch"],
        batchMask: json["batch_mask"],
        customcode: json["customcode"],
        url: json["url"],
        weight: json["weight"],
        weightUnits: json["weight_units"],
        length: json["length"],
        lengthUnits: json["length_units"],
        width: json["width"],
        widthUnits: json["width_units"],
        height: json["height"],
        heightUnits: json["height_units"],
        surface: json["surface"],
        surfaceUnits: json["surface_units"],
        volume: json["volume"],
        volumeUnits: json["volume_units"],
        netMeasure: json["net_measure"],
        netMeasureUnits: json["net_measure_units"],
        accountancyCodeSell: json["accountancy_code_sell"],
        accountancyCodeSellIntra: json["accountancy_code_sell_intra"],
        accountancyCodeSellExport: json["accountancy_code_sell_export"],
        accountancyCodeBuy: json["accountancy_code_buy"],
        accountancyCodeBuyIntra: json["accountancy_code_buy_intra"],
        accountancyCodeBuyExport: json["accountancy_code_buy_export"],
        barcode: json["barcode"],
        barcodeType: json["barcode_type"],
        statsProposalSupplier: json["stats_proposal_supplier"] == null
            ? []
            : List<dynamic>.from(
                json["stats_proposal_supplier"]!.map((x) => x)),
        statsExpedition: json["stats_expedition"] == null
            ? []
            : List<dynamic>.from(json["stats_expedition"]!.map((x) => x)),
        statsMo: json["stats_mo"] == null
            ? []
            : List<dynamic>.from(json["stats_mo"]!.map((x) => x)),
        statsBom: json["stats_bom"] == null
            ? []
            : List<dynamic>.from(json["stats_bom"]!.map((x) => x)),
        statsFacturerec: json["stats_facturerec"] == null
            ? []
            : List<dynamic>.from(json["stats_facturerec"]!.map((x) => x)),
        statsFactureFournisseur: json["stats_facture_fournisseur"] == null
            ? []
            : List<dynamic>.from(
                json["stats_facture_fournisseur"]!.map((x) => x)),
        dateCreation: json["date_creation"] == null
            ? null
            : DateTime.parse(json["date_creation"]),
        dateModification: json["date_modification"] == null
            ? null
            : DateTime.parse(json["date_modification"]),
        stockWarehouse: json["stock_warehouse"] == null
            ? []
            : List<dynamic>.from(json["stock_warehouse"]!.map((x) => x)),
        fkDefaultWarehouse: json["fk_default_warehouse"],
        fkPriceExpression: json["fk_price_expression"],
        fournQty: json["fourn_qty"],
        fkUnit: json["fk_unit"],
        priceAutogen: json["price_autogen"],
        sousprods: json["sousprods"],
        res: json["res"],
        isObjectUsed: json["is_object_used"],
        mandatoryPeriod: json["mandatory_period"],
        module: json["module"],
        id: json["id"],
        entity: json["entity"],
        importKey: json["import_key"],
        arrayOptions: json["array_options"] == null
            ? []
            : List<dynamic>.from(json["array_options"]!.map((x) => x)),
        arrayLanguages: json["array_languages"],
        contactsIds: json["contacts_ids"],
        linkedObjects: json["linked_objects"],
        linkedObjectsIds: json["linkedObjectsIds"],
        oldref: json["oldref"],
        canvas: json["canvas"],
        ref: json["ref"],
        refExt: json["ref_ext"],
        countryId: json["country_id"],
        countryCode: json["country_code"],
        stateId: json["state_id"],
        regionId: json["region_id"],
        barcodeTypeCoder: json["barcode_type_coder"],
        shippingMethod: json["shipping_method"],
        multicurrencyCode: json["multicurrency_code"],
        multicurrencyTx: json["multicurrency_tx"],
        lastMainDoc: json["last_main_doc"],
        notePublic: json["note_public"],
        notePrivate: json["note_private"],
        totalHt: json["total_ht"],
        totalTva: json["total_tva"],
        totalLocaltax1: json["total_localtax1"],
        totalLocaltax2: json["total_localtax2"],
        totalTtc: json["total_ttc"],
        dateValidation: json["date_validation"],
        dateUpdate: json["date_update"],
        dateCloture: json["date_cloture"],
        userAuthor: json["user_author"],
        userCreation: json["user_creation"],
        userCreationId: json["user_creation_id"],
        userValid: json["user_valid"],
        userValidation: json["user_validation"],
        userValidationId: json["user_validation_id"],
        userClosingId: json["user_closing_id"],
        userModification: json["user_modification"],
        userModificationId: json["user_modification_id"],
        specimen: json["specimen"],
        labelStatus: json["labelStatus"],
        showphotoOnPopup: json["showphoto_on_popup"],
        nb: json["nb"] == null
            ? []
            : List<dynamic>.from(json["nb"]!.map((x) => x)),
        output: json["output"],
        extraparams: json["extraparams"] == null
            ? []
            : List<dynamic>.from(json["extraparams"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "description": description,
        "other": other,
        "type": type,
        "price": price,
        "price_formated": priceFormated,
        "price_ttc": priceTtc,
        "price_ttc_formated": priceTtcFormated,
        "price_min": priceMin,
        "price_min_ttc": priceMinTtc,
        "price_base_type": priceBaseType,
        "multiprices": multiprices == null
            ? []
            : List<dynamic>.from(multiprices!.map((x) => x)),
        "multiprices_ttc": multipricesTtc == null
            ? []
            : List<dynamic>.from(multipricesTtc!.map((x) => x)),
        "multiprices_base_type": multipricesBaseType == null
            ? []
            : List<dynamic>.from(multipricesBaseType!.map((x) => x)),
        "multiprices_min": multipricesMin == null
            ? []
            : List<dynamic>.from(multipricesMin!.map((x) => x)),
        "multiprices_min_ttc": multipricesMinTtc == null
            ? []
            : List<dynamic>.from(multipricesMinTtc!.map((x) => x)),
        "multiprices_tva_tx": multipricesTvaTx == null
            ? []
            : List<dynamic>.from(multipricesTvaTx!.map((x) => x)),
        "prices_by_qty": pricesByQty == null
            ? []
            : List<dynamic>.from(pricesByQty!.map((x) => x)),
        "prices_by_qty_list": pricesByQtyList == null
            ? []
            : List<dynamic>.from(pricesByQtyList!.map((x) => x)),
        "multilangs": multilangs == null
            ? []
            : List<dynamic>.from(multilangs!.map((x) => x)),
        "default_vat_code": defaultVatCode,
        "tva_tx": tvaTx,
        "remise_percent": remisePercent,
        "localtax1_tx": localtax1Tx,
        "localtax2_tx": localtax2Tx,
        "localtax1_type": localtax1Type,
        "localtax2_type": localtax2Type,
        "desc_supplier": descSupplier,
        "vatrate_supplier": vatrateSupplier,
        "default_vat_code_supplier": defaultVatCodeSupplier,
        "fourn_multicurrency_price": fournMulticurrencyPrice,
        "fourn_multicurrency_unitprice": fournMulticurrencyUnitprice,
        "fourn_multicurrency_tx": fournMulticurrencyTx,
        "fourn_multicurrency_id": fournMulticurrencyId,
        "fourn_multicurrency_code": fournMulticurrencyCode,
        "packaging": packaging,
        "lifetime": lifetime,
        "qc_frequency": qcFrequency,
        "stock_reel": stockReel,
        "stock_theorique": stockTheorique,
        "cost_price": costPrice,
        "pmp": pmp,
        "seuil_stock_alerte": seuilStockAlerte,
        "desiredstock": desiredstock,
        "duration_value": durationValue,
        "duration_unit": durationUnit,
        "duration": duration,
        "fk_default_workstation": fkDefaultWorkstation,
        "status": status,
        "tosell": tosell,
        "status_buy": statusBuy,
        "tobuy": tobuy,
        "finished": finished,
        "fk_default_bom": fkDefaultBom,
        "status_batch": statusBatch,
        "batch_mask": batchMask,
        "customcode": customcode,
        "url": url,
        "weight": weight,
        "weight_units": weightUnits,
        "length": length,
        "length_units": lengthUnits,
        "width": width,
        "width_units": widthUnits,
        "height": height,
        "height_units": heightUnits,
        "surface": surface,
        "surface_units": surfaceUnits,
        "volume": volume,
        "volume_units": volumeUnits,
        "net_measure": netMeasure,
        "net_measure_units": netMeasureUnits,
        "accountancy_code_sell": accountancyCodeSell,
        "accountancy_code_sell_intra": accountancyCodeSellIntra,
        "accountancy_code_sell_export": accountancyCodeSellExport,
        "accountancy_code_buy": accountancyCodeBuy,
        "accountancy_code_buy_intra": accountancyCodeBuyIntra,
        "accountancy_code_buy_export": accountancyCodeBuyExport,
        "barcode": barcode,
        "barcode_type": barcodeType,
        "stats_proposal_supplier": statsProposalSupplier == null
            ? []
            : List<dynamic>.from(statsProposalSupplier!.map((x) => x)),
        "stats_expedition": statsExpedition == null
            ? []
            : List<dynamic>.from(statsExpedition!.map((x) => x)),
        "stats_mo":
            statsMo == null ? [] : List<dynamic>.from(statsMo!.map((x) => x)),
        "stats_bom":
            statsBom == null ? [] : List<dynamic>.from(statsBom!.map((x) => x)),
        "stats_facturerec": statsFacturerec == null
            ? []
            : List<dynamic>.from(statsFacturerec!.map((x) => x)),
        "stats_facture_fournisseur": statsFactureFournisseur == null
            ? []
            : List<dynamic>.from(statsFactureFournisseur!.map((x) => x)),
        "date_creation": dateCreation?.toIso8601String(),
        "date_modification": dateModification?.toIso8601String(),
        "stock_warehouse": stockWarehouse == null
            ? []
            : List<dynamic>.from(stockWarehouse!.map((x) => x)),
        "fk_default_warehouse": fkDefaultWarehouse,
        "fk_price_expression": fkPriceExpression,
        "fourn_qty": fournQty,
        "fk_unit": fkUnit,
        "price_autogen": priceAutogen,
        "sousprods": sousprods,
        "res": res,
        "is_object_used": isObjectUsed,
        "mandatory_period": mandatoryPeriod,
        "module": module,
        "id": id,
        "entity": entity,
        "import_key": importKey,
        "array_options": arrayOptions == null
            ? []
            : List<dynamic>.from(arrayOptions!.map((x) => x)),
        "array_languages": arrayLanguages,
        "contacts_ids": contactsIds,
        "linked_objects": linkedObjects,
        "linkedObjectsIds": linkedObjectsIds,
        "oldref": oldref,
        "canvas": canvas,
        "ref": ref,
        "ref_ext": refExt,
        "country_id": countryId,
        "country_code": countryCode,
        "state_id": stateId,
        "region_id": regionId,
        "barcode_type_coder": barcodeTypeCoder,
        "shipping_method": shippingMethod,
        "multicurrency_code": multicurrencyCode,
        "multicurrency_tx": multicurrencyTx,
        "last_main_doc": lastMainDoc,
        "note_public": notePublic,
        "note_private": notePrivate,
        "total_ht": totalHt,
        "total_tva": totalTva,
        "total_localtax1": totalLocaltax1,
        "total_localtax2": totalLocaltax2,
        "total_ttc": totalTtc,
        "date_validation": dateValidation,
        "date_update": dateUpdate,
        "date_cloture": dateCloture,
        "user_author": userAuthor,
        "user_creation": userCreation,
        "user_creation_id": userCreationId,
        "user_valid": userValid,
        "user_validation": userValidation,
        "user_validation_id": userValidationId,
        "user_closing_id": userClosingId,
        "user_modification": userModification,
        "user_modification_id": userModificationId,
        "specimen": specimen,
        "labelStatus": labelStatus,
        "showphoto_on_popup": showphotoOnPopup,
        "nb": nb == null ? [] : List<dynamic>.from(nb!.map((x) => x)),
        "output": output,
        "extraparams": extraparams == null
            ? []
            : List<dynamic>.from(extraparams!.map((x) => x)),
      };
}
