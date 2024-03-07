// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InvoiceModelAdapter extends TypeAdapter<InvoiceModel> {
  @override
  final int typeId = 1;

  @override
  InvoiceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InvoiceModel(
      brouillon: fields[1] as dynamic,
      socid: fields[3] as dynamic,
      userAuthor: fields[5] as dynamic,
      fkUserAuthor: fields[7] as dynamic,
      userValid: fields[9] as dynamic,
      fkUserValid: fields[11] as dynamic,
      userModification: fields[13] as dynamic,
      fkUserModif: fields[15] as dynamic,
      date: fields[17] as dynamic,
      datem: fields[19] as dynamic,
      dateLivraison: fields[21] as dynamic,
      deliveryDate: fields[23] as dynamic,
      refClient: fields[25] as dynamic,
      refCustomer: fields[27] as dynamic,
      remiseAbsolue: fields[29] as dynamic,
      remisePercent: fields[31] as dynamic,
      totalHt: fields[33] as dynamic,
      totalTva: fields[35] as dynamic,
      totalLocaltax1: fields[37] as dynamic,
      totalLocaltax2: fields[39] as dynamic,
      totalTtc: fields[41] as dynamic,
      revenuestamp: fields[43] as dynamic,
      resteapayer: fields[45] as dynamic,
      closeCode: fields[47] as dynamic,
      closeNote: fields[49] as dynamic,
      paye: fields[51] as dynamic,
      moduleSource: fields[53] as dynamic,
      posSource: fields[55] as dynamic,
      fkFacRecSource: fields[57] as dynamic,
      fkFactureSource: fields[59] as dynamic,
      linkedObjects: (fields[61] as List?)?.cast<dynamic>(),
      dateLimReglement: fields[63] as dynamic,
      condReglementCode: fields[65] as dynamic,
      condReglementDoc: fields[67] as dynamic,
      modeReglementCode: fields[69] as dynamic,
      fkBank: fields[71] as dynamic,
      lines: (fields[73] as List?)?.cast<Line>(),
      line: fields[75] as dynamic,
      extraparams: fields[77] as dynamic,
      facRec: fields[79] as dynamic,
      datePointoftax: fields[81] as dynamic,
      fkMulticurrency: fields[83] as dynamic,
      multicurrencyCode: fields[85] as dynamic,
      multicurrencyTx: fields[87] as dynamic,
      multicurrencyTotalHt: fields[89] as dynamic,
      multicurrencyTotalTva: fields[91] as dynamic,
      multicurrencyTotalTtc: fields[93] as dynamic,
      situationCycleRef: fields[95] as dynamic,
      situationCounter: fields[97] as dynamic,
      situationFinal: fields[99] as dynamic,
      tabPreviousSituationInvoice: (fields[101] as List?)?.cast<dynamic>(),
      tabNextSituationInvoice: (fields[103] as List?)?.cast<dynamic>(),
      retainedWarranty: fields[105] as dynamic,
      retainedWarrantyDateLimit: fields[107] as dynamic,
      retainedWarrantyFkCondReglement: fields[109] as dynamic,
      type: fields[111] as dynamic,
      subtype: fields[113] as dynamic,
      totalpaid: fields[115] as dynamic,
      totaldeposits: fields[117] as dynamic,
      totalcreditnotes: fields[119] as dynamic,
      sumpayed: fields[121] as dynamic,
      sumpayedMulticurrency: fields[123] as dynamic,
      sumdeposit: fields[125] as dynamic,
      sumdepositMulticurrency: fields[127] as dynamic,
      sumcreditnote: fields[129] as dynamic,
      sumcreditnoteMulticurrency: fields[131] as dynamic,
      remaintopay: fields[133] as dynamic,
      module: fields[135] as dynamic,
      id: fields[137] as dynamic,
      entity: fields[139] as dynamic,
      importKey: fields[141] as dynamic,
      arrayOptions: (fields[143] as List?)?.cast<dynamic>(),
      arrayLanguages: fields[145] as dynamic,
      contactsIds: (fields[147] as List?)?.cast<dynamic>(),
      linkedObjectsIds: fields[149] as dynamic,
      oldref: fields[151] as dynamic,
      fkProject: fields[153] as dynamic,
      contactId: fields[155] as dynamic,
      user: fields[157] as dynamic,
      origin: fields[159] as dynamic,
      originId: fields[161] as dynamic,
      ref: fields[163] as dynamic,
      refExt: fields[165] as dynamic,
      statut: fields[167] as dynamic,
      status: fields[169] as dynamic,
      countryId: fields[171] as dynamic,
      countryCode: fields[173] as dynamic,
      stateId: fields[175] as dynamic,
      regionId: fields[177] as dynamic,
      modeReglementId: fields[179] as dynamic,
      condReglementId: fields[181] as dynamic,
      demandReasonId: fields[183] as dynamic,
      transportModeId: fields[185] as dynamic,
      shippingMethodId: fields[187] as dynamic,
      shippingMethod: fields[189] as dynamic,
      modelPdf: fields[191] as dynamic,
      lastMainDoc: fields[193] as dynamic,
      fkAccount: fields[195] as dynamic,
      notePublic: fields[197] as dynamic,
      notePrivate: fields[199] as dynamic,
      name: fields[201] as dynamic,
      lastname: fields[203] as dynamic,
      firstname: fields[205] as dynamic,
      civilityId: fields[207] as dynamic,
      dateCreation: fields[209] as dynamic,
      dateValidation: fields[211] as dynamic,
      dateModification: fields[213] as dynamic,
      dateUpdate: fields[215] as dynamic,
      dateCloture: fields[217] as dynamic,
      userCreation: fields[219] as dynamic,
      userCreationId: fields[221] as dynamic,
      userValidation: fields[223] as dynamic,
      userValidationId: fields[225] as dynamic,
      userClosingId: fields[227] as dynamic,
      userModificationId: fields[229] as dynamic,
      specimen: fields[231] as dynamic,
      labelStatus: fields[233] as dynamic,
      showphotoOnPopup: fields[235] as dynamic,
      nb: (fields[237] as List?)?.cast<dynamic>(),
      output: fields[239] as dynamic,
      fkIncoterms: fields[241] as dynamic,
      labelIncoterms: fields[243] as dynamic,
      locationIncoterms: fields[245] as dynamic,
      nom: fields[247] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, InvoiceModel obj) {
    writer
      ..writeByte(124)
      ..writeByte(1)
      ..write(obj.brouillon)
      ..writeByte(3)
      ..write(obj.socid)
      ..writeByte(5)
      ..write(obj.userAuthor)
      ..writeByte(7)
      ..write(obj.fkUserAuthor)
      ..writeByte(9)
      ..write(obj.userValid)
      ..writeByte(11)
      ..write(obj.fkUserValid)
      ..writeByte(13)
      ..write(obj.userModification)
      ..writeByte(15)
      ..write(obj.fkUserModif)
      ..writeByte(17)
      ..write(obj.date)
      ..writeByte(19)
      ..write(obj.datem)
      ..writeByte(21)
      ..write(obj.dateLivraison)
      ..writeByte(23)
      ..write(obj.deliveryDate)
      ..writeByte(25)
      ..write(obj.refClient)
      ..writeByte(27)
      ..write(obj.refCustomer)
      ..writeByte(29)
      ..write(obj.remiseAbsolue)
      ..writeByte(31)
      ..write(obj.remisePercent)
      ..writeByte(33)
      ..write(obj.totalHt)
      ..writeByte(35)
      ..write(obj.totalTva)
      ..writeByte(37)
      ..write(obj.totalLocaltax1)
      ..writeByte(39)
      ..write(obj.totalLocaltax2)
      ..writeByte(41)
      ..write(obj.totalTtc)
      ..writeByte(43)
      ..write(obj.revenuestamp)
      ..writeByte(45)
      ..write(obj.resteapayer)
      ..writeByte(47)
      ..write(obj.closeCode)
      ..writeByte(49)
      ..write(obj.closeNote)
      ..writeByte(51)
      ..write(obj.paye)
      ..writeByte(53)
      ..write(obj.moduleSource)
      ..writeByte(55)
      ..write(obj.posSource)
      ..writeByte(57)
      ..write(obj.fkFacRecSource)
      ..writeByte(59)
      ..write(obj.fkFactureSource)
      ..writeByte(61)
      ..write(obj.linkedObjects)
      ..writeByte(63)
      ..write(obj.dateLimReglement)
      ..writeByte(65)
      ..write(obj.condReglementCode)
      ..writeByte(67)
      ..write(obj.condReglementDoc)
      ..writeByte(69)
      ..write(obj.modeReglementCode)
      ..writeByte(71)
      ..write(obj.fkBank)
      ..writeByte(73)
      ..write(obj.lines)
      ..writeByte(75)
      ..write(obj.line)
      ..writeByte(77)
      ..write(obj.extraparams)
      ..writeByte(79)
      ..write(obj.facRec)
      ..writeByte(81)
      ..write(obj.datePointoftax)
      ..writeByte(83)
      ..write(obj.fkMulticurrency)
      ..writeByte(85)
      ..write(obj.multicurrencyCode)
      ..writeByte(87)
      ..write(obj.multicurrencyTx)
      ..writeByte(89)
      ..write(obj.multicurrencyTotalHt)
      ..writeByte(91)
      ..write(obj.multicurrencyTotalTva)
      ..writeByte(93)
      ..write(obj.multicurrencyTotalTtc)
      ..writeByte(95)
      ..write(obj.situationCycleRef)
      ..writeByte(97)
      ..write(obj.situationCounter)
      ..writeByte(99)
      ..write(obj.situationFinal)
      ..writeByte(101)
      ..write(obj.tabPreviousSituationInvoice)
      ..writeByte(103)
      ..write(obj.tabNextSituationInvoice)
      ..writeByte(105)
      ..write(obj.retainedWarranty)
      ..writeByte(107)
      ..write(obj.retainedWarrantyDateLimit)
      ..writeByte(109)
      ..write(obj.retainedWarrantyFkCondReglement)
      ..writeByte(111)
      ..write(obj.type)
      ..writeByte(113)
      ..write(obj.subtype)
      ..writeByte(115)
      ..write(obj.totalpaid)
      ..writeByte(117)
      ..write(obj.totaldeposits)
      ..writeByte(119)
      ..write(obj.totalcreditnotes)
      ..writeByte(121)
      ..write(obj.sumpayed)
      ..writeByte(123)
      ..write(obj.sumpayedMulticurrency)
      ..writeByte(125)
      ..write(obj.sumdeposit)
      ..writeByte(127)
      ..write(obj.sumdepositMulticurrency)
      ..writeByte(129)
      ..write(obj.sumcreditnote)
      ..writeByte(131)
      ..write(obj.sumcreditnoteMulticurrency)
      ..writeByte(133)
      ..write(obj.remaintopay)
      ..writeByte(135)
      ..write(obj.module)
      ..writeByte(137)
      ..write(obj.id)
      ..writeByte(139)
      ..write(obj.entity)
      ..writeByte(141)
      ..write(obj.importKey)
      ..writeByte(143)
      ..write(obj.arrayOptions)
      ..writeByte(145)
      ..write(obj.arrayLanguages)
      ..writeByte(147)
      ..write(obj.contactsIds)
      ..writeByte(149)
      ..write(obj.linkedObjectsIds)
      ..writeByte(151)
      ..write(obj.oldref)
      ..writeByte(153)
      ..write(obj.fkProject)
      ..writeByte(155)
      ..write(obj.contactId)
      ..writeByte(157)
      ..write(obj.user)
      ..writeByte(159)
      ..write(obj.origin)
      ..writeByte(161)
      ..write(obj.originId)
      ..writeByte(163)
      ..write(obj.ref)
      ..writeByte(165)
      ..write(obj.refExt)
      ..writeByte(167)
      ..write(obj.statut)
      ..writeByte(169)
      ..write(obj.status)
      ..writeByte(171)
      ..write(obj.countryId)
      ..writeByte(173)
      ..write(obj.countryCode)
      ..writeByte(175)
      ..write(obj.stateId)
      ..writeByte(177)
      ..write(obj.regionId)
      ..writeByte(179)
      ..write(obj.modeReglementId)
      ..writeByte(181)
      ..write(obj.condReglementId)
      ..writeByte(183)
      ..write(obj.demandReasonId)
      ..writeByte(185)
      ..write(obj.transportModeId)
      ..writeByte(187)
      ..write(obj.shippingMethodId)
      ..writeByte(189)
      ..write(obj.shippingMethod)
      ..writeByte(191)
      ..write(obj.modelPdf)
      ..writeByte(193)
      ..write(obj.lastMainDoc)
      ..writeByte(195)
      ..write(obj.fkAccount)
      ..writeByte(197)
      ..write(obj.notePublic)
      ..writeByte(199)
      ..write(obj.notePrivate)
      ..writeByte(201)
      ..write(obj.name)
      ..writeByte(203)
      ..write(obj.lastname)
      ..writeByte(205)
      ..write(obj.firstname)
      ..writeByte(207)
      ..write(obj.civilityId)
      ..writeByte(209)
      ..write(obj.dateCreation)
      ..writeByte(211)
      ..write(obj.dateValidation)
      ..writeByte(213)
      ..write(obj.dateModification)
      ..writeByte(215)
      ..write(obj.dateUpdate)
      ..writeByte(217)
      ..write(obj.dateCloture)
      ..writeByte(219)
      ..write(obj.userCreation)
      ..writeByte(221)
      ..write(obj.userCreationId)
      ..writeByte(223)
      ..write(obj.userValidation)
      ..writeByte(225)
      ..write(obj.userValidationId)
      ..writeByte(227)
      ..write(obj.userClosingId)
      ..writeByte(229)
      ..write(obj.userModificationId)
      ..writeByte(231)
      ..write(obj.specimen)
      ..writeByte(233)
      ..write(obj.labelStatus)
      ..writeByte(235)
      ..write(obj.showphotoOnPopup)
      ..writeByte(237)
      ..write(obj.nb)
      ..writeByte(239)
      ..write(obj.output)
      ..writeByte(241)
      ..write(obj.fkIncoterms)
      ..writeByte(243)
      ..write(obj.labelIncoterms)
      ..writeByte(245)
      ..write(obj.locationIncoterms)
      ..writeByte(247)
      ..write(obj.nom);
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
  final int typeId = 2;

  @override
  Line read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Line(
      fkFacture: fields[1] as dynamic,
      fkParentLine: fields[3] as dynamic,
      desc: fields[5] as dynamic,
      refExt: fields[7] as dynamic,
      localtax1Type: fields[9] as dynamic,
      localtax2Type: fields[11] as dynamic,
      fkRemiseExcept: fields[13] as dynamic,
      rang: fields[15] as dynamic,
      fkFournprice: fields[17] as dynamic,
      paHt: fields[19] as dynamic,
      margeTx: fields[21] as dynamic,
      marqueTx: fields[23] as dynamic,
      remisePercent: fields[25] as dynamic,
      specialCode: fields[27] as dynamic,
      origin: fields[29] as dynamic,
      originId: fields[31] as dynamic,
      fkCodeVentilation: fields[33] as dynamic,
      dateStart: fields[35] as dynamic,
      dateEnd: fields[37] as dynamic,
      situationPercent: fields[39] as dynamic,
      fkPrevId: fields[41] as dynamic,
      multicurrencySubprice: fields[43] as dynamic,
      multicurrencyTotalHt: fields[45] as dynamic,
      multicurrencyTotalTva: fields[47] as dynamic,
      multicurrencyTotalTtc: fields[49] as dynamic,
      label: fields[51] as dynamic,
      ref: fields[53] as dynamic,
      libelle: fields[55] as dynamic,
      productType: fields[57] as dynamic,
      productRef: fields[59] as dynamic,
      productLabel: fields[61] as dynamic,
      productDesc: fields[63] as dynamic,
      qty: fields[65] as dynamic,
      subprice: fields[67] as dynamic,
      price: fields[69] as dynamic,
      fkProduct: fields[71] as dynamic,
      vatSrcCode: fields[73] as dynamic,
      tvaTx: fields[75] as dynamic,
      localtax1Tx: fields[77] as dynamic,
      localtax2Tx: fields[79] as dynamic,
      remise: fields[81] as dynamic,
      totalHt: fields[83] as dynamic,
      totalTva: fields[85] as dynamic,
      totalLocaltax1: fields[87] as dynamic,
      totalLocaltax2: fields[89] as dynamic,
      totalTtc: fields[91] as dynamic,
      dateStartFill: fields[93] as dynamic,
      dateEndFill: fields[95] as dynamic,
      buyPriceHt: fields[97] as dynamic,
      buyprice: fields[99] as dynamic,
      infoBits: fields[101] as dynamic,
      fkUserAuthor: fields[103] as dynamic,
      fkUserModif: fields[105] as dynamic,
      fkAccountingAccount: fields[107] as dynamic,
      id: fields[109] as dynamic,
      rowid: fields[111] as dynamic,
      fkUnit: fields[113] as dynamic,
      dateDebutPrevue: fields[115] as dynamic,
      dateDebutReel: fields[117] as dynamic,
      dateFinPrevue: fields[119] as dynamic,
      dateFinReel: fields[121] as dynamic,
      weight: fields[123] as dynamic,
      weightUnits: fields[125] as dynamic,
      width: fields[127] as dynamic,
      widthUnits: fields[129] as dynamic,
      height: fields[131] as dynamic,
      heightUnits: fields[133] as dynamic,
      length: fields[135] as dynamic,
      lengthUnits: fields[137] as dynamic,
      surface: fields[139] as dynamic,
      surfaceUnits: fields[141] as dynamic,
      volume: fields[143] as dynamic,
      volumeUnits: fields[145] as dynamic,
      multilangs: fields[147] as dynamic,
      description: fields[149] as dynamic,
      product: fields[151] as dynamic,
      productBarcode: fields[153] as dynamic,
      fkProductType: fields[155] as dynamic,
      duree: fields[157] as dynamic,
      module: fields[159] as dynamic,
      entity: fields[161] as dynamic,
      importKey: fields[163] as dynamic,
      arrayOptions: (fields[165] as List?)?.cast<dynamic>(),
      arrayLanguages: fields[167] as dynamic,
      contactsIds: fields[169] as dynamic,
      linkedObjects: fields[171] as dynamic,
      linkedObjectsIds: fields[173] as dynamic,
      oldref: fields[175] as dynamic,
      statut: fields[177] as dynamic,
      status: fields[179] as dynamic,
      stateId: fields[181] as dynamic,
      regionId: fields[183] as dynamic,
      demandReasonId: fields[185] as dynamic,
      transportModeId: fields[187] as dynamic,
      shippingMethod: fields[189] as dynamic,
      multicurrencyTx: fields[191] as dynamic,
      lastMainDoc: fields[193] as dynamic,
      fkBank: fields[195] as dynamic,
      fkAccount: fields[197] as dynamic,
      lines: fields[199] as dynamic,
      dateCreation: fields[201] as dynamic,
      dateValidation: fields[203] as dynamic,
      dateModification: fields[205] as dynamic,
      dateUpdate: fields[207] as dynamic,
      dateCloture: fields[209] as dynamic,
      userAuthor: fields[211] as dynamic,
      userCreation: fields[213] as dynamic,
      userCreationId: fields[215] as dynamic,
      userValid: fields[217] as dynamic,
      userValidation: fields[219] as dynamic,
      userValidationId: fields[221] as dynamic,
      userClosingId: fields[223] as dynamic,
      userModification: fields[225] as dynamic,
      userModificationId: fields[227] as dynamic,
      specimen: fields[229] as dynamic,
      labelStatus: fields[231] as dynamic,
      showphotoOnPopup: fields[233] as dynamic,
      nb: (fields[235] as List?)?.cast<dynamic>(),
      output: fields[237] as dynamic,
      extraparams: fields[239] as dynamic,
      codeVentilation: fields[241] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, Line obj) {
    writer
      ..writeByte(121)
      ..writeByte(1)
      ..write(obj.fkFacture)
      ..writeByte(3)
      ..write(obj.fkParentLine)
      ..writeByte(5)
      ..write(obj.desc)
      ..writeByte(7)
      ..write(obj.refExt)
      ..writeByte(9)
      ..write(obj.localtax1Type)
      ..writeByte(11)
      ..write(obj.localtax2Type)
      ..writeByte(13)
      ..write(obj.fkRemiseExcept)
      ..writeByte(15)
      ..write(obj.rang)
      ..writeByte(17)
      ..write(obj.fkFournprice)
      ..writeByte(19)
      ..write(obj.paHt)
      ..writeByte(21)
      ..write(obj.margeTx)
      ..writeByte(23)
      ..write(obj.marqueTx)
      ..writeByte(25)
      ..write(obj.remisePercent)
      ..writeByte(27)
      ..write(obj.specialCode)
      ..writeByte(29)
      ..write(obj.origin)
      ..writeByte(31)
      ..write(obj.originId)
      ..writeByte(33)
      ..write(obj.fkCodeVentilation)
      ..writeByte(35)
      ..write(obj.dateStart)
      ..writeByte(37)
      ..write(obj.dateEnd)
      ..writeByte(39)
      ..write(obj.situationPercent)
      ..writeByte(41)
      ..write(obj.fkPrevId)
      ..writeByte(43)
      ..write(obj.multicurrencySubprice)
      ..writeByte(45)
      ..write(obj.multicurrencyTotalHt)
      ..writeByte(47)
      ..write(obj.multicurrencyTotalTva)
      ..writeByte(49)
      ..write(obj.multicurrencyTotalTtc)
      ..writeByte(51)
      ..write(obj.label)
      ..writeByte(53)
      ..write(obj.ref)
      ..writeByte(55)
      ..write(obj.libelle)
      ..writeByte(57)
      ..write(obj.productType)
      ..writeByte(59)
      ..write(obj.productRef)
      ..writeByte(61)
      ..write(obj.productLabel)
      ..writeByte(63)
      ..write(obj.productDesc)
      ..writeByte(65)
      ..write(obj.qty)
      ..writeByte(67)
      ..write(obj.subprice)
      ..writeByte(69)
      ..write(obj.price)
      ..writeByte(71)
      ..write(obj.fkProduct)
      ..writeByte(73)
      ..write(obj.vatSrcCode)
      ..writeByte(75)
      ..write(obj.tvaTx)
      ..writeByte(77)
      ..write(obj.localtax1Tx)
      ..writeByte(79)
      ..write(obj.localtax2Tx)
      ..writeByte(81)
      ..write(obj.remise)
      ..writeByte(83)
      ..write(obj.totalHt)
      ..writeByte(85)
      ..write(obj.totalTva)
      ..writeByte(87)
      ..write(obj.totalLocaltax1)
      ..writeByte(89)
      ..write(obj.totalLocaltax2)
      ..writeByte(91)
      ..write(obj.totalTtc)
      ..writeByte(93)
      ..write(obj.dateStartFill)
      ..writeByte(95)
      ..write(obj.dateEndFill)
      ..writeByte(97)
      ..write(obj.buyPriceHt)
      ..writeByte(99)
      ..write(obj.buyprice)
      ..writeByte(101)
      ..write(obj.infoBits)
      ..writeByte(103)
      ..write(obj.fkUserAuthor)
      ..writeByte(105)
      ..write(obj.fkUserModif)
      ..writeByte(107)
      ..write(obj.fkAccountingAccount)
      ..writeByte(109)
      ..write(obj.id)
      ..writeByte(111)
      ..write(obj.rowid)
      ..writeByte(113)
      ..write(obj.fkUnit)
      ..writeByte(115)
      ..write(obj.dateDebutPrevue)
      ..writeByte(117)
      ..write(obj.dateDebutReel)
      ..writeByte(119)
      ..write(obj.dateFinPrevue)
      ..writeByte(121)
      ..write(obj.dateFinReel)
      ..writeByte(123)
      ..write(obj.weight)
      ..writeByte(125)
      ..write(obj.weightUnits)
      ..writeByte(127)
      ..write(obj.width)
      ..writeByte(129)
      ..write(obj.widthUnits)
      ..writeByte(131)
      ..write(obj.height)
      ..writeByte(133)
      ..write(obj.heightUnits)
      ..writeByte(135)
      ..write(obj.length)
      ..writeByte(137)
      ..write(obj.lengthUnits)
      ..writeByte(139)
      ..write(obj.surface)
      ..writeByte(141)
      ..write(obj.surfaceUnits)
      ..writeByte(143)
      ..write(obj.volume)
      ..writeByte(145)
      ..write(obj.volumeUnits)
      ..writeByte(147)
      ..write(obj.multilangs)
      ..writeByte(149)
      ..write(obj.description)
      ..writeByte(151)
      ..write(obj.product)
      ..writeByte(153)
      ..write(obj.productBarcode)
      ..writeByte(155)
      ..write(obj.fkProductType)
      ..writeByte(157)
      ..write(obj.duree)
      ..writeByte(159)
      ..write(obj.module)
      ..writeByte(161)
      ..write(obj.entity)
      ..writeByte(163)
      ..write(obj.importKey)
      ..writeByte(165)
      ..write(obj.arrayOptions)
      ..writeByte(167)
      ..write(obj.arrayLanguages)
      ..writeByte(169)
      ..write(obj.contactsIds)
      ..writeByte(171)
      ..write(obj.linkedObjects)
      ..writeByte(173)
      ..write(obj.linkedObjectsIds)
      ..writeByte(175)
      ..write(obj.oldref)
      ..writeByte(177)
      ..write(obj.statut)
      ..writeByte(179)
      ..write(obj.status)
      ..writeByte(181)
      ..write(obj.stateId)
      ..writeByte(183)
      ..write(obj.regionId)
      ..writeByte(185)
      ..write(obj.demandReasonId)
      ..writeByte(187)
      ..write(obj.transportModeId)
      ..writeByte(189)
      ..write(obj.shippingMethod)
      ..writeByte(191)
      ..write(obj.multicurrencyTx)
      ..writeByte(193)
      ..write(obj.lastMainDoc)
      ..writeByte(195)
      ..write(obj.fkBank)
      ..writeByte(197)
      ..write(obj.fkAccount)
      ..writeByte(199)
      ..write(obj.lines)
      ..writeByte(201)
      ..write(obj.dateCreation)
      ..writeByte(203)
      ..write(obj.dateValidation)
      ..writeByte(205)
      ..write(obj.dateModification)
      ..writeByte(207)
      ..write(obj.dateUpdate)
      ..writeByte(209)
      ..write(obj.dateCloture)
      ..writeByte(211)
      ..write(obj.userAuthor)
      ..writeByte(213)
      ..write(obj.userCreation)
      ..writeByte(215)
      ..write(obj.userCreationId)
      ..writeByte(217)
      ..write(obj.userValid)
      ..writeByte(219)
      ..write(obj.userValidation)
      ..writeByte(221)
      ..write(obj.userValidationId)
      ..writeByte(223)
      ..write(obj.userClosingId)
      ..writeByte(225)
      ..write(obj.userModification)
      ..writeByte(227)
      ..write(obj.userModificationId)
      ..writeByte(229)
      ..write(obj.specimen)
      ..writeByte(231)
      ..write(obj.labelStatus)
      ..writeByte(233)
      ..write(obj.showphotoOnPopup)
      ..writeByte(235)
      ..write(obj.nb)
      ..writeByte(237)
      ..write(obj.output)
      ..writeByte(239)
      ..write(obj.extraparams)
      ..writeByte(241)
      ..write(obj.codeVentilation);
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
      brouillon: json['brouillon'],
      socid: json['socid'],
      userAuthor: json['user_author'],
      fkUserAuthor: json['fk_user_author'],
      userValid: json['user_valid'],
      fkUserValid: json['fk_user_valid'],
      userModification: json['user_modification'],
      fkUserModif: json['fk_user_modif'],
      date: json['date'],
      datem: json['datem'],
      dateLivraison: json['date_livraison'],
      deliveryDate: json['delivery_date'],
      refClient: json['ref_client'],
      refCustomer: json['ref_customer'],
      remiseAbsolue: json['remise_absolue'],
      remisePercent: json['remise_percent'],
      totalHt: json['total_ht'],
      totalTva: json['total_tva'],
      totalLocaltax1: json['total_localtax1'],
      totalLocaltax2: json['total_localtax2'],
      totalTtc: json['total_ttc'],
      revenuestamp: json['revenuestamp'],
      resteapayer: json['resteapayer'],
      closeCode: json['close_code'],
      closeNote: json['close_note'],
      paye: json['paye'],
      moduleSource: json['module_source'],
      posSource: json['pos_source'],
      fkFacRecSource: json['fk_fac_rec_source'],
      fkFactureSource: json['fk_facture_source'],
      linkedObjects: json['linked_objects'] as List<dynamic>?,
      dateLimReglement: json['date_lim_reglement'],
      condReglementCode: json['cond_reglement_code'],
      condReglementDoc: json['cond_reglement_doc'],
      modeReglementCode: json['mode_reglement_code'],
      fkBank: json['fk_bank'],
      lines: (json['lines'] as List<dynamic>?)
          ?.map((e) => Line.fromJson(e as Map<String, dynamic>))
          .toList(),
      line: json['line'],
      extraparams: json['extraparams'],
      facRec: json['fac_rec'],
      datePointoftax: json['date_pointoftax'],
      fkMulticurrency: json['fk_multicurrency'],
      multicurrencyCode: json['multicurrency_code'],
      multicurrencyTx: json['multicurrency_tx'],
      multicurrencyTotalHt: json['multicurrency_total_ht'],
      multicurrencyTotalTva: json['multicurrency_total_tva'],
      multicurrencyTotalTtc: json['multicurrency_total_ttc'],
      situationCycleRef: json['situation_cycle_ref'],
      situationCounter: json['situation_counter'],
      situationFinal: json['situation_final'],
      tabPreviousSituationInvoice:
          json['tab_previous_situation_invoice'] as List<dynamic>?,
      tabNextSituationInvoice:
          json['tab_next_situation_invoice'] as List<dynamic>?,
      retainedWarranty: json['retained_warranty'],
      retainedWarrantyDateLimit: json['retained_warranty_date_limit'],
      retainedWarrantyFkCondReglement:
          json['retained_warranty_fk_cond_reglement'],
      type: json['type'],
      subtype: json['subtype'],
      totalpaid: json['totalpaid'],
      totaldeposits: json['totaldeposits'],
      totalcreditnotes: json['totalcreditnotes'],
      sumpayed: json['sumpayed'],
      sumpayedMulticurrency: json['sumpayed_multicurrency'],
      sumdeposit: json['sumdeposit'],
      sumdepositMulticurrency: json['sumdeposit_multicurrency'],
      sumcreditnote: json['sumcreditnote'],
      sumcreditnoteMulticurrency: json['sumcreditnote_multicurrency'],
      remaintopay: json['remaintopay'],
      module: json['module'],
      id: json['id'],
      entity: json['entity'],
      importKey: json['import_key'],
      arrayOptions: json['array_options'] as List<dynamic>?,
      arrayLanguages: json['array_languages'],
      contactsIds: json['contacts_ids'] as List<dynamic>?,
      linkedObjectsIds: json['linkedObjectsIds'],
      oldref: json['oldref'],
      fkProject: json['fk_project'],
      contactId: json['contact_id'],
      user: json['user'],
      origin: json['origin'],
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
      modelPdf: json['model_pdf'],
      lastMainDoc: json['last_main_doc'],
      fkAccount: json['fk_account'],
      notePublic: json['note_public'],
      notePrivate: json['note_private'],
      name: json['name'],
      lastname: json['lastname'],
      firstname: json['firstname'],
      civilityId: json['civility_id'],
      dateCreation: json['date_creation'],
      dateValidation: json['date_validation'],
      dateModification: json['date_modification'],
      dateUpdate: json['date_update'],
      dateCloture: json['date_cloture'],
      userCreation: json['user_creation'],
      userCreationId: json['user_creation_id'],
      userValidation: json['user_validation'],
      userValidationId: json['user_validation_id'],
      userClosingId: json['user_closing_id'],
      userModificationId: json['user_modification_id'],
      specimen: json['specimen'],
      labelStatus: json['labelStatus'],
      showphotoOnPopup: json['showphoto_on_popup'],
      nb: json['nb'] as List<dynamic>?,
      output: json['output'],
      fkIncoterms: json['fk_incoterms'],
      labelIncoterms: json['label_incoterms'],
      locationIncoterms: json['location_incoterms'],
      nom: json['nom'],
    );

Map<String, dynamic> _$InvoiceModelToJson(InvoiceModel instance) =>
    <String, dynamic>{
      'brouillon': instance.brouillon,
      'socid': instance.socid,
      'user_author': instance.userAuthor,
      'fk_user_author': instance.fkUserAuthor,
      'user_valid': instance.userValid,
      'fk_user_valid': instance.fkUserValid,
      'user_modification': instance.userModification,
      'fk_user_modif': instance.fkUserModif,
      'date': instance.date,
      'datem': instance.datem,
      'date_livraison': instance.dateLivraison,
      'delivery_date': instance.deliveryDate,
      'ref_client': instance.refClient,
      'ref_customer': instance.refCustomer,
      'remise_absolue': instance.remiseAbsolue,
      'remise_percent': instance.remisePercent,
      'total_ht': instance.totalHt,
      'total_tva': instance.totalTva,
      'total_localtax1': instance.totalLocaltax1,
      'total_localtax2': instance.totalLocaltax2,
      'total_ttc': instance.totalTtc,
      'revenuestamp': instance.revenuestamp,
      'resteapayer': instance.resteapayer,
      'close_code': instance.closeCode,
      'close_note': instance.closeNote,
      'paye': instance.paye,
      'module_source': instance.moduleSource,
      'pos_source': instance.posSource,
      'fk_fac_rec_source': instance.fkFacRecSource,
      'fk_facture_source': instance.fkFactureSource,
      'linked_objects': instance.linkedObjects,
      'date_lim_reglement': instance.dateLimReglement,
      'cond_reglement_code': instance.condReglementCode,
      'cond_reglement_doc': instance.condReglementDoc,
      'mode_reglement_code': instance.modeReglementCode,
      'fk_bank': instance.fkBank,
      'lines': instance.lines,
      'line': instance.line,
      'extraparams': instance.extraparams,
      'fac_rec': instance.facRec,
      'date_pointoftax': instance.datePointoftax,
      'fk_multicurrency': instance.fkMulticurrency,
      'multicurrency_code': instance.multicurrencyCode,
      'multicurrency_tx': instance.multicurrencyTx,
      'multicurrency_total_ht': instance.multicurrencyTotalHt,
      'multicurrency_total_tva': instance.multicurrencyTotalTva,
      'multicurrency_total_ttc': instance.multicurrencyTotalTtc,
      'situation_cycle_ref': instance.situationCycleRef,
      'situation_counter': instance.situationCounter,
      'situation_final': instance.situationFinal,
      'tab_previous_situation_invoice': instance.tabPreviousSituationInvoice,
      'tab_next_situation_invoice': instance.tabNextSituationInvoice,
      'retained_warranty': instance.retainedWarranty,
      'retained_warranty_date_limit': instance.retainedWarrantyDateLimit,
      'retained_warranty_fk_cond_reglement':
          instance.retainedWarrantyFkCondReglement,
      'type': instance.type,
      'subtype': instance.subtype,
      'totalpaid': instance.totalpaid,
      'totaldeposits': instance.totaldeposits,
      'totalcreditnotes': instance.totalcreditnotes,
      'sumpayed': instance.sumpayed,
      'sumpayed_multicurrency': instance.sumpayedMulticurrency,
      'sumdeposit': instance.sumdeposit,
      'sumdeposit_multicurrency': instance.sumdepositMulticurrency,
      'sumcreditnote': instance.sumcreditnote,
      'sumcreditnote_multicurrency': instance.sumcreditnoteMulticurrency,
      'remaintopay': instance.remaintopay,
      'module': instance.module,
      'id': instance.id,
      'entity': instance.entity,
      'import_key': instance.importKey,
      'array_options': instance.arrayOptions,
      'array_languages': instance.arrayLanguages,
      'contacts_ids': instance.contactsIds,
      'linkedObjectsIds': instance.linkedObjectsIds,
      'oldref': instance.oldref,
      'fk_project': instance.fkProject,
      'contact_id': instance.contactId,
      'user': instance.user,
      'origin': instance.origin,
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
      'model_pdf': instance.modelPdf,
      'last_main_doc': instance.lastMainDoc,
      'fk_account': instance.fkAccount,
      'note_public': instance.notePublic,
      'note_private': instance.notePrivate,
      'name': instance.name,
      'lastname': instance.lastname,
      'firstname': instance.firstname,
      'civility_id': instance.civilityId,
      'date_creation': instance.dateCreation,
      'date_validation': instance.dateValidation,
      'date_modification': instance.dateModification,
      'date_update': instance.dateUpdate,
      'date_cloture': instance.dateCloture,
      'user_creation': instance.userCreation,
      'user_creation_id': instance.userCreationId,
      'user_validation': instance.userValidation,
      'user_validation_id': instance.userValidationId,
      'user_closing_id': instance.userClosingId,
      'user_modification_id': instance.userModificationId,
      'specimen': instance.specimen,
      'labelStatus': instance.labelStatus,
      'showphoto_on_popup': instance.showphotoOnPopup,
      'nb': instance.nb,
      'output': instance.output,
      'fk_incoterms': instance.fkIncoterms,
      'label_incoterms': instance.labelIncoterms,
      'location_incoterms': instance.locationIncoterms,
      'nom': instance.nom,
    };

Line _$LineFromJson(Map<String, dynamic> json) => Line(
      fkFacture: json['fk_facture'],
      fkParentLine: json['fk_parent_line'],
      desc: json['desc'],
      refExt: json['ref_ext'],
      localtax1Type: json['localtax1_type'],
      localtax2Type: json['localtax2_type'],
      fkRemiseExcept: json['fk_remise_except'],
      rang: json['rang'],
      fkFournprice: json['fk_fournprice'],
      paHt: json['pa_ht'],
      margeTx: json['marge_tx'],
      marqueTx: json['marque_tx'],
      remisePercent: json['remise_percent'],
      specialCode: json['special_code'],
      origin: json['origin'],
      originId: json['origin_id'],
      fkCodeVentilation: json['fk_code_ventilation'],
      dateStart: json['date_start'],
      dateEnd: json['date_end'],
      situationPercent: json['situation_percent'],
      fkPrevId: json['fk_prev_id'],
      multicurrencySubprice: json['multicurrency_subprice'],
      multicurrencyTotalHt: json['multicurrency_total_ht'],
      multicurrencyTotalTva: json['multicurrency_total_tva'],
      multicurrencyTotalTtc: json['multicurrency_total_ttc'],
      label: json['label'],
      ref: json['ref'],
      libelle: json['libelle'],
      productType: json['product_type'],
      productRef: json['product_ref'],
      productLabel: json['product_label'],
      productDesc: json['product_desc'],
      qty: json['qty'],
      subprice: json['subprice'],
      price: json['price'],
      fkProduct: json['fk_product'],
      vatSrcCode: json['vat_src_code'],
      tvaTx: json['tva_tx'],
      localtax1Tx: json['localtax1_tx'],
      localtax2Tx: json['localtax2_tx'],
      remise: json['remise'],
      totalHt: json['total_ht'],
      totalTva: json['total_tva'],
      totalLocaltax1: json['total_localtax1'],
      totalLocaltax2: json['total_localtax2'],
      totalTtc: json['total_ttc'],
      dateStartFill: json['date_start_fill'],
      dateEndFill: json['date_end_fill'],
      buyPriceHt: json['buy_price_ht'],
      buyprice: json['buyprice'],
      infoBits: json['info_bits'],
      fkUserAuthor: json['fk_user_author'],
      fkUserModif: json['fk_user_modif'],
      fkAccountingAccount: json['fk_accounting_account'],
      id: json['id'],
      rowid: json['rowid'],
      fkUnit: json['fk_unit'],
      dateDebutPrevue: json['date_debut_prevue'],
      dateDebutReel: json['date_debut_reel'],
      dateFinPrevue: json['date_fin_prevue'],
      dateFinReel: json['date_fin_reel'],
      weight: json['weight'],
      weightUnits: json['weight_units'],
      width: json['width'],
      widthUnits: json['width_units'],
      height: json['height'],
      heightUnits: json['height_units'],
      length: json['length'],
      lengthUnits: json['length_units'],
      surface: json['surface'],
      surfaceUnits: json['surface_units'],
      volume: json['volume'],
      volumeUnits: json['volume_units'],
      multilangs: json['multilangs'],
      description: json['description'],
      product: json['product'],
      productBarcode: json['product_barcode'],
      fkProductType: json['fk_product_type'],
      duree: json['duree'],
      module: json['module'],
      entity: json['entity'],
      importKey: json['import_key'],
      arrayOptions: json['array_options'] as List<dynamic>?,
      arrayLanguages: json['array_languages'],
      contactsIds: json['contacts_ids'],
      linkedObjects: json['linked_objects'],
      linkedObjectsIds: json['linkedObjectsIds'],
      oldref: json['oldref'],
      statut: json['statut'],
      status: json['status'],
      stateId: json['state_id'],
      regionId: json['region_id'],
      demandReasonId: json['demand_reason_id'],
      transportModeId: json['transport_mode_id'],
      shippingMethod: json['shipping_method'],
      multicurrencyTx: json['multicurrency_tx'],
      lastMainDoc: json['last_main_doc'],
      fkBank: json['fk_bank'],
      fkAccount: json['fk_account'],
      lines: json['lines'],
      dateCreation: json['date_creation'],
      dateValidation: json['date_validation'],
      dateModification: json['date_modification'],
      dateUpdate: json['date_update'],
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
      specimen: json['specimen'],
      labelStatus: json['labelStatus'],
      showphotoOnPopup: json['showphoto_on_popup'],
      nb: json['nb'] as List<dynamic>?,
      output: json['output'],
      extraparams: json['extraparams'],
      codeVentilation: json['code_ventilation'],
    );

Map<String, dynamic> _$LineToJson(Line instance) => <String, dynamic>{
      'fk_facture': instance.fkFacture,
      'fk_parent_line': instance.fkParentLine,
      'desc': instance.desc,
      'ref_ext': instance.refExt,
      'localtax1_type': instance.localtax1Type,
      'localtax2_type': instance.localtax2Type,
      'fk_remise_except': instance.fkRemiseExcept,
      'rang': instance.rang,
      'fk_fournprice': instance.fkFournprice,
      'pa_ht': instance.paHt,
      'marge_tx': instance.margeTx,
      'marque_tx': instance.marqueTx,
      'remise_percent': instance.remisePercent,
      'special_code': instance.specialCode,
      'origin': instance.origin,
      'origin_id': instance.originId,
      'fk_code_ventilation': instance.fkCodeVentilation,
      'date_start': instance.dateStart,
      'date_end': instance.dateEnd,
      'situation_percent': instance.situationPercent,
      'fk_prev_id': instance.fkPrevId,
      'multicurrency_subprice': instance.multicurrencySubprice,
      'multicurrency_total_ht': instance.multicurrencyTotalHt,
      'multicurrency_total_tva': instance.multicurrencyTotalTva,
      'multicurrency_total_ttc': instance.multicurrencyTotalTtc,
      'label': instance.label,
      'ref': instance.ref,
      'libelle': instance.libelle,
      'product_type': instance.productType,
      'product_ref': instance.productRef,
      'product_label': instance.productLabel,
      'product_desc': instance.productDesc,
      'qty': instance.qty,
      'subprice': instance.subprice,
      'price': instance.price,
      'fk_product': instance.fkProduct,
      'vat_src_code': instance.vatSrcCode,
      'tva_tx': instance.tvaTx,
      'localtax1_tx': instance.localtax1Tx,
      'localtax2_tx': instance.localtax2Tx,
      'remise': instance.remise,
      'total_ht': instance.totalHt,
      'total_tva': instance.totalTva,
      'total_localtax1': instance.totalLocaltax1,
      'total_localtax2': instance.totalLocaltax2,
      'total_ttc': instance.totalTtc,
      'date_start_fill': instance.dateStartFill,
      'date_end_fill': instance.dateEndFill,
      'buy_price_ht': instance.buyPriceHt,
      'buyprice': instance.buyprice,
      'info_bits': instance.infoBits,
      'fk_user_author': instance.fkUserAuthor,
      'fk_user_modif': instance.fkUserModif,
      'fk_accounting_account': instance.fkAccountingAccount,
      'id': instance.id,
      'rowid': instance.rowid,
      'fk_unit': instance.fkUnit,
      'date_debut_prevue': instance.dateDebutPrevue,
      'date_debut_reel': instance.dateDebutReel,
      'date_fin_prevue': instance.dateFinPrevue,
      'date_fin_reel': instance.dateFinReel,
      'weight': instance.weight,
      'weight_units': instance.weightUnits,
      'width': instance.width,
      'width_units': instance.widthUnits,
      'height': instance.height,
      'height_units': instance.heightUnits,
      'length': instance.length,
      'length_units': instance.lengthUnits,
      'surface': instance.surface,
      'surface_units': instance.surfaceUnits,
      'volume': instance.volume,
      'volume_units': instance.volumeUnits,
      'multilangs': instance.multilangs,
      'description': instance.description,
      'product': instance.product,
      'product_barcode': instance.productBarcode,
      'fk_product_type': instance.fkProductType,
      'duree': instance.duree,
      'module': instance.module,
      'entity': instance.entity,
      'import_key': instance.importKey,
      'array_options': instance.arrayOptions,
      'array_languages': instance.arrayLanguages,
      'contacts_ids': instance.contactsIds,
      'linked_objects': instance.linkedObjects,
      'linkedObjectsIds': instance.linkedObjectsIds,
      'oldref': instance.oldref,
      'statut': instance.statut,
      'status': instance.status,
      'state_id': instance.stateId,
      'region_id': instance.regionId,
      'demand_reason_id': instance.demandReasonId,
      'transport_mode_id': instance.transportModeId,
      'shipping_method': instance.shippingMethod,
      'multicurrency_tx': instance.multicurrencyTx,
      'last_main_doc': instance.lastMainDoc,
      'fk_bank': instance.fkBank,
      'fk_account': instance.fkAccount,
      'lines': instance.lines,
      'date_creation': instance.dateCreation,
      'date_validation': instance.dateValidation,
      'date_modification': instance.dateModification,
      'date_update': instance.dateUpdate,
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
      'specimen': instance.specimen,
      'labelStatus': instance.labelStatus,
      'showphoto_on_popup': instance.showphotoOnPopup,
      'nb': instance.nb,
      'output': instance.output,
      'extraparams': instance.extraparams,
      'code_ventilation': instance.codeVentilation,
    };
