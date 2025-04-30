// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final typeId = 8;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      module: fields[1] as dynamic,
      id: fields[3] as dynamic,
      entity: fields[5] as dynamic,
      importKey: fields[7] as dynamic,
      arrayOptions: (fields[9] as List?)?.cast<dynamic>(),
      arrayLanguages: fields[11] as dynamic,
      contactsIds: fields[13] as dynamic,
      canvas: fields[15] as dynamic,
      originType: fields[17] as dynamic,
      ref: fields[19] as dynamic,
      refExt: fields[21] as dynamic,
      status: fields[23] as dynamic,
      countryId: fields[25] as dynamic,
      countryCode: fields[27] as dynamic,
      stateId: fields[29] as dynamic,
      regionId: fields[31] as dynamic,
      barcodeType: fields[33] as dynamic,
      barcodeTypeCoder: fields[35] as dynamic,
      shippingMethod: fields[37] as dynamic,
      fkMulticurrency: fields[39] as dynamic,
      multicurrencyCode: fields[41] as dynamic,
      multicurrencyTx: fields[43] as dynamic,
      multicurrencyTotalHt: fields[45] as dynamic,
      multicurrencyTotalTva: fields[47] as dynamic,
      multicurrencyTotalTtc: fields[49] as dynamic,
      multicurrencyTotalLocaltax1: fields[51] as dynamic,
      multicurrencyTotalLocaltax2: fields[53] as dynamic,
      totalTtc: fields[55] as dynamic,
      actiontypecode: fields[57] as dynamic,
      dateCreation: fields[59] as dynamic,
      dateValidation: fields[61] as dynamic,
      dateModification: fields[63] as dynamic,
      tms: fields[65] as dynamic,
      dateCloture: fields[67] as dynamic,
      specimen: fields[69] as dynamic,
      totalpaid: fields[71] as dynamic,
      product: fields[73] as dynamic,
      condReglementSupplierId: fields[75] as dynamic,
      retainedWarrantyFkCondReglement: fields[77] as dynamic,
      warehouseId: fields[79] as dynamic,
      label: fields[81] as dynamic,
      other: fields[83] as dynamic,
      type: fields[85] as dynamic,
      price: fields[87] as dynamic,
      priceFormated: fields[89] as dynamic,
      priceTtc: fields[91] as dynamic,
      priceTtcFormated: fields[93] as dynamic,
      priceMin: fields[95] as dynamic,
      priceMinTtc: fields[97] as dynamic,
      priceBaseType: fields[99] as dynamic,
      priceLabel: fields[101] as dynamic,
      multiprices: (fields[103] as List?)?.cast<dynamic>(),
      multipricesTtc: (fields[105] as List?)?.cast<dynamic>(),
      multipricesBaseType: (fields[107] as List?)?.cast<dynamic>(),
      multipricesDefaultVatCode: (fields[109] as List?)?.cast<dynamic>(),
      multipricesMin: (fields[111] as List?)?.cast<dynamic>(),
      multipricesMinTtc: (fields[113] as List?)?.cast<dynamic>(),
      multipricesTvaTx: (fields[115] as List?)?.cast<dynamic>(),
      pricesByQty: (fields[117] as List?)?.cast<dynamic>(),
      pricesByQtyList: (fields[119] as List?)?.cast<dynamic>(),
      level: fields[121] as dynamic,
      defaultVatCode: fields[123] as dynamic,
      tvaTx: fields[125] as dynamic,
      remisePercent: fields[127] as dynamic,
      localtax1Tx: fields[129] as dynamic,
      localtax2Tx: fields[131] as dynamic,
      localtax1Type: fields[133] as dynamic,
      localtax2Type: fields[135] as dynamic,
      descSupplier: fields[137] as dynamic,
      vatrateSupplier: fields[139] as dynamic,
      defaultVatCodeSupplier: fields[141] as dynamic,
      fournMulticurrencyPrice: fields[143] as dynamic,
      fournMulticurrencyUnitprice: fields[145] as dynamic,
      fournMulticurrencyTx: fields[147] as dynamic,
      fournMulticurrencyId: fields[149] as dynamic,
      fournMulticurrencyCode: fields[151] as dynamic,
      packaging: fields[153] as dynamic,
      lifetime: fields[155] as dynamic,
      qcFrequency: fields[157] as dynamic,
      stockReel: fields[159] as dynamic,
      stockTheorique: fields[161] as dynamic,
      costPrice: fields[163] as dynamic,
      pmp: fields[165] as dynamic,
      seuilStockAlerte: fields[167] as dynamic,
      desiredstock: fields[169] as dynamic,
      durationValue: fields[171] as dynamic,
      durationUnit: fields[173] as dynamic,
      duration: fields[175] as dynamic,
      tosell: fields[177] as dynamic,
      statusBuy: fields[179] as dynamic,
      tobuy: fields[181] as dynamic,
      finished: fields[183] as dynamic,
      fkDefaultBom: fields[185] as dynamic,
      productFournPriceId: fields[187] as dynamic,
      buyprice: fields[189] as dynamic,
      tobatch: fields[191] as dynamic,
      statusBatch: fields[193] as dynamic,
      sellOrEatByMandatory: fields[195] as dynamic,
      batchMask: fields[197] as dynamic,
      customcode: fields[199] as dynamic,
      url: fields[201] as dynamic,
      weight: fields[203] as dynamic,
      weightUnits: fields[205] as dynamic,
      length: fields[207] as dynamic,
      lengthUnits: fields[209] as dynamic,
      width: fields[211] as dynamic,
      widthUnits: fields[213] as dynamic,
      height: fields[215] as dynamic,
      heightUnits: fields[217] as dynamic,
      surface: fields[219] as dynamic,
      surfaceUnits: fields[221] as dynamic,
      volume: fields[223] as dynamic,
      volumeUnits: fields[225] as dynamic,
      netMeasure: fields[227] as dynamic,
      netMeasureUnits: fields[229] as dynamic,
      barcode: fields[231] as dynamic,
      stockWarehouse: (fields[233] as List?)?.cast<dynamic>(),
      fkDefaultWarehouse: fields[235] as dynamic,
      fkPriceExpression: fields[237] as dynamic,
      fournQty: fields[239] as dynamic,
      fkUnit: fields[241] as dynamic,
      priceAutogen: fields[243] as dynamic,
      sousprods: fields[245] as dynamic,
      res: fields[247] as dynamic,
      isObjectUsed: fields[249] as dynamic,
      isSousproduitQty: fields[251] as dynamic,
      isSousproduitIncdec: fields[253] as dynamic,
      mandatoryPeriod: fields[255] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(128)
      ..writeByte(1)
      ..write(obj.module)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.entity)
      ..writeByte(7)
      ..write(obj.importKey)
      ..writeByte(9)
      ..write(obj.arrayOptions)
      ..writeByte(11)
      ..write(obj.arrayLanguages)
      ..writeByte(13)
      ..write(obj.contactsIds)
      ..writeByte(15)
      ..write(obj.canvas)
      ..writeByte(17)
      ..write(obj.originType)
      ..writeByte(19)
      ..write(obj.ref)
      ..writeByte(21)
      ..write(obj.refExt)
      ..writeByte(23)
      ..write(obj.status)
      ..writeByte(25)
      ..write(obj.countryId)
      ..writeByte(27)
      ..write(obj.countryCode)
      ..writeByte(29)
      ..write(obj.stateId)
      ..writeByte(31)
      ..write(obj.regionId)
      ..writeByte(33)
      ..write(obj.barcodeType)
      ..writeByte(35)
      ..write(obj.barcodeTypeCoder)
      ..writeByte(37)
      ..write(obj.shippingMethod)
      ..writeByte(39)
      ..write(obj.fkMulticurrency)
      ..writeByte(41)
      ..write(obj.multicurrencyCode)
      ..writeByte(43)
      ..write(obj.multicurrencyTx)
      ..writeByte(45)
      ..write(obj.multicurrencyTotalHt)
      ..writeByte(47)
      ..write(obj.multicurrencyTotalTva)
      ..writeByte(49)
      ..write(obj.multicurrencyTotalTtc)
      ..writeByte(51)
      ..write(obj.multicurrencyTotalLocaltax1)
      ..writeByte(53)
      ..write(obj.multicurrencyTotalLocaltax2)
      ..writeByte(55)
      ..write(obj.totalTtc)
      ..writeByte(57)
      ..write(obj.actiontypecode)
      ..writeByte(59)
      ..write(obj.dateCreation)
      ..writeByte(61)
      ..write(obj.dateValidation)
      ..writeByte(63)
      ..write(obj.dateModification)
      ..writeByte(65)
      ..write(obj.tms)
      ..writeByte(67)
      ..write(obj.dateCloture)
      ..writeByte(69)
      ..write(obj.specimen)
      ..writeByte(71)
      ..write(obj.totalpaid)
      ..writeByte(73)
      ..write(obj.product)
      ..writeByte(75)
      ..write(obj.condReglementSupplierId)
      ..writeByte(77)
      ..write(obj.retainedWarrantyFkCondReglement)
      ..writeByte(79)
      ..write(obj.warehouseId)
      ..writeByte(81)
      ..write(obj.label)
      ..writeByte(83)
      ..write(obj.other)
      ..writeByte(85)
      ..write(obj.type)
      ..writeByte(87)
      ..write(obj.price)
      ..writeByte(89)
      ..write(obj.priceFormated)
      ..writeByte(91)
      ..write(obj.priceTtc)
      ..writeByte(93)
      ..write(obj.priceTtcFormated)
      ..writeByte(95)
      ..write(obj.priceMin)
      ..writeByte(97)
      ..write(obj.priceMinTtc)
      ..writeByte(99)
      ..write(obj.priceBaseType)
      ..writeByte(101)
      ..write(obj.priceLabel)
      ..writeByte(103)
      ..write(obj.multiprices)
      ..writeByte(105)
      ..write(obj.multipricesTtc)
      ..writeByte(107)
      ..write(obj.multipricesBaseType)
      ..writeByte(109)
      ..write(obj.multipricesDefaultVatCode)
      ..writeByte(111)
      ..write(obj.multipricesMin)
      ..writeByte(113)
      ..write(obj.multipricesMinTtc)
      ..writeByte(115)
      ..write(obj.multipricesTvaTx)
      ..writeByte(117)
      ..write(obj.pricesByQty)
      ..writeByte(119)
      ..write(obj.pricesByQtyList)
      ..writeByte(121)
      ..write(obj.level)
      ..writeByte(123)
      ..write(obj.defaultVatCode)
      ..writeByte(125)
      ..write(obj.tvaTx)
      ..writeByte(127)
      ..write(obj.remisePercent)
      ..writeByte(129)
      ..write(obj.localtax1Tx)
      ..writeByte(131)
      ..write(obj.localtax2Tx)
      ..writeByte(133)
      ..write(obj.localtax1Type)
      ..writeByte(135)
      ..write(obj.localtax2Type)
      ..writeByte(137)
      ..write(obj.descSupplier)
      ..writeByte(139)
      ..write(obj.vatrateSupplier)
      ..writeByte(141)
      ..write(obj.defaultVatCodeSupplier)
      ..writeByte(143)
      ..write(obj.fournMulticurrencyPrice)
      ..writeByte(145)
      ..write(obj.fournMulticurrencyUnitprice)
      ..writeByte(147)
      ..write(obj.fournMulticurrencyTx)
      ..writeByte(149)
      ..write(obj.fournMulticurrencyId)
      ..writeByte(151)
      ..write(obj.fournMulticurrencyCode)
      ..writeByte(153)
      ..write(obj.packaging)
      ..writeByte(155)
      ..write(obj.lifetime)
      ..writeByte(157)
      ..write(obj.qcFrequency)
      ..writeByte(159)
      ..write(obj.stockReel)
      ..writeByte(161)
      ..write(obj.stockTheorique)
      ..writeByte(163)
      ..write(obj.costPrice)
      ..writeByte(165)
      ..write(obj.pmp)
      ..writeByte(167)
      ..write(obj.seuilStockAlerte)
      ..writeByte(169)
      ..write(obj.desiredstock)
      ..writeByte(171)
      ..write(obj.durationValue)
      ..writeByte(173)
      ..write(obj.durationUnit)
      ..writeByte(175)
      ..write(obj.duration)
      ..writeByte(177)
      ..write(obj.tosell)
      ..writeByte(179)
      ..write(obj.statusBuy)
      ..writeByte(181)
      ..write(obj.tobuy)
      ..writeByte(183)
      ..write(obj.finished)
      ..writeByte(185)
      ..write(obj.fkDefaultBom)
      ..writeByte(187)
      ..write(obj.productFournPriceId)
      ..writeByte(189)
      ..write(obj.buyprice)
      ..writeByte(191)
      ..write(obj.tobatch)
      ..writeByte(193)
      ..write(obj.statusBatch)
      ..writeByte(195)
      ..write(obj.sellOrEatByMandatory)
      ..writeByte(197)
      ..write(obj.batchMask)
      ..writeByte(199)
      ..write(obj.customcode)
      ..writeByte(201)
      ..write(obj.url)
      ..writeByte(203)
      ..write(obj.weight)
      ..writeByte(205)
      ..write(obj.weightUnits)
      ..writeByte(207)
      ..write(obj.length)
      ..writeByte(209)
      ..write(obj.lengthUnits)
      ..writeByte(211)
      ..write(obj.width)
      ..writeByte(213)
      ..write(obj.widthUnits)
      ..writeByte(215)
      ..write(obj.height)
      ..writeByte(217)
      ..write(obj.heightUnits)
      ..writeByte(219)
      ..write(obj.surface)
      ..writeByte(221)
      ..write(obj.surfaceUnits)
      ..writeByte(223)
      ..write(obj.volume)
      ..writeByte(225)
      ..write(obj.volumeUnits)
      ..writeByte(227)
      ..write(obj.netMeasure)
      ..writeByte(229)
      ..write(obj.netMeasureUnits)
      ..writeByte(231)
      ..write(obj.barcode)
      ..writeByte(233)
      ..write(obj.stockWarehouse)
      ..writeByte(235)
      ..write(obj.fkDefaultWarehouse)
      ..writeByte(237)
      ..write(obj.fkPriceExpression)
      ..writeByte(239)
      ..write(obj.fournQty)
      ..writeByte(241)
      ..write(obj.fkUnit)
      ..writeByte(243)
      ..write(obj.priceAutogen)
      ..writeByte(245)
      ..write(obj.sousprods)
      ..writeByte(247)
      ..write(obj.res)
      ..writeByte(249)
      ..write(obj.isObjectUsed)
      ..writeByte(251)
      ..write(obj.isSousproduitQty)
      ..writeByte(253)
      ..write(obj.isSousproduitIncdec)
      ..writeByte(255)
      ..write(obj.mandatoryPeriod);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      module: json['module'],
      id: json['id'],
      entity: json['entity'],
      importKey: json['import_key'],
      arrayOptions: json['array_options'] as List<dynamic>?,
      arrayLanguages: json['array_languages'],
      contactsIds: json['contacts_ids'],
      canvas: json['canvas'],
      originType: json['origin_type'],
      ref: json['ref'],
      refExt: json['ref_ext'],
      status: json['status'],
      countryId: json['country_id'],
      countryCode: json['country_code'],
      stateId: json['state_id'],
      regionId: json['region_id'],
      barcodeType: json['barcode_type'],
      barcodeTypeCoder: json['barcode_type_coder'],
      shippingMethod: json['shipping_method'],
      fkMulticurrency: json['fk_multicurrency'],
      multicurrencyCode: json['multicurrency_code'],
      multicurrencyTx: json['multicurrency_tx'],
      multicurrencyTotalHt: json['multicurrency_total_ht'],
      multicurrencyTotalTva: json['multicurrency_total_tva'],
      multicurrencyTotalTtc: json['multicurrency_total_ttc'],
      multicurrencyTotalLocaltax1: json['multicurrency_total_localtax1'],
      multicurrencyTotalLocaltax2: json['multicurrency_total_localtax2'],
      totalTtc: json['total_ttc'],
      actiontypecode: json['actiontypecode'],
      dateCreation: json['date_creation'],
      dateValidation: json['date_validation'],
      dateModification: json['date_modification'],
      tms: json['tms'],
      dateCloture: json['date_cloture'],
      specimen: json['specimen'],
      totalpaid: json['totalpaid'],
      product: json['product'],
      condReglementSupplierId: json['cond_reglement_supplier_id'],
      retainedWarrantyFkCondReglement:
          json['retained_warranty_fk_cond_reglement'],
      warehouseId: json['warehouse_id'],
      label: json['label'],
      other: json['other'],
      type: json['type'],
      price: json['price'],
      priceFormated: json['price_formated'],
      priceTtc: json['price_ttc'],
      priceTtcFormated: json['price_ttc_formated'],
      priceMin: json['price_min'],
      priceMinTtc: json['price_min_ttc'],
      priceBaseType: json['price_base_type'],
      priceLabel: json['price_label'],
      multiprices: json['multiprices'] as List<dynamic>?,
      multipricesTtc: json['multiprices_ttc'] as List<dynamic>?,
      multipricesBaseType: json['multiprices_base_type'] as List<dynamic>?,
      multipricesDefaultVatCode:
          json['multiprices_default_vat_code'] as List<dynamic>?,
      multipricesMin: json['multiprices_min'] as List<dynamic>?,
      multipricesMinTtc: json['multiprices_min_ttc'] as List<dynamic>?,
      multipricesTvaTx: json['multiprices_tva_tx'] as List<dynamic>?,
      pricesByQty: json['prices_by_qty'] as List<dynamic>?,
      pricesByQtyList: json['prices_by_qty_list'] as List<dynamic>?,
      level: json['level'],
      defaultVatCode: json['default_vat_code'],
      tvaTx: json['tva_tx'],
      remisePercent: json['remise_percent'],
      localtax1Tx: json['localtax1_tx'],
      localtax2Tx: json['localtax2_tx'],
      localtax1Type: json['localtax1_type'],
      localtax2Type: json['localtax2_type'],
      descSupplier: json['desc_supplier'],
      vatrateSupplier: json['vatrate_supplier'],
      defaultVatCodeSupplier: json['default_vat_code_supplier'],
      fournMulticurrencyPrice: json['fourn_multicurrency_price'],
      fournMulticurrencyUnitprice: json['fourn_multicurrency_unitprice'],
      fournMulticurrencyTx: json['fourn_multicurrency_tx'],
      fournMulticurrencyId: json['fourn_multicurrency_id'],
      fournMulticurrencyCode: json['fourn_multicurrency_code'],
      packaging: json['packaging'],
      lifetime: json['lifetime'],
      qcFrequency: json['qc_frequency'],
      stockReel: json['stock_reel'],
      stockTheorique: json['stock_theorique'],
      costPrice: json['cost_price'],
      pmp: json['pmp'],
      seuilStockAlerte: json['seuil_stock_alerte'],
      desiredstock: json['desiredstock'],
      durationValue: json['duration_value'],
      durationUnit: json['duration_unit'],
      duration: json['duration'],
      tosell: json['tosell'],
      statusBuy: json['status_buy'],
      tobuy: json['tobuy'],
      finished: json['finished'],
      fkDefaultBom: json['fk_default_bom'],
      productFournPriceId: json['product_fourn_price_id'],
      buyprice: json['buyprice'],
      tobatch: json['tobatch'],
      statusBatch: json['status_batch'],
      sellOrEatByMandatory: json['sell_or_eat_by_mandatory'],
      batchMask: json['batch_mask'],
      customcode: json['customcode'],
      url: json['url'],
      weight: json['weight'],
      weightUnits: json['weight_units'],
      length: json['length'],
      lengthUnits: json['length_units'],
      width: json['width'],
      widthUnits: json['width_units'],
      height: json['height'],
      heightUnits: json['height_units'],
      surface: json['surface'],
      surfaceUnits: json['surface_units'],
      volume: json['volume'],
      volumeUnits: json['volume_units'],
      netMeasure: json['net_measure'],
      netMeasureUnits: json['net_measure_units'],
      barcode: json['barcode'],
      stockWarehouse: json['stock_warehouse'] as List<dynamic>?,
      fkDefaultWarehouse: json['fk_default_warehouse'],
      fkPriceExpression: json['fk_price_expression'],
      fournQty: json['fourn_qty'],
      fkUnit: json['fk_unit'],
      priceAutogen: json['price_autogen'],
      sousprods: json['sousprods'],
      res: json['res'],
      isObjectUsed: json['is_object_used'],
      isSousproduitQty: json['is_sousproduit_qty'],
      isSousproduitIncdec: json['is_sousproduit_incdec'],
      mandatoryPeriod: json['mandatory_period'],
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'module': instance.module,
      'id': instance.id,
      'entity': instance.entity,
      'import_key': instance.importKey,
      'array_options': instance.arrayOptions,
      'array_languages': instance.arrayLanguages,
      'contacts_ids': instance.contactsIds,
      'canvas': instance.canvas,
      'origin_type': instance.originType,
      'ref': instance.ref,
      'ref_ext': instance.refExt,
      'status': instance.status,
      'country_id': instance.countryId,
      'country_code': instance.countryCode,
      'state_id': instance.stateId,
      'region_id': instance.regionId,
      'barcode_type': instance.barcodeType,
      'barcode_type_coder': instance.barcodeTypeCoder,
      'shipping_method': instance.shippingMethod,
      'fk_multicurrency': instance.fkMulticurrency,
      'multicurrency_code': instance.multicurrencyCode,
      'multicurrency_tx': instance.multicurrencyTx,
      'multicurrency_total_ht': instance.multicurrencyTotalHt,
      'multicurrency_total_tva': instance.multicurrencyTotalTva,
      'multicurrency_total_ttc': instance.multicurrencyTotalTtc,
      'multicurrency_total_localtax1': instance.multicurrencyTotalLocaltax1,
      'multicurrency_total_localtax2': instance.multicurrencyTotalLocaltax2,
      'total_ttc': instance.totalTtc,
      'actiontypecode': instance.actiontypecode,
      'date_creation': instance.dateCreation,
      'date_validation': instance.dateValidation,
      'date_modification': instance.dateModification,
      'tms': instance.tms,
      'date_cloture': instance.dateCloture,
      'specimen': instance.specimen,
      'totalpaid': instance.totalpaid,
      'product': instance.product,
      'cond_reglement_supplier_id': instance.condReglementSupplierId,
      'retained_warranty_fk_cond_reglement':
          instance.retainedWarrantyFkCondReglement,
      'warehouse_id': instance.warehouseId,
      'label': instance.label,
      'other': instance.other,
      'type': instance.type,
      'price': instance.price,
      'price_formated': instance.priceFormated,
      'price_ttc': instance.priceTtc,
      'price_ttc_formated': instance.priceTtcFormated,
      'price_min': instance.priceMin,
      'price_min_ttc': instance.priceMinTtc,
      'price_base_type': instance.priceBaseType,
      'price_label': instance.priceLabel,
      'multiprices': instance.multiprices,
      'multiprices_ttc': instance.multipricesTtc,
      'multiprices_base_type': instance.multipricesBaseType,
      'multiprices_default_vat_code': instance.multipricesDefaultVatCode,
      'multiprices_min': instance.multipricesMin,
      'multiprices_min_ttc': instance.multipricesMinTtc,
      'multiprices_tva_tx': instance.multipricesTvaTx,
      'prices_by_qty': instance.pricesByQty,
      'prices_by_qty_list': instance.pricesByQtyList,
      'level': instance.level,
      'default_vat_code': instance.defaultVatCode,
      'tva_tx': instance.tvaTx,
      'remise_percent': instance.remisePercent,
      'localtax1_tx': instance.localtax1Tx,
      'localtax2_tx': instance.localtax2Tx,
      'localtax1_type': instance.localtax1Type,
      'localtax2_type': instance.localtax2Type,
      'desc_supplier': instance.descSupplier,
      'vatrate_supplier': instance.vatrateSupplier,
      'default_vat_code_supplier': instance.defaultVatCodeSupplier,
      'fourn_multicurrency_price': instance.fournMulticurrencyPrice,
      'fourn_multicurrency_unitprice': instance.fournMulticurrencyUnitprice,
      'fourn_multicurrency_tx': instance.fournMulticurrencyTx,
      'fourn_multicurrency_id': instance.fournMulticurrencyId,
      'fourn_multicurrency_code': instance.fournMulticurrencyCode,
      'packaging': instance.packaging,
      'lifetime': instance.lifetime,
      'qc_frequency': instance.qcFrequency,
      'stock_reel': instance.stockReel,
      'stock_theorique': instance.stockTheorique,
      'cost_price': instance.costPrice,
      'pmp': instance.pmp,
      'seuil_stock_alerte': instance.seuilStockAlerte,
      'desiredstock': instance.desiredstock,
      'duration_value': instance.durationValue,
      'duration_unit': instance.durationUnit,
      'duration': instance.duration,
      'tosell': instance.tosell,
      'status_buy': instance.statusBuy,
      'tobuy': instance.tobuy,
      'finished': instance.finished,
      'fk_default_bom': instance.fkDefaultBom,
      'product_fourn_price_id': instance.productFournPriceId,
      'buyprice': instance.buyprice,
      'tobatch': instance.tobatch,
      'status_batch': instance.statusBatch,
      'sell_or_eat_by_mandatory': instance.sellOrEatByMandatory,
      'batch_mask': instance.batchMask,
      'customcode': instance.customcode,
      'url': instance.url,
      'weight': instance.weight,
      'weight_units': instance.weightUnits,
      'length': instance.length,
      'length_units': instance.lengthUnits,
      'width': instance.width,
      'width_units': instance.widthUnits,
      'height': instance.height,
      'height_units': instance.heightUnits,
      'surface': instance.surface,
      'surface_units': instance.surfaceUnits,
      'volume': instance.volume,
      'volume_units': instance.volumeUnits,
      'net_measure': instance.netMeasure,
      'net_measure_units': instance.netMeasureUnits,
      'barcode': instance.barcode,
      'stock_warehouse': instance.stockWarehouse,
      'fk_default_warehouse': instance.fkDefaultWarehouse,
      'fk_price_expression': instance.fkPriceExpression,
      'fourn_qty': instance.fournQty,
      'fk_unit': instance.fkUnit,
      'price_autogen': instance.priceAutogen,
      'sousprods': instance.sousprods,
      'res': instance.res,
      'is_object_used': instance.isObjectUsed,
      'is_sousproduit_qty': instance.isSousproduitQty,
      'is_sousproduit_incdec': instance.isSousproduitIncdec,
      'mandatory_period': instance.mandatoryPeriod,
    };
