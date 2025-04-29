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
      label: fields[1] as String?,
      description: fields[2] as String?,
      other: fields[3] as dynamic,
      type: fields[4] as String?,
      price: fields[5] as String?,
      priceFormated: fields[6] as dynamic,
      priceTtc: fields[7] as String?,
      priceTtcFormated: fields[8] as dynamic,
      priceMin: fields[9] as String?,
      priceMinTtc: fields[10] as String?,
      priceBaseType: fields[11] as String?,
      multiprices: (fields[12] as List?)?.cast<dynamic>(),
      multipricesTtc: (fields[13] as List?)?.cast<dynamic>(),
      multipricesBaseType: (fields[14] as List?)?.cast<dynamic>(),
      multipricesMin: (fields[15] as List?)?.cast<dynamic>(),
      multipricesMinTtc: (fields[16] as List?)?.cast<dynamic>(),
      multipricesTvaTx: (fields[17] as List?)?.cast<dynamic>(),
      pricesByQty: (fields[18] as List?)?.cast<dynamic>(),
      pricesByQtyList: (fields[19] as List?)?.cast<dynamic>(),
      multilangs: (fields[20] as List?)?.cast<dynamic>(),
      defaultVatCode: fields[21] as dynamic,
      tvaTx: fields[22] as String?,
      remisePercent: fields[23] as dynamic,
      localtax1Tx: fields[24] as String?,
      localtax2Tx: fields[25] as String?,
      localtax1Type: fields[26] as String?,
      localtax2Type: fields[27] as String?,
      descSupplier: fields[28] as dynamic,
      vatrateSupplier: fields[29] as dynamic,
      defaultVatCodeSupplier: fields[30] as dynamic,
      fournMulticurrencyPrice: fields[31] as dynamic,
      fournMulticurrencyUnitprice: fields[32] as dynamic,
      fournMulticurrencyTx: fields[33] as dynamic,
      fournMulticurrencyId: fields[34] as dynamic,
      fournMulticurrencyCode: fields[35] as dynamic,
      packaging: fields[36] as dynamic,
      lifetime: fields[37] as dynamic,
      qcFrequency: fields[38] as dynamic,
      stockReel: fields[39] as dynamic,
      stockTheorique: fields[40] as dynamic,
      costPrice: fields[41] as dynamic,
      pmp: fields[42] as String?,
      seuilStockAlerte: fields[43] as String?,
      desiredstock: fields[44] as String?,
      durationValue: fields[45] as dynamic,
      durationUnit: fields[46] as dynamic,
      duration: fields[47] as String?,
      fkDefaultWorkstation: fields[48] as dynamic,
      status: fields[49] as String?,
      tosell: fields[50] as dynamic,
      statusBuy: fields[51] as String?,
      tobuy: fields[52] as dynamic,
      finished: fields[53] as String?,
      fkDefaultBom: fields[54] as dynamic,
      statusBatch: fields[55] as String?,
      batchMask: fields[56] as String?,
      customcode: fields[57] as String?,
      url: fields[58] as dynamic,
      weight: fields[59] as dynamic,
      weightUnits: fields[60] as dynamic,
      length: fields[61] as dynamic,
      lengthUnits: fields[62] as dynamic,
      width: fields[63] as dynamic,
      widthUnits: fields[64] as dynamic,
      height: fields[65] as dynamic,
      heightUnits: fields[66] as dynamic,
      surface: fields[67] as dynamic,
      surfaceUnits: fields[68] as dynamic,
      volume: fields[69] as dynamic,
      volumeUnits: fields[70] as dynamic,
      netMeasure: fields[71] as dynamic,
      netMeasureUnits: fields[72] as dynamic,
      accountancyCodeSell: fields[73] as String?,
      accountancyCodeSellIntra: fields[74] as String?,
      accountancyCodeSellExport: fields[75] as String?,
      accountancyCodeBuy: fields[76] as String?,
      accountancyCodeBuyIntra: fields[77] as String?,
      accountancyCodeBuyExport: fields[78] as String?,
      barcode: fields[79] as dynamic,
      barcodeType: fields[80] as dynamic,
      statsProposalSupplier: (fields[81] as List?)?.cast<dynamic>(),
      statsExpedition: (fields[82] as List?)?.cast<dynamic>(),
      statsMo: (fields[83] as List?)?.cast<dynamic>(),
      statsBom: (fields[84] as List?)?.cast<dynamic>(),
      statsFacturerec: (fields[85] as List?)?.cast<dynamic>(),
      statsFactureFournisseur: (fields[86] as List?)?.cast<dynamic>(),
      dateCreation: fields[87] as DateTime?,
      dateModification: fields[88] as DateTime?,
      stockWarehouse: (fields[89] as List?)?.cast<dynamic>(),
      fkDefaultWarehouse: fields[90] as String?,
      fkPriceExpression: fields[91] as dynamic,
      fournQty: fields[92] as dynamic,
      fkUnit: fields[93] as dynamic,
      priceAutogen: fields[94] as String?,
      sousprods: fields[95] as dynamic,
      res: fields[96] as dynamic,
      isObjectUsed: fields[97] as dynamic,
      mandatoryPeriod: fields[98] as String?,
      module: fields[99] as dynamic,
      id: fields[100] as String?,
      entity: fields[101] as String?,
      importKey: fields[102] as dynamic,
      arrayOptions: (fields[103] as List?)?.cast<dynamic>(),
      arrayLanguages: fields[104] as dynamic,
      contactsIds: fields[105] as dynamic,
      linkedObjects: fields[106] as dynamic,
      linkedObjectsIds: fields[107] as dynamic,
      oldref: fields[108] as dynamic,
      canvas: fields[109] as String?,
      ref: fields[110] as String?,
      refExt: fields[111] as dynamic,
      countryId: fields[112] as dynamic,
      countryCode: fields[113] as String?,
      stateId: fields[114] as dynamic,
      regionId: fields[115] as dynamic,
      barcodeTypeCoder: fields[116] as dynamic,
      shippingMethod: fields[117] as dynamic,
      multicurrencyCode: fields[118] as dynamic,
      multicurrencyTx: fields[119] as dynamic,
      lastMainDoc: fields[120] as dynamic,
      notePublic: fields[121] as dynamic,
      notePrivate: fields[122] as String?,
      totalHt: fields[123] as dynamic,
      totalTva: fields[124] as dynamic,
      totalLocaltax1: fields[125] as dynamic,
      totalLocaltax2: fields[126] as dynamic,
      totalTtc: fields[127] as dynamic,
      dateValidation: fields[128] as dynamic,
      dateUpdate: fields[129] as dynamic,
      dateCloture: fields[130] as dynamic,
      userAuthor: fields[131] as dynamic,
      userCreation: fields[132] as dynamic,
      userCreationId: fields[133] as dynamic,
      userValid: fields[134] as dynamic,
      userValidation: fields[135] as dynamic,
      userValidationId: fields[136] as dynamic,
      userClosingId: fields[137] as dynamic,
      userModification: fields[138] as dynamic,
      userModificationId: fields[139] as dynamic,
      specimen: (fields[140] as num?)?.toInt(),
      labelStatus: fields[141] as dynamic,
      showphotoOnPopup: fields[142] as dynamic,
      nb: (fields[143] as List?)?.cast<dynamic>(),
      output: fields[144] as dynamic,
      extraparams: (fields[145] as List?)?.cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(145)
      ..writeByte(1)
      ..write(obj.label)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.other)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.priceFormated)
      ..writeByte(7)
      ..write(obj.priceTtc)
      ..writeByte(8)
      ..write(obj.priceTtcFormated)
      ..writeByte(9)
      ..write(obj.priceMin)
      ..writeByte(10)
      ..write(obj.priceMinTtc)
      ..writeByte(11)
      ..write(obj.priceBaseType)
      ..writeByte(12)
      ..write(obj.multiprices)
      ..writeByte(13)
      ..write(obj.multipricesTtc)
      ..writeByte(14)
      ..write(obj.multipricesBaseType)
      ..writeByte(15)
      ..write(obj.multipricesMin)
      ..writeByte(16)
      ..write(obj.multipricesMinTtc)
      ..writeByte(17)
      ..write(obj.multipricesTvaTx)
      ..writeByte(18)
      ..write(obj.pricesByQty)
      ..writeByte(19)
      ..write(obj.pricesByQtyList)
      ..writeByte(20)
      ..write(obj.multilangs)
      ..writeByte(21)
      ..write(obj.defaultVatCode)
      ..writeByte(22)
      ..write(obj.tvaTx)
      ..writeByte(23)
      ..write(obj.remisePercent)
      ..writeByte(24)
      ..write(obj.localtax1Tx)
      ..writeByte(25)
      ..write(obj.localtax2Tx)
      ..writeByte(26)
      ..write(obj.localtax1Type)
      ..writeByte(27)
      ..write(obj.localtax2Type)
      ..writeByte(28)
      ..write(obj.descSupplier)
      ..writeByte(29)
      ..write(obj.vatrateSupplier)
      ..writeByte(30)
      ..write(obj.defaultVatCodeSupplier)
      ..writeByte(31)
      ..write(obj.fournMulticurrencyPrice)
      ..writeByte(32)
      ..write(obj.fournMulticurrencyUnitprice)
      ..writeByte(33)
      ..write(obj.fournMulticurrencyTx)
      ..writeByte(34)
      ..write(obj.fournMulticurrencyId)
      ..writeByte(35)
      ..write(obj.fournMulticurrencyCode)
      ..writeByte(36)
      ..write(obj.packaging)
      ..writeByte(37)
      ..write(obj.lifetime)
      ..writeByte(38)
      ..write(obj.qcFrequency)
      ..writeByte(39)
      ..write(obj.stockReel)
      ..writeByte(40)
      ..write(obj.stockTheorique)
      ..writeByte(41)
      ..write(obj.costPrice)
      ..writeByte(42)
      ..write(obj.pmp)
      ..writeByte(43)
      ..write(obj.seuilStockAlerte)
      ..writeByte(44)
      ..write(obj.desiredstock)
      ..writeByte(45)
      ..write(obj.durationValue)
      ..writeByte(46)
      ..write(obj.durationUnit)
      ..writeByte(47)
      ..write(obj.duration)
      ..writeByte(48)
      ..write(obj.fkDefaultWorkstation)
      ..writeByte(49)
      ..write(obj.status)
      ..writeByte(50)
      ..write(obj.tosell)
      ..writeByte(51)
      ..write(obj.statusBuy)
      ..writeByte(52)
      ..write(obj.tobuy)
      ..writeByte(53)
      ..write(obj.finished)
      ..writeByte(54)
      ..write(obj.fkDefaultBom)
      ..writeByte(55)
      ..write(obj.statusBatch)
      ..writeByte(56)
      ..write(obj.batchMask)
      ..writeByte(57)
      ..write(obj.customcode)
      ..writeByte(58)
      ..write(obj.url)
      ..writeByte(59)
      ..write(obj.weight)
      ..writeByte(60)
      ..write(obj.weightUnits)
      ..writeByte(61)
      ..write(obj.length)
      ..writeByte(62)
      ..write(obj.lengthUnits)
      ..writeByte(63)
      ..write(obj.width)
      ..writeByte(64)
      ..write(obj.widthUnits)
      ..writeByte(65)
      ..write(obj.height)
      ..writeByte(66)
      ..write(obj.heightUnits)
      ..writeByte(67)
      ..write(obj.surface)
      ..writeByte(68)
      ..write(obj.surfaceUnits)
      ..writeByte(69)
      ..write(obj.volume)
      ..writeByte(70)
      ..write(obj.volumeUnits)
      ..writeByte(71)
      ..write(obj.netMeasure)
      ..writeByte(72)
      ..write(obj.netMeasureUnits)
      ..writeByte(73)
      ..write(obj.accountancyCodeSell)
      ..writeByte(74)
      ..write(obj.accountancyCodeSellIntra)
      ..writeByte(75)
      ..write(obj.accountancyCodeSellExport)
      ..writeByte(76)
      ..write(obj.accountancyCodeBuy)
      ..writeByte(77)
      ..write(obj.accountancyCodeBuyIntra)
      ..writeByte(78)
      ..write(obj.accountancyCodeBuyExport)
      ..writeByte(79)
      ..write(obj.barcode)
      ..writeByte(80)
      ..write(obj.barcodeType)
      ..writeByte(81)
      ..write(obj.statsProposalSupplier)
      ..writeByte(82)
      ..write(obj.statsExpedition)
      ..writeByte(83)
      ..write(obj.statsMo)
      ..writeByte(84)
      ..write(obj.statsBom)
      ..writeByte(85)
      ..write(obj.statsFacturerec)
      ..writeByte(86)
      ..write(obj.statsFactureFournisseur)
      ..writeByte(87)
      ..write(obj.dateCreation)
      ..writeByte(88)
      ..write(obj.dateModification)
      ..writeByte(89)
      ..write(obj.stockWarehouse)
      ..writeByte(90)
      ..write(obj.fkDefaultWarehouse)
      ..writeByte(91)
      ..write(obj.fkPriceExpression)
      ..writeByte(92)
      ..write(obj.fournQty)
      ..writeByte(93)
      ..write(obj.fkUnit)
      ..writeByte(94)
      ..write(obj.priceAutogen)
      ..writeByte(95)
      ..write(obj.sousprods)
      ..writeByte(96)
      ..write(obj.res)
      ..writeByte(97)
      ..write(obj.isObjectUsed)
      ..writeByte(98)
      ..write(obj.mandatoryPeriod)
      ..writeByte(99)
      ..write(obj.module)
      ..writeByte(100)
      ..write(obj.id)
      ..writeByte(101)
      ..write(obj.entity)
      ..writeByte(102)
      ..write(obj.importKey)
      ..writeByte(103)
      ..write(obj.arrayOptions)
      ..writeByte(104)
      ..write(obj.arrayLanguages)
      ..writeByte(105)
      ..write(obj.contactsIds)
      ..writeByte(106)
      ..write(obj.linkedObjects)
      ..writeByte(107)
      ..write(obj.linkedObjectsIds)
      ..writeByte(108)
      ..write(obj.oldref)
      ..writeByte(109)
      ..write(obj.canvas)
      ..writeByte(110)
      ..write(obj.ref)
      ..writeByte(111)
      ..write(obj.refExt)
      ..writeByte(112)
      ..write(obj.countryId)
      ..writeByte(113)
      ..write(obj.countryCode)
      ..writeByte(114)
      ..write(obj.stateId)
      ..writeByte(115)
      ..write(obj.regionId)
      ..writeByte(116)
      ..write(obj.barcodeTypeCoder)
      ..writeByte(117)
      ..write(obj.shippingMethod)
      ..writeByte(118)
      ..write(obj.multicurrencyCode)
      ..writeByte(119)
      ..write(obj.multicurrencyTx)
      ..writeByte(120)
      ..write(obj.lastMainDoc)
      ..writeByte(121)
      ..write(obj.notePublic)
      ..writeByte(122)
      ..write(obj.notePrivate)
      ..writeByte(123)
      ..write(obj.totalHt)
      ..writeByte(124)
      ..write(obj.totalTva)
      ..writeByte(125)
      ..write(obj.totalLocaltax1)
      ..writeByte(126)
      ..write(obj.totalLocaltax2)
      ..writeByte(127)
      ..write(obj.totalTtc)
      ..writeByte(128)
      ..write(obj.dateValidation)
      ..writeByte(129)
      ..write(obj.dateUpdate)
      ..writeByte(130)
      ..write(obj.dateCloture)
      ..writeByte(131)
      ..write(obj.userAuthor)
      ..writeByte(132)
      ..write(obj.userCreation)
      ..writeByte(133)
      ..write(obj.userCreationId)
      ..writeByte(134)
      ..write(obj.userValid)
      ..writeByte(135)
      ..write(obj.userValidation)
      ..writeByte(136)
      ..write(obj.userValidationId)
      ..writeByte(137)
      ..write(obj.userClosingId)
      ..writeByte(138)
      ..write(obj.userModification)
      ..writeByte(139)
      ..write(obj.userModificationId)
      ..writeByte(140)
      ..write(obj.specimen)
      ..writeByte(141)
      ..write(obj.labelStatus)
      ..writeByte(142)
      ..write(obj.showphotoOnPopup)
      ..writeByte(143)
      ..write(obj.nb)
      ..writeByte(144)
      ..write(obj.output)
      ..writeByte(145)
      ..write(obj.extraparams);
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
