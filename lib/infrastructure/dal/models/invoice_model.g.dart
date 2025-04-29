// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InvoiceModelAdapter extends TypeAdapter<InvoiceModel> {
  @override
  final typeId = 1;

  @override
  InvoiceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InvoiceModel(
      module: fields[1] as dynamic,
      id: fields[3] as dynamic,
      entity: fields[5] as dynamic,
      importKey: fields[7] as dynamic,
      arrayOptions: (fields[9] as List?)?.cast<dynamic>(),
      arrayLanguages: fields[11] as dynamic,
      contactsIds: (fields[13] as List?)?.cast<dynamic>(),
      linkedObjectsIds: fields[15] as dynamic,
      fkProject: fields[17] as dynamic,
      contactId: fields[19] as dynamic,
      user: fields[21] as dynamic,
      originType: fields[23] as dynamic,
      originId: fields[25] as dynamic,
      ref: fields[27] as dynamic,
      refExt: fields[29] as dynamic,
      statut: fields[31] as dynamic,
      status: fields[33] as dynamic,
      countryId: fields[35] as dynamic,
      countryCode: fields[37] as dynamic,
      stateId: fields[39] as dynamic,
      regionId: fields[41] as dynamic,
      modeReglementId: fields[43] as dynamic,
      condReglementId: fields[45] as dynamic,
      demandReasonId: fields[47] as dynamic,
      transportModeId: fields[49] as dynamic,
      shippingMethodId: fields[51] as dynamic,
      shippingMethod: fields[53] as dynamic,
      fkMulticurrency: fields[55] as dynamic,
      multicurrencyCode: fields[57] as dynamic,
      multicurrencyTx: fields[59] as dynamic,
      multicurrencyTotalHt: fields[61] as dynamic,
      multicurrencyTotalTva: fields[63] as dynamic,
      multicurrencyTotalTtc: fields[65] as dynamic,
      multicurrencyTotalLocaltax1: fields[67] as dynamic,
      multicurrencyTotalLocaltax2: fields[69] as dynamic,
      lastMainDoc: fields[71] as dynamic,
      fkAccount: fields[73] as dynamic,
      notePublic: fields[75] as dynamic,
      notePrivate: fields[77] as dynamic,
      totalHt: fields[79] as dynamic,
      totalTva: fields[81] as dynamic,
      totalLocaltax1: fields[83] as dynamic,
      totalLocaltax2: fields[85] as dynamic,
      totalTtc: fields[87] as dynamic,
      lines: (fields[89] as List?)?.cast<Line>(),
      actiontypecode: fields[91] as dynamic,
      name: fields[93] as dynamic,
      lastname: fields[95] as dynamic,
      firstname: fields[97] as dynamic,
      civilityId: fields[99] as dynamic,
      dateCreation: fields[101] as dynamic,
      dateValidation: fields[103] as dynamic,
      dateModification: fields[105] as dynamic,
      tms: fields[107] as dynamic,
      dateCloture: fields[109] as dynamic,
      userAuthor: fields[111] as dynamic,
      userCreation: fields[113] as dynamic,
      userCreationId: fields[115] as dynamic,
      userValid: fields[117] as dynamic,
      userValidation: fields[119] as dynamic,
      userValidationId: fields[121] as dynamic,
      userClosingId: fields[123] as dynamic,
      userModification: fields[125] as dynamic,
      userModificationId: fields[127] as dynamic,
      fkUserCreat: fields[129] as dynamic,
      fkUserModif: fields[131] as dynamic,
      specimen: fields[133] as dynamic,
      totalpaid: fields[135] as dynamic,
      extraparams: (fields[137] as Map?)?.cast<String, dynamic>(),
      product: fields[139] as dynamic,
      condReglementSupplierId: fields[141] as dynamic,
      depositPercent: fields[143] as dynamic,
      retainedWarrantyFkCondReglement: fields[145] as dynamic,
      warehouseId: fields[147] as dynamic,
      title: fields[149] as dynamic,
      type: fields[151] as dynamic,
      subtype: fields[153] as dynamic,
      fkSoc: fields[155] as dynamic,
      socid: fields[157] as dynamic,
      paye: fields[159] as dynamic,
      date: fields[161] as dynamic,
      dateLimReglement: fields[163] as dynamic,
      condReglementCode: fields[165] as dynamic,
      condReglementLabel: fields[167] as dynamic,
      condReglementDoc: fields[169] as dynamic,
      modeReglementCode: fields[171] as dynamic,
      revenuestamp: fields[173] as dynamic,
      totaldeposits: fields[175] as dynamic,
      totalcreditnotes: fields[177] as dynamic,
      sumpayed: fields[179] as dynamic,
      sumpayedMulticurrency: fields[181] as dynamic,
      sumdeposit: fields[183] as dynamic,
      sumdepositMulticurrency: fields[185] as dynamic,
      sumcreditnote: fields[187] as dynamic,
      sumcreditnoteMulticurrency: fields[189] as dynamic,
      remaintopay: fields[191] as dynamic,
      nbofopendirectdebitorcredittransfer: fields[193] as dynamic,
      description: fields[195] as dynamic,
      refClient: fields[197] as dynamic,
      situationCycleRef: fields[199] as dynamic,
      closeCode: fields[201] as dynamic,
      closeNote: fields[203] as dynamic,
      postactionmessages: fields[205] as dynamic,
      fkIncoterms: fields[207] as dynamic,
      labelIncoterms: fields[209] as dynamic,
      locationIncoterms: fields[211] as dynamic,
      fkUserAuthor: fields[213] as dynamic,
      fkUserValid: fields[215] as dynamic,
      datem: fields[217] as dynamic,
      deliveryDate: fields[219] as dynamic,
      refCustomer: fields[221] as dynamic,
      resteapayer: fields[223] as dynamic,
      moduleSource: fields[225] as dynamic,
      posSource: fields[227] as dynamic,
      fkFacRecSource: fields[229] as dynamic,
      fkFactureSource: fields[231] as dynamic,
      line: fields[233] as Line?,
      facRec: fields[235] as dynamic,
      datePointoftax: fields[237] as dynamic,
      situationCounter: fields[239] as dynamic,
      situationFinal: fields[241] as dynamic,
      tabPreviousSituationInvoice: (fields[243] as List?)?.cast<dynamic>(),
      tabNextSituationInvoice: (fields[245] as List?)?.cast<dynamic>(),
      retainedWarranty: fields[247] as dynamic,
      retainedWarrantyDateLimit: fields[249] as dynamic,
      dateClosing: fields[251] as dynamic,
      remisePercent: fields[253] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, InvoiceModel obj) {
    writer
      ..writeByte(127)
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
      ..write(obj.linkedObjectsIds)
      ..writeByte(17)
      ..write(obj.fkProject)
      ..writeByte(19)
      ..write(obj.contactId)
      ..writeByte(21)
      ..write(obj.user)
      ..writeByte(23)
      ..write(obj.originType)
      ..writeByte(25)
      ..write(obj.originId)
      ..writeByte(27)
      ..write(obj.ref)
      ..writeByte(29)
      ..write(obj.refExt)
      ..writeByte(31)
      ..write(obj.statut)
      ..writeByte(33)
      ..write(obj.status)
      ..writeByte(35)
      ..write(obj.countryId)
      ..writeByte(37)
      ..write(obj.countryCode)
      ..writeByte(39)
      ..write(obj.stateId)
      ..writeByte(41)
      ..write(obj.regionId)
      ..writeByte(43)
      ..write(obj.modeReglementId)
      ..writeByte(45)
      ..write(obj.condReglementId)
      ..writeByte(47)
      ..write(obj.demandReasonId)
      ..writeByte(49)
      ..write(obj.transportModeId)
      ..writeByte(51)
      ..write(obj.shippingMethodId)
      ..writeByte(53)
      ..write(obj.shippingMethod)
      ..writeByte(55)
      ..write(obj.fkMulticurrency)
      ..writeByte(57)
      ..write(obj.multicurrencyCode)
      ..writeByte(59)
      ..write(obj.multicurrencyTx)
      ..writeByte(61)
      ..write(obj.multicurrencyTotalHt)
      ..writeByte(63)
      ..write(obj.multicurrencyTotalTva)
      ..writeByte(65)
      ..write(obj.multicurrencyTotalTtc)
      ..writeByte(67)
      ..write(obj.multicurrencyTotalLocaltax1)
      ..writeByte(69)
      ..write(obj.multicurrencyTotalLocaltax2)
      ..writeByte(71)
      ..write(obj.lastMainDoc)
      ..writeByte(73)
      ..write(obj.fkAccount)
      ..writeByte(75)
      ..write(obj.notePublic)
      ..writeByte(77)
      ..write(obj.notePrivate)
      ..writeByte(79)
      ..write(obj.totalHt)
      ..writeByte(81)
      ..write(obj.totalTva)
      ..writeByte(83)
      ..write(obj.totalLocaltax1)
      ..writeByte(85)
      ..write(obj.totalLocaltax2)
      ..writeByte(87)
      ..write(obj.totalTtc)
      ..writeByte(89)
      ..write(obj.lines)
      ..writeByte(91)
      ..write(obj.actiontypecode)
      ..writeByte(93)
      ..write(obj.name)
      ..writeByte(95)
      ..write(obj.lastname)
      ..writeByte(97)
      ..write(obj.firstname)
      ..writeByte(99)
      ..write(obj.civilityId)
      ..writeByte(101)
      ..write(obj.dateCreation)
      ..writeByte(103)
      ..write(obj.dateValidation)
      ..writeByte(105)
      ..write(obj.dateModification)
      ..writeByte(107)
      ..write(obj.tms)
      ..writeByte(109)
      ..write(obj.dateCloture)
      ..writeByte(111)
      ..write(obj.userAuthor)
      ..writeByte(113)
      ..write(obj.userCreation)
      ..writeByte(115)
      ..write(obj.userCreationId)
      ..writeByte(117)
      ..write(obj.userValid)
      ..writeByte(119)
      ..write(obj.userValidation)
      ..writeByte(121)
      ..write(obj.userValidationId)
      ..writeByte(123)
      ..write(obj.userClosingId)
      ..writeByte(125)
      ..write(obj.userModification)
      ..writeByte(127)
      ..write(obj.userModificationId)
      ..writeByte(129)
      ..write(obj.fkUserCreat)
      ..writeByte(131)
      ..write(obj.fkUserModif)
      ..writeByte(133)
      ..write(obj.specimen)
      ..writeByte(135)
      ..write(obj.totalpaid)
      ..writeByte(137)
      ..write(obj.extraparams)
      ..writeByte(139)
      ..write(obj.product)
      ..writeByte(141)
      ..write(obj.condReglementSupplierId)
      ..writeByte(143)
      ..write(obj.depositPercent)
      ..writeByte(145)
      ..write(obj.retainedWarrantyFkCondReglement)
      ..writeByte(147)
      ..write(obj.warehouseId)
      ..writeByte(149)
      ..write(obj.title)
      ..writeByte(151)
      ..write(obj.type)
      ..writeByte(153)
      ..write(obj.subtype)
      ..writeByte(155)
      ..write(obj.fkSoc)
      ..writeByte(157)
      ..write(obj.socid)
      ..writeByte(159)
      ..write(obj.paye)
      ..writeByte(161)
      ..write(obj.date)
      ..writeByte(163)
      ..write(obj.dateLimReglement)
      ..writeByte(165)
      ..write(obj.condReglementCode)
      ..writeByte(167)
      ..write(obj.condReglementLabel)
      ..writeByte(169)
      ..write(obj.condReglementDoc)
      ..writeByte(171)
      ..write(obj.modeReglementCode)
      ..writeByte(173)
      ..write(obj.revenuestamp)
      ..writeByte(175)
      ..write(obj.totaldeposits)
      ..writeByte(177)
      ..write(obj.totalcreditnotes)
      ..writeByte(179)
      ..write(obj.sumpayed)
      ..writeByte(181)
      ..write(obj.sumpayedMulticurrency)
      ..writeByte(183)
      ..write(obj.sumdeposit)
      ..writeByte(185)
      ..write(obj.sumdepositMulticurrency)
      ..writeByte(187)
      ..write(obj.sumcreditnote)
      ..writeByte(189)
      ..write(obj.sumcreditnoteMulticurrency)
      ..writeByte(191)
      ..write(obj.remaintopay)
      ..writeByte(193)
      ..write(obj.nbofopendirectdebitorcredittransfer)
      ..writeByte(195)
      ..write(obj.description)
      ..writeByte(197)
      ..write(obj.refClient)
      ..writeByte(199)
      ..write(obj.situationCycleRef)
      ..writeByte(201)
      ..write(obj.closeCode)
      ..writeByte(203)
      ..write(obj.closeNote)
      ..writeByte(205)
      ..write(obj.postactionmessages)
      ..writeByte(207)
      ..write(obj.fkIncoterms)
      ..writeByte(209)
      ..write(obj.labelIncoterms)
      ..writeByte(211)
      ..write(obj.locationIncoterms)
      ..writeByte(213)
      ..write(obj.fkUserAuthor)
      ..writeByte(215)
      ..write(obj.fkUserValid)
      ..writeByte(217)
      ..write(obj.datem)
      ..writeByte(219)
      ..write(obj.deliveryDate)
      ..writeByte(221)
      ..write(obj.refCustomer)
      ..writeByte(223)
      ..write(obj.resteapayer)
      ..writeByte(225)
      ..write(obj.moduleSource)
      ..writeByte(227)
      ..write(obj.posSource)
      ..writeByte(229)
      ..write(obj.fkFacRecSource)
      ..writeByte(231)
      ..write(obj.fkFactureSource)
      ..writeByte(233)
      ..write(obj.line)
      ..writeByte(235)
      ..write(obj.facRec)
      ..writeByte(237)
      ..write(obj.datePointoftax)
      ..writeByte(239)
      ..write(obj.situationCounter)
      ..writeByte(241)
      ..write(obj.situationFinal)
      ..writeByte(243)
      ..write(obj.tabPreviousSituationInvoice)
      ..writeByte(245)
      ..write(obj.tabNextSituationInvoice)
      ..writeByte(247)
      ..write(obj.retainedWarranty)
      ..writeByte(249)
      ..write(obj.retainedWarrantyDateLimit)
      ..writeByte(251)
      ..write(obj.dateClosing)
      ..writeByte(253)
      ..write(obj.remisePercent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LineAdapter extends TypeAdapter<Line> {
  @override
  final typeId = 2;

  @override
  Line read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Line(
      module: fields[1] as dynamic,
      id: fields[3] as dynamic,
      entity: fields[5] as dynamic,
      importKey: fields[7] as dynamic,
      arrayOptions: (fields[9] as List?)?.cast<dynamic>(),
      arrayLanguages: fields[11] as dynamic,
      contactsIds: fields[13] as dynamic,
      linkedObjectsIds: fields[15] as dynamic,
      originType: fields[17] as dynamic,
      originId: fields[19] as dynamic,
      ref: fields[21] as dynamic,
      refExt: fields[23] as dynamic,
      statut: fields[25] as dynamic,
      status: fields[27] as dynamic,
      stateId: fields[29] as dynamic,
      regionId: fields[31] as dynamic,
      demandReasonId: fields[33] as dynamic,
      transportModeId: fields[35] as dynamic,
      shippingMethod: fields[37] as dynamic,
      multicurrencyTx: fields[39] as dynamic,
      multicurrencyTotalHt: fields[41] as dynamic,
      multicurrencyTotalTva: fields[43] as dynamic,
      multicurrencyTotalTtc: fields[45] as dynamic,
      multicurrencyTotalLocaltax1: fields[47] as dynamic,
      multicurrencyTotalLocaltax2: fields[49] as dynamic,
      lastMainDoc: fields[51] as dynamic,
      fkAccount: fields[53] as dynamic,
      totalHt: fields[55] as dynamic,
      totalTva: fields[57] as dynamic,
      totalLocaltax1: fields[59] as dynamic,
      totalLocaltax2: fields[61] as dynamic,
      totalTtc: fields[63] as dynamic,
      lines: (fields[65] as List?)?.cast<Line>(),
      actiontypecode: fields[67] as dynamic,
      dateCreation: fields[69] as dynamic,
      dateValidation: fields[71] as dynamic,
      dateModification: fields[73] as dynamic,
      tms: fields[75] as dynamic,
      dateCloture: fields[77] as dynamic,
      userAuthor: fields[79] as dynamic,
      userCreation: fields[81] as dynamic,
      userCreationId: fields[83] as dynamic,
      userValid: fields[85] as dynamic,
      userValidation: fields[87] as dynamic,
      userValidationId: fields[89] as dynamic,
      userClosingId: fields[91] as dynamic,
      userModification: fields[93] as dynamic,
      userModificationId: fields[95] as dynamic,
      fkUserCreat: fields[97] as dynamic,
      fkUserModif: fields[99] as dynamic,
      specimen: fields[101] as dynamic,
      totalpaid: fields[103] as dynamic,
      extraparams: (fields[105] as List?)?.cast<dynamic>(),
      product: fields[107] as dynamic,
      condReglementSupplierId: fields[109] as dynamic,
      depositPercent: fields[111] as dynamic,
      retainedWarrantyFkCondReglement: fields[113] as dynamic,
      warehouseId: fields[115] as dynamic,
      parentElement: fields[117] as dynamic,
      fkParentAttribute: fields[119] as dynamic,
      rowid: fields[121] as dynamic,
      fkUnit: fields[123] as dynamic,
      dateDebutPrevue: fields[125] as dynamic,
      dateDebutReel: fields[127] as dynamic,
      dateFinPrevue: fields[129] as dynamic,
      dateFinReel: fields[131] as dynamic,
      weight: fields[133] as dynamic,
      weightUnits: fields[135] as dynamic,
      length: fields[137] as dynamic,
      lengthUnits: fields[139] as dynamic,
      width: fields[141] as dynamic,
      widthUnits: fields[143] as dynamic,
      height: fields[145] as dynamic,
      heightUnits: fields[147] as dynamic,
      surface: fields[149] as dynamic,
      surfaceUnits: fields[151] as dynamic,
      volume: fields[153] as dynamic,
      volumeUnits: fields[155] as dynamic,
      multilangs: fields[157] as dynamic,
      productType: fields[159] as dynamic,
      fkProduct: fields[161] as dynamic,
      desc: fields[163] as dynamic,
      description: fields[165] as dynamic,
      productRef: fields[167] as dynamic,
      productLabel: fields[169] as dynamic,
      productBarcode: fields[171] as dynamic,
      productDesc: fields[173] as dynamic,
      fkProductType: fields[175] as dynamic,
      qty: fields[177] as dynamic,
      duree: fields[179] as dynamic,
      remisePercent: fields[181] as dynamic,
      infoBits: fields[183] as dynamic,
      specialCode: fields[185] as dynamic,
      subprice: fields[187] as dynamic,
      tvaTx: fields[189] as dynamic,
      multicurrencySubprice: fields[191] as dynamic,
      label: fields[193] as dynamic,
      libelle: fields[195] as dynamic,
      price: fields[197] as dynamic,
      vatSrcCode: fields[199] as dynamic,
      localtax1Tx: fields[201] as dynamic,
      localtax2Tx: fields[203] as dynamic,
      localtax1Type: fields[205] as dynamic,
      localtax2Type: fields[207] as dynamic,
      remise: fields[209] as dynamic,
      dateStartFill: fields[211] as dynamic,
      dateEndFill: fields[213] as dynamic,
      buyPriceHt: fields[215] as dynamic,
      buyprice: fields[217] as dynamic,
      paHt: fields[219] as dynamic,
      margeTx: fields[221] as dynamic,
      marqueTx: fields[223] as dynamic,
      fkUserAuthor: fields[225] as dynamic,
      fkAccountingAccount: fields[227] as dynamic,
      fkFacture: fields[229] as dynamic,
      fkParentLine: fields[231] as dynamic,
      fkRemiseExcept: fields[233] as dynamic,
      rang: fields[235] as dynamic,
      fkFournprice: fields[237] as dynamic,
      tvaNpr: fields[239] as dynamic,
      batch: fields[241] as dynamic,
      fkWarehouse: fields[243] as dynamic,
      fkCodeVentilation: fields[245] as dynamic,
      dateStart: fields[247] as dynamic,
      dateEnd: fields[249] as dynamic,
      situationPercent: fields[251] as dynamic,
      fkPrevId: fields[253] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, Line obj) {
    writer
      ..writeByte(127)
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
      ..write(obj.linkedObjectsIds)
      ..writeByte(17)
      ..write(obj.originType)
      ..writeByte(19)
      ..write(obj.originId)
      ..writeByte(21)
      ..write(obj.ref)
      ..writeByte(23)
      ..write(obj.refExt)
      ..writeByte(25)
      ..write(obj.statut)
      ..writeByte(27)
      ..write(obj.status)
      ..writeByte(29)
      ..write(obj.stateId)
      ..writeByte(31)
      ..write(obj.regionId)
      ..writeByte(33)
      ..write(obj.demandReasonId)
      ..writeByte(35)
      ..write(obj.transportModeId)
      ..writeByte(37)
      ..write(obj.shippingMethod)
      ..writeByte(39)
      ..write(obj.multicurrencyTx)
      ..writeByte(41)
      ..write(obj.multicurrencyTotalHt)
      ..writeByte(43)
      ..write(obj.multicurrencyTotalTva)
      ..writeByte(45)
      ..write(obj.multicurrencyTotalTtc)
      ..writeByte(47)
      ..write(obj.multicurrencyTotalLocaltax1)
      ..writeByte(49)
      ..write(obj.multicurrencyTotalLocaltax2)
      ..writeByte(51)
      ..write(obj.lastMainDoc)
      ..writeByte(53)
      ..write(obj.fkAccount)
      ..writeByte(55)
      ..write(obj.totalHt)
      ..writeByte(57)
      ..write(obj.totalTva)
      ..writeByte(59)
      ..write(obj.totalLocaltax1)
      ..writeByte(61)
      ..write(obj.totalLocaltax2)
      ..writeByte(63)
      ..write(obj.totalTtc)
      ..writeByte(65)
      ..write(obj.lines)
      ..writeByte(67)
      ..write(obj.actiontypecode)
      ..writeByte(69)
      ..write(obj.dateCreation)
      ..writeByte(71)
      ..write(obj.dateValidation)
      ..writeByte(73)
      ..write(obj.dateModification)
      ..writeByte(75)
      ..write(obj.tms)
      ..writeByte(77)
      ..write(obj.dateCloture)
      ..writeByte(79)
      ..write(obj.userAuthor)
      ..writeByte(81)
      ..write(obj.userCreation)
      ..writeByte(83)
      ..write(obj.userCreationId)
      ..writeByte(85)
      ..write(obj.userValid)
      ..writeByte(87)
      ..write(obj.userValidation)
      ..writeByte(89)
      ..write(obj.userValidationId)
      ..writeByte(91)
      ..write(obj.userClosingId)
      ..writeByte(93)
      ..write(obj.userModification)
      ..writeByte(95)
      ..write(obj.userModificationId)
      ..writeByte(97)
      ..write(obj.fkUserCreat)
      ..writeByte(99)
      ..write(obj.fkUserModif)
      ..writeByte(101)
      ..write(obj.specimen)
      ..writeByte(103)
      ..write(obj.totalpaid)
      ..writeByte(105)
      ..write(obj.extraparams)
      ..writeByte(107)
      ..write(obj.product)
      ..writeByte(109)
      ..write(obj.condReglementSupplierId)
      ..writeByte(111)
      ..write(obj.depositPercent)
      ..writeByte(113)
      ..write(obj.retainedWarrantyFkCondReglement)
      ..writeByte(115)
      ..write(obj.warehouseId)
      ..writeByte(117)
      ..write(obj.parentElement)
      ..writeByte(119)
      ..write(obj.fkParentAttribute)
      ..writeByte(121)
      ..write(obj.rowid)
      ..writeByte(123)
      ..write(obj.fkUnit)
      ..writeByte(125)
      ..write(obj.dateDebutPrevue)
      ..writeByte(127)
      ..write(obj.dateDebutReel)
      ..writeByte(129)
      ..write(obj.dateFinPrevue)
      ..writeByte(131)
      ..write(obj.dateFinReel)
      ..writeByte(133)
      ..write(obj.weight)
      ..writeByte(135)
      ..write(obj.weightUnits)
      ..writeByte(137)
      ..write(obj.length)
      ..writeByte(139)
      ..write(obj.lengthUnits)
      ..writeByte(141)
      ..write(obj.width)
      ..writeByte(143)
      ..write(obj.widthUnits)
      ..writeByte(145)
      ..write(obj.height)
      ..writeByte(147)
      ..write(obj.heightUnits)
      ..writeByte(149)
      ..write(obj.surface)
      ..writeByte(151)
      ..write(obj.surfaceUnits)
      ..writeByte(153)
      ..write(obj.volume)
      ..writeByte(155)
      ..write(obj.volumeUnits)
      ..writeByte(157)
      ..write(obj.multilangs)
      ..writeByte(159)
      ..write(obj.productType)
      ..writeByte(161)
      ..write(obj.fkProduct)
      ..writeByte(163)
      ..write(obj.desc)
      ..writeByte(165)
      ..write(obj.description)
      ..writeByte(167)
      ..write(obj.productRef)
      ..writeByte(169)
      ..write(obj.productLabel)
      ..writeByte(171)
      ..write(obj.productBarcode)
      ..writeByte(173)
      ..write(obj.productDesc)
      ..writeByte(175)
      ..write(obj.fkProductType)
      ..writeByte(177)
      ..write(obj.qty)
      ..writeByte(179)
      ..write(obj.duree)
      ..writeByte(181)
      ..write(obj.remisePercent)
      ..writeByte(183)
      ..write(obj.infoBits)
      ..writeByte(185)
      ..write(obj.specialCode)
      ..writeByte(187)
      ..write(obj.subprice)
      ..writeByte(189)
      ..write(obj.tvaTx)
      ..writeByte(191)
      ..write(obj.multicurrencySubprice)
      ..writeByte(193)
      ..write(obj.label)
      ..writeByte(195)
      ..write(obj.libelle)
      ..writeByte(197)
      ..write(obj.price)
      ..writeByte(199)
      ..write(obj.vatSrcCode)
      ..writeByte(201)
      ..write(obj.localtax1Tx)
      ..writeByte(203)
      ..write(obj.localtax2Tx)
      ..writeByte(205)
      ..write(obj.localtax1Type)
      ..writeByte(207)
      ..write(obj.localtax2Type)
      ..writeByte(209)
      ..write(obj.remise)
      ..writeByte(211)
      ..write(obj.dateStartFill)
      ..writeByte(213)
      ..write(obj.dateEndFill)
      ..writeByte(215)
      ..write(obj.buyPriceHt)
      ..writeByte(217)
      ..write(obj.buyprice)
      ..writeByte(219)
      ..write(obj.paHt)
      ..writeByte(221)
      ..write(obj.margeTx)
      ..writeByte(223)
      ..write(obj.marqueTx)
      ..writeByte(225)
      ..write(obj.fkUserAuthor)
      ..writeByte(227)
      ..write(obj.fkAccountingAccount)
      ..writeByte(229)
      ..write(obj.fkFacture)
      ..writeByte(231)
      ..write(obj.fkParentLine)
      ..writeByte(233)
      ..write(obj.fkRemiseExcept)
      ..writeByte(235)
      ..write(obj.rang)
      ..writeByte(237)
      ..write(obj.fkFournprice)
      ..writeByte(239)
      ..write(obj.tvaNpr)
      ..writeByte(241)
      ..write(obj.batch)
      ..writeByte(243)
      ..write(obj.fkWarehouse)
      ..writeByte(245)
      ..write(obj.fkCodeVentilation)
      ..writeByte(247)
      ..write(obj.dateStart)
      ..writeByte(249)
      ..write(obj.dateEnd)
      ..writeByte(251)
      ..write(obj.situationPercent)
      ..writeByte(253)
      ..write(obj.fkPrevId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceModel _$InvoiceModelFromJson(Map<String, dynamic> json) => InvoiceModel(
      module: json['module'],
      id: json['id'],
      entity: json['entity'],
      importKey: json['import_key'],
      arrayOptions: json['array_options'] as List<dynamic>?,
      arrayLanguages: json['array_languages'],
      contactsIds: json['contacts_ids'] as List<dynamic>?,
      linkedObjectsIds: json['linkedObjectsIds'],
      fkProject: json['fk_project'],
      contactId: json['contact_id'],
      user: json['user'],
      originType: json['origin_type'],
      originId: json['origin_id'],
      ref: json['ref'],
      refExt: json['ref_ext'],
      statut: json['statut'],
      status: json['status'],
      countryId: json['country_id'],
      countryCode: json['country_code'],
      stateId: json['state_id'],
      regionId: json['region_id'],
      modeReglementId: json['mode_reglement_id'],
      condReglementId: json['cond_reglement_id'],
      demandReasonId: json['demand_reason_id'],
      transportModeId: json['transport_mode_id'],
      shippingMethodId: json['shipping_method_id'],
      shippingMethod: json['shipping_method'],
      fkMulticurrency: json['fk_multicurrency'],
      multicurrencyCode: json['multicurrency_code'],
      multicurrencyTx: json['multicurrency_tx'],
      multicurrencyTotalHt: json['multicurrency_total_ht'],
      multicurrencyTotalTva: json['multicurrency_total_tva'],
      multicurrencyTotalTtc: json['multicurrency_total_ttc'],
      multicurrencyTotalLocaltax1: json['multicurrency_total_localtax1'],
      multicurrencyTotalLocaltax2: json['multicurrency_total_localtax2'],
      lastMainDoc: json['last_main_doc'],
      fkAccount: json['fk_account'],
      notePublic: json['note_public'],
      notePrivate: json['note_private'],
      totalHt: json['total_ht'],
      totalTva: json['total_tva'],
      totalLocaltax1: json['total_localtax1'],
      totalLocaltax2: json['total_localtax2'],
      totalTtc: json['total_ttc'],
      lines: (json['lines'] as List<dynamic>?)
          ?.map((e) => Line.fromJson(e as Map<String, dynamic>))
          .toList(),
      actiontypecode: json['actiontypecode'],
      name: json['name'],
      lastname: json['lastname'],
      firstname: json['firstname'],
      civilityId: json['civility_id'],
      dateCreation: json['date_creation'],
      dateValidation: json['date_validation'],
      dateModification: json['date_modification'],
      tms: json['tms'],
      dateCloture: json['date_cloture'],
      userAuthor: json['user_author'],
      userCreation: json['user_creation'],
      userCreationId: json['user_creation_id'],
      userValid: json['user_valid'],
      userValidation: json['user_validation'],
      userValidationId: json['user_validation_id'],
      userClosingId: json['user_closing_id'],
      userModification: json['user_modification'],
      userModificationId: json['user_modification_id'],
      fkUserCreat: json['fk_user_creat'],
      fkUserModif: json['fk_user_modif'],
      specimen: json['specimen'],
      totalpaid: json['totalpaid'],
      extraparams: json['extraparams'] as Map<String, dynamic>?,
      product: json['product'],
      condReglementSupplierId: json['cond_reglement_supplier_id'],
      depositPercent: json['deposit_percent'],
      retainedWarrantyFkCondReglement:
          json['retained_warranty_fk_cond_reglement'],
      warehouseId: json['warehouse_id'],
      title: json['title'],
      type: json['type'],
      subtype: json['subtype'],
      fkSoc: json['fk_soc'],
      socid: json['socid'],
      paye: json['paye'],
      date: json['date'],
      dateLimReglement: json['date_lim_reglement'],
      condReglementCode: json['cond_reglement_code'],
      condReglementLabel: json['cond_reglement_label'],
      condReglementDoc: json['cond_reglement_doc'],
      modeReglementCode: json['mode_reglement_code'],
      revenuestamp: json['revenuestamp'],
      totaldeposits: json['totaldeposits'],
      totalcreditnotes: json['totalcreditnotes'],
      sumpayed: json['sumpayed'],
      sumpayedMulticurrency: json['sumpayed_multicurrency'],
      sumdeposit: json['sumdeposit'],
      sumdepositMulticurrency: json['sumdeposit_multicurrency'],
      sumcreditnote: json['sumcreditnote'],
      sumcreditnoteMulticurrency: json['sumcreditnote_multicurrency'],
      remaintopay: json['remaintopay'],
      nbofopendirectdebitorcredittransfer:
          json['nbofopendirectdebitorcredittransfer'],
      description: json['description'],
      refClient: json['ref_client'],
      situationCycleRef: json['situation_cycle_ref'],
      closeCode: json['close_code'],
      closeNote: json['close_note'],
      postactionmessages: json['postactionmessages'],
      fkIncoterms: json['fk_incoterms'],
      labelIncoterms: json['label_incoterms'],
      locationIncoterms: json['location_incoterms'],
      fkUserAuthor: json['fk_user_author'],
      fkUserValid: json['fk_user_valid'],
      datem: json['datem'],
      deliveryDate: json['delivery_date'],
      refCustomer: json['ref_customer'],
      resteapayer: json['resteapayer'],
      moduleSource: json['module_source'],
      posSource: json['pos_source'],
      fkFacRecSource: json['fk_fac_rec_source'],
      fkFactureSource: json['fk_facture_source'],
      line: json['line'] == null
          ? null
          : Line.fromJson(json['line'] as Map<String, dynamic>),
      facRec: json['fac_rec'],
      datePointoftax: json['date_pointoftax'],
      situationCounter: json['situation_counter'],
      situationFinal: json['situation_final'],
      tabPreviousSituationInvoice:
          json['tab_previous_situation_invoice'] as List<dynamic>?,
      tabNextSituationInvoice:
          json['tab_next_situation_invoice'] as List<dynamic>?,
      retainedWarranty: json['retained_warranty'],
      retainedWarrantyDateLimit: json['retained_warranty_date_limit'],
      dateClosing: json['date_closing'],
      remisePercent: json['remise_percent'],
    );

Map<String, dynamic> _$InvoiceModelToJson(InvoiceModel instance) =>
    <String, dynamic>{
      'module': instance.module,
      'id': instance.id,
      'entity': instance.entity,
      'import_key': instance.importKey,
      'array_options': instance.arrayOptions,
      'array_languages': instance.arrayLanguages,
      'contacts_ids': instance.contactsIds,
      'linkedObjectsIds': instance.linkedObjectsIds,
      'fk_project': instance.fkProject,
      'contact_id': instance.contactId,
      'user': instance.user,
      'origin_type': instance.originType,
      'origin_id': instance.originId,
      'ref': instance.ref,
      'ref_ext': instance.refExt,
      'statut': instance.statut,
      'status': instance.status,
      'country_id': instance.countryId,
      'country_code': instance.countryCode,
      'state_id': instance.stateId,
      'region_id': instance.regionId,
      'mode_reglement_id': instance.modeReglementId,
      'cond_reglement_id': instance.condReglementId,
      'demand_reason_id': instance.demandReasonId,
      'transport_mode_id': instance.transportModeId,
      'shipping_method_id': instance.shippingMethodId,
      'shipping_method': instance.shippingMethod,
      'fk_multicurrency': instance.fkMulticurrency,
      'multicurrency_code': instance.multicurrencyCode,
      'multicurrency_tx': instance.multicurrencyTx,
      'multicurrency_total_ht': instance.multicurrencyTotalHt,
      'multicurrency_total_tva': instance.multicurrencyTotalTva,
      'multicurrency_total_ttc': instance.multicurrencyTotalTtc,
      'multicurrency_total_localtax1': instance.multicurrencyTotalLocaltax1,
      'multicurrency_total_localtax2': instance.multicurrencyTotalLocaltax2,
      'last_main_doc': instance.lastMainDoc,
      'fk_account': instance.fkAccount,
      'note_public': instance.notePublic,
      'note_private': instance.notePrivate,
      'total_ht': instance.totalHt,
      'total_tva': instance.totalTva,
      'total_localtax1': instance.totalLocaltax1,
      'total_localtax2': instance.totalLocaltax2,
      'total_ttc': instance.totalTtc,
      'lines': instance.lines,
      'actiontypecode': instance.actiontypecode,
      'name': instance.name,
      'lastname': instance.lastname,
      'firstname': instance.firstname,
      'civility_id': instance.civilityId,
      'date_creation': instance.dateCreation,
      'date_validation': instance.dateValidation,
      'date_modification': instance.dateModification,
      'tms': instance.tms,
      'date_cloture': instance.dateCloture,
      'user_author': instance.userAuthor,
      'user_creation': instance.userCreation,
      'user_creation_id': instance.userCreationId,
      'user_valid': instance.userValid,
      'user_validation': instance.userValidation,
      'user_validation_id': instance.userValidationId,
      'user_closing_id': instance.userClosingId,
      'user_modification': instance.userModification,
      'user_modification_id': instance.userModificationId,
      'fk_user_creat': instance.fkUserCreat,
      'fk_user_modif': instance.fkUserModif,
      'specimen': instance.specimen,
      'totalpaid': instance.totalpaid,
      'extraparams': instance.extraparams,
      'product': instance.product,
      'cond_reglement_supplier_id': instance.condReglementSupplierId,
      'deposit_percent': instance.depositPercent,
      'retained_warranty_fk_cond_reglement':
          instance.retainedWarrantyFkCondReglement,
      'warehouse_id': instance.warehouseId,
      'title': instance.title,
      'type': instance.type,
      'subtype': instance.subtype,
      'fk_soc': instance.fkSoc,
      'socid': instance.socid,
      'paye': instance.paye,
      'date': instance.date,
      'date_lim_reglement': instance.dateLimReglement,
      'cond_reglement_code': instance.condReglementCode,
      'cond_reglement_label': instance.condReglementLabel,
      'cond_reglement_doc': instance.condReglementDoc,
      'mode_reglement_code': instance.modeReglementCode,
      'revenuestamp': instance.revenuestamp,
      'totaldeposits': instance.totaldeposits,
      'totalcreditnotes': instance.totalcreditnotes,
      'sumpayed': instance.sumpayed,
      'sumpayed_multicurrency': instance.sumpayedMulticurrency,
      'sumdeposit': instance.sumdeposit,
      'sumdeposit_multicurrency': instance.sumdepositMulticurrency,
      'sumcreditnote': instance.sumcreditnote,
      'sumcreditnote_multicurrency': instance.sumcreditnoteMulticurrency,
      'remaintopay': instance.remaintopay,
      'nbofopendirectdebitorcredittransfer':
          instance.nbofopendirectdebitorcredittransfer,
      'description': instance.description,
      'ref_client': instance.refClient,
      'situation_cycle_ref': instance.situationCycleRef,
      'close_code': instance.closeCode,
      'close_note': instance.closeNote,
      'postactionmessages': instance.postactionmessages,
      'fk_incoterms': instance.fkIncoterms,
      'label_incoterms': instance.labelIncoterms,
      'location_incoterms': instance.locationIncoterms,
      'fk_user_author': instance.fkUserAuthor,
      'fk_user_valid': instance.fkUserValid,
      'datem': instance.datem,
      'delivery_date': instance.deliveryDate,
      'ref_customer': instance.refCustomer,
      'resteapayer': instance.resteapayer,
      'module_source': instance.moduleSource,
      'pos_source': instance.posSource,
      'fk_fac_rec_source': instance.fkFacRecSource,
      'fk_facture_source': instance.fkFactureSource,
      'line': instance.line,
      'fac_rec': instance.facRec,
      'date_pointoftax': instance.datePointoftax,
      'situation_counter': instance.situationCounter,
      'situation_final': instance.situationFinal,
      'tab_previous_situation_invoice': instance.tabPreviousSituationInvoice,
      'tab_next_situation_invoice': instance.tabNextSituationInvoice,
      'retained_warranty': instance.retainedWarranty,
      'retained_warranty_date_limit': instance.retainedWarrantyDateLimit,
      'date_closing': instance.dateClosing,
      'remise_percent': instance.remisePercent,
    };

Line _$LineFromJson(Map<String, dynamic> json) => Line(
      module: json['module'],
      id: json['id'],
      entity: json['entity'],
      importKey: json['import_key'],
      arrayOptions: json['array_options'] as List<dynamic>?,
      arrayLanguages: json['array_languages'],
      contactsIds: json['contacts_ids'],
      linkedObjectsIds: json['linkedObjectsIds'],
      originType: json['origin_type'],
      originId: json['origin_id'],
      ref: json['ref'],
      refExt: json['ref_ext'],
      statut: json['statut'],
      status: json['status'],
      stateId: json['state_id'],
      regionId: json['region_id'],
      demandReasonId: json['demand_reason_id'],
      transportModeId: json['transport_mode_id'],
      shippingMethod: json['shipping_method'],
      multicurrencyTx: json['multicurrency_tx'],
      multicurrencyTotalHt: json['multicurrency_total_ht'],
      multicurrencyTotalTva: json['multicurrency_total_tva'],
      multicurrencyTotalTtc: json['multicurrency_total_ttc'],
      multicurrencyTotalLocaltax1: json['multicurrency_total_localtax1'],
      multicurrencyTotalLocaltax2: json['multicurrency_total_localtax2'],
      lastMainDoc: json['last_main_doc'],
      fkAccount: json['fk_account'],
      totalHt: json['total_ht'],
      totalTva: json['total_tva'],
      totalLocaltax1: json['total_localtax1'],
      totalLocaltax2: json['total_localtax2'],
      totalTtc: json['total_ttc'],
      lines: (json['lines'] as List<dynamic>?)
          ?.map((e) => Line.fromJson(e as Map<String, dynamic>))
          .toList(),
      actiontypecode: json['actiontypecode'],
      dateCreation: json['date_creation'],
      dateValidation: json['date_validation'],
      dateModification: json['date_modification'],
      tms: json['tms'],
      dateCloture: json['date_cloture'],
      userAuthor: json['user_author'],
      userCreation: json['user_creation'],
      userCreationId: json['user_creation_id'],
      userValid: json['user_valid'],
      userValidation: json['user_validation'],
      userValidationId: json['user_validation_id'],
      userClosingId: json['user_closing_id'],
      userModification: json['user_modification'],
      userModificationId: json['user_modification_id'],
      fkUserCreat: json['fk_user_creat'],
      fkUserModif: json['fk_user_modif'],
      specimen: json['specimen'],
      totalpaid: json['totalpaid'],
      extraparams: json['extraparams'] as List<dynamic>?,
      product: json['product'],
      condReglementSupplierId: json['cond_reglement_supplier_id'],
      depositPercent: json['deposit_percent'],
      retainedWarrantyFkCondReglement:
          json['retained_warranty_fk_cond_reglement'],
      warehouseId: json['warehouse_id'],
      parentElement: json['parent_element'],
      fkParentAttribute: json['fk_parent_attribute'],
      rowid: json['rowid'],
      fkUnit: json['fk_unit'],
      dateDebutPrevue: json['date_debut_prevue'],
      dateDebutReel: json['date_debut_reel'],
      dateFinPrevue: json['date_fin_prevue'],
      dateFinReel: json['date_fin_reel'],
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
      multilangs: json['multilangs'],
      productType: json['product_type'],
      fkProduct: json['fk_product'],
      desc: json['desc'],
      description: json['description'],
      productRef: json['product_ref'],
      productLabel: json['product_label'],
      productBarcode: json['product_barcode'],
      productDesc: json['product_desc'],
      fkProductType: json['fk_product_type'],
      qty: json['qty'],
      duree: json['duree'],
      remisePercent: json['remise_percent'],
      infoBits: json['info_bits'],
      specialCode: json['special_code'],
      subprice: json['subprice'],
      tvaTx: json['tva_tx'],
      multicurrencySubprice: json['multicurrency_subprice'],
      label: json['label'],
      libelle: json['libelle'],
      price: json['price'],
      vatSrcCode: json['vat_src_code'],
      localtax1Tx: json['localtax1_tx'],
      localtax2Tx: json['localtax2_tx'],
      localtax1Type: json['localtax1_type'],
      localtax2Type: json['localtax2_type'],
      remise: json['remise'],
      dateStartFill: json['date_start_fill'],
      dateEndFill: json['date_end_fill'],
      buyPriceHt: json['buy_price_ht'],
      buyprice: json['buyprice'],
      paHt: json['pa_ht'],
      margeTx: json['marge_tx'],
      marqueTx: json['marque_tx'],
      fkUserAuthor: json['fk_user_author'],
      fkAccountingAccount: json['fk_accounting_account'],
      fkFacture: json['fk_facture'],
      fkParentLine: json['fk_parent_line'],
      fkRemiseExcept: json['fk_remise_except'],
      rang: json['rang'],
      fkFournprice: json['fk_fournprice'],
      tvaNpr: json['tva_npr'],
      batch: json['batch'],
      fkWarehouse: json['fk_warehouse'],
      fkCodeVentilation: json['fk_code_ventilation'],
      dateStart: json['date_start'],
      dateEnd: json['date_end'],
      situationPercent: json['situation_percent'],
      fkPrevId: json['fk_prev_id'],
    );

Map<String, dynamic> _$LineToJson(Line instance) => <String, dynamic>{
      'module': instance.module,
      'id': instance.id,
      'entity': instance.entity,
      'import_key': instance.importKey,
      'array_options': instance.arrayOptions,
      'array_languages': instance.arrayLanguages,
      'contacts_ids': instance.contactsIds,
      'linkedObjectsIds': instance.linkedObjectsIds,
      'origin_type': instance.originType,
      'origin_id': instance.originId,
      'ref': instance.ref,
      'ref_ext': instance.refExt,
      'statut': instance.statut,
      'status': instance.status,
      'state_id': instance.stateId,
      'region_id': instance.regionId,
      'demand_reason_id': instance.demandReasonId,
      'transport_mode_id': instance.transportModeId,
      'shipping_method': instance.shippingMethod,
      'multicurrency_tx': instance.multicurrencyTx,
      'multicurrency_total_ht': instance.multicurrencyTotalHt,
      'multicurrency_total_tva': instance.multicurrencyTotalTva,
      'multicurrency_total_ttc': instance.multicurrencyTotalTtc,
      'multicurrency_total_localtax1': instance.multicurrencyTotalLocaltax1,
      'multicurrency_total_localtax2': instance.multicurrencyTotalLocaltax2,
      'last_main_doc': instance.lastMainDoc,
      'fk_account': instance.fkAccount,
      'total_ht': instance.totalHt,
      'total_tva': instance.totalTva,
      'total_localtax1': instance.totalLocaltax1,
      'total_localtax2': instance.totalLocaltax2,
      'total_ttc': instance.totalTtc,
      'lines': instance.lines,
      'actiontypecode': instance.actiontypecode,
      'date_creation': instance.dateCreation,
      'date_validation': instance.dateValidation,
      'date_modification': instance.dateModification,
      'tms': instance.tms,
      'date_cloture': instance.dateCloture,
      'user_author': instance.userAuthor,
      'user_creation': instance.userCreation,
      'user_creation_id': instance.userCreationId,
      'user_valid': instance.userValid,
      'user_validation': instance.userValidation,
      'user_validation_id': instance.userValidationId,
      'user_closing_id': instance.userClosingId,
      'user_modification': instance.userModification,
      'user_modification_id': instance.userModificationId,
      'fk_user_creat': instance.fkUserCreat,
      'fk_user_modif': instance.fkUserModif,
      'specimen': instance.specimen,
      'totalpaid': instance.totalpaid,
      'extraparams': instance.extraparams,
      'product': instance.product,
      'cond_reglement_supplier_id': instance.condReglementSupplierId,
      'deposit_percent': instance.depositPercent,
      'retained_warranty_fk_cond_reglement':
          instance.retainedWarrantyFkCondReglement,
      'warehouse_id': instance.warehouseId,
      'parent_element': instance.parentElement,
      'fk_parent_attribute': instance.fkParentAttribute,
      'rowid': instance.rowid,
      'fk_unit': instance.fkUnit,
      'date_debut_prevue': instance.dateDebutPrevue,
      'date_debut_reel': instance.dateDebutReel,
      'date_fin_prevue': instance.dateFinPrevue,
      'date_fin_reel': instance.dateFinReel,
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
      'multilangs': instance.multilangs,
      'product_type': instance.productType,
      'fk_product': instance.fkProduct,
      'desc': instance.desc,
      'description': instance.description,
      'product_ref': instance.productRef,
      'product_label': instance.productLabel,
      'product_barcode': instance.productBarcode,
      'product_desc': instance.productDesc,
      'fk_product_type': instance.fkProductType,
      'qty': instance.qty,
      'duree': instance.duree,
      'remise_percent': instance.remisePercent,
      'info_bits': instance.infoBits,
      'special_code': instance.specialCode,
      'subprice': instance.subprice,
      'tva_tx': instance.tvaTx,
      'multicurrency_subprice': instance.multicurrencySubprice,
      'label': instance.label,
      'libelle': instance.libelle,
      'price': instance.price,
      'vat_src_code': instance.vatSrcCode,
      'localtax1_tx': instance.localtax1Tx,
      'localtax2_tx': instance.localtax2Tx,
      'localtax1_type': instance.localtax1Type,
      'localtax2_type': instance.localtax2Type,
      'remise': instance.remise,
      'date_start_fill': instance.dateStartFill,
      'date_end_fill': instance.dateEndFill,
      'buy_price_ht': instance.buyPriceHt,
      'buyprice': instance.buyprice,
      'pa_ht': instance.paHt,
      'marge_tx': instance.margeTx,
      'marque_tx': instance.marqueTx,
      'fk_user_author': instance.fkUserAuthor,
      'fk_accounting_account': instance.fkAccountingAccount,
      'fk_facture': instance.fkFacture,
      'fk_parent_line': instance.fkParentLine,
      'fk_remise_except': instance.fkRemiseExcept,
      'rang': instance.rang,
      'fk_fournprice': instance.fkFournprice,
      'tva_npr': instance.tvaNpr,
      'batch': instance.batch,
      'fk_warehouse': instance.fkWarehouse,
      'fk_code_ventilation': instance.fkCodeVentilation,
      'date_start': instance.dateStart,
      'date_end': instance.dateEnd,
      'situation_percent': instance.situationPercent,
      'fk_prev_id': instance.fkPrevId,
    };
