// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomerModelAdapter extends TypeAdapter<CustomerModel> {
  @override
  final typeId = 3;

  @override
  CustomerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomerModel(
      module: fields[1] as dynamic,
      supplierCategories: (fields[2] as List?)?.cast<dynamic>(),
      prefixCustomerIsRequired: fields[3] as dynamic,
      entity: fields[4] as dynamic,
      name: fields[5] as dynamic,
      nameAlias: fields[6] as dynamic,
      status: fields[7] as dynamic,
      phone: fields[8] as dynamic,
      fax: fields[9] as dynamic,
      email: fields[10] as dynamic,
      noEmail: fields[11] as dynamic,
      skype: fields[12] as dynamic,
      twitter: fields[13] as dynamic,
      facebook: fields[14] as dynamic,
      linkedin: fields[15] as dynamic,
      url: fields[16] as dynamic,
      barcode: fields[17] as dynamic,
      idprof1: fields[18] as dynamic,
      idprof2: fields[19] as dynamic,
      idprof3: fields[20] as dynamic,
      idprof4: fields[21] as dynamic,
      idprof5: fields[22] as dynamic,
      idprof6: fields[23] as dynamic,
      socialobject: fields[24] as dynamic,
      tvaAssuj: fields[25] as dynamic,
      tvaIntra: fields[26] as dynamic,
      vatReverseCharge: fields[27] as dynamic,
      localtax1Assuj: fields[28] as dynamic,
      localtax1Value: fields[29] as dynamic,
      localtax2Assuj: fields[30] as dynamic,
      localtax2Value: fields[31] as dynamic,
      managers: fields[32] as dynamic,
      capital: fields[33] as dynamic,
      typentId: fields[34] as dynamic,
      typentCode: fields[35] as dynamic,
      effectif: fields[36] as dynamic,
      effectifId: fields[37] as dynamic,
      formeJuridiqueCode: fields[38] as dynamic,
      formeJuridique: fields[39] as dynamic,
      remisePercent: fields[40] as dynamic,
      remiseSupplierPercent: fields[41] as dynamic,
      modeReglementId: fields[42] as dynamic,
      condReglementId: fields[43] as dynamic,
      depositPercent: fields[44] as dynamic,
      modeReglementSupplierId: fields[45] as dynamic,
      condReglementSupplierId: fields[46] as dynamic,
      transportModeSupplierId: fields[47] as dynamic,
      fkProspectlevel: fields[48] as dynamic,
      dateModification: fields[49] as dynamic,
      userModification: fields[50] as dynamic,
      dateCreation: fields[51] as dynamic,
      userCreation: fields[52] as dynamic,
      client: fields[53] as dynamic,
      prospect: fields[54] as dynamic,
      fournisseur: fields[55] as dynamic,
      codeClient: fields[56] as dynamic,
      codeFournisseur: fields[57] as dynamic,
      codeComptaClient: fields[58] as dynamic,
      codeCompta: fields[59] as dynamic,
      accountancyCodeCustomer: fields[60] as dynamic,
      codeComptaFournisseur: fields[61] as dynamic,
      accountancyCodeSupplier: fields[62] as dynamic,
      codeComptaProduct: fields[63] as dynamic,
      notePrivate: fields[64] as dynamic,
      notePublic: fields[65] as dynamic,
      stcommId: fields[66] as dynamic,
      stcommPicto: fields[67] as dynamic,
      statusProspectLabel: fields[68] as dynamic,
      priceLevel: fields[69] as dynamic,
      outstandingLimit: fields[70] as dynamic,
      orderMinAmount: fields[71] as dynamic,
      supplierOrderMinAmount: fields[72] as dynamic,
      parent: fields[73] as dynamic,
      defaultLang: fields[74] as dynamic,
      ref: fields[75] as dynamic,
      refExt: fields[76] as dynamic,
      importKey: fields[77] as dynamic,
      webservicesUrl: fields[78] as dynamic,
      webservicesKey: fields[79] as dynamic,
      logo: fields[80] as dynamic,
      logoSmall: fields[81] as dynamic,
      logoMini: fields[82] as dynamic,
      logoSquarred: fields[83] as dynamic,
      logoSquarredSmall: fields[84] as dynamic,
      logoSquarredMini: fields[85] as dynamic,
      accountancyCodeSell: fields[86] as dynamic,
      accountancyCodeBuy: fields[87] as dynamic,
      fkMulticurrency: fields[88] as dynamic,
      fkWarehouse: fields[89] as dynamic,
      multicurrencyCode: fields[90] as dynamic,
      partnerships: (fields[91] as List?)?.cast<dynamic>(),
      bankAccount: fields[92] as dynamic,
      id: fields[93] as dynamic,
      arrayOptions: (fields[94] as List?)?.cast<dynamic>(),
      arrayLanguages: fields[95] as dynamic,
      contactsIds: fields[96] as dynamic,
      linkedObjects: fields[97] as dynamic,
      linkedObjectsIds: fields[98] as dynamic,
      oldref: fields[99] as dynamic,
      canvas: fields[100] as dynamic,
      fkProject: fields[101] as dynamic,
      contactId: fields[102] as dynamic,
      user: fields[103] as dynamic,
      origin: fields[104] as dynamic,
      originId: fields[105] as dynamic,
      statut: fields[106] as dynamic,
      countryId: fields[107] as dynamic,
      countryCode: fields[108] as dynamic,
      stateId: fields[109] as dynamic,
      regionId: fields[110] as dynamic,
      barcodeType: fields[111] as dynamic,
      barcodeTypeCoder: fields[112] as dynamic,
      demandReasonId: fields[113] as dynamic,
      transportModeId: fields[114] as dynamic,
      shippingMethodId: fields[115] as dynamic,
      shippingMethod: fields[116] as dynamic,
      multicurrencyTx: fields[117] as dynamic,
      modelPdf: fields[118] as dynamic,
      lastMainDoc: fields[119] as dynamic,
      fkBank: fields[120] as dynamic,
      fkAccount: fields[121] as dynamic,
      lastname: fields[122] as dynamic,
      firstname: fields[123] as dynamic,
      civilityId: fields[124] as dynamic,
      dateValidation: fields[125] as dynamic,
      dateUpdate: fields[126] as dynamic,
      dateCloture: fields[127] as dynamic,
      userAuthor: fields[128] as dynamic,
      userCreationId: fields[129] as dynamic,
      userValid: fields[130] as dynamic,
      userValidation: fields[131] as dynamic,
      userValidationId: fields[132] as dynamic,
      userClosingId: fields[133] as dynamic,
      userModificationId: fields[134] as dynamic,
      specimen: fields[135] as dynamic,
      labelStatus: fields[136] as dynamic,
      showphotoOnPopup: fields[137] as dynamic,
      nb: (fields[138] as List?)?.cast<dynamic>(),
      output: fields[139] as dynamic,
      extraparams: (fields[140] as List?)?.cast<dynamic>(),
      fkIncoterms: fields[141] as dynamic,
      labelIncoterms: fields[142] as dynamic,
      locationIncoterms: fields[143] as dynamic,
      socialnetworks: (fields[144] as List?)?.cast<dynamic>(),
      address: fields[145] as dynamic,
      zip: fields[146] as dynamic,
      town: fields[147] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, CustomerModel obj) {
    writer
      ..writeByte(147)
      ..writeByte(1)
      ..write(obj.module)
      ..writeByte(2)
      ..write(obj.supplierCategories)
      ..writeByte(3)
      ..write(obj.prefixCustomerIsRequired)
      ..writeByte(4)
      ..write(obj.entity)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.nameAlias)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.phone)
      ..writeByte(9)
      ..write(obj.fax)
      ..writeByte(10)
      ..write(obj.email)
      ..writeByte(11)
      ..write(obj.noEmail)
      ..writeByte(12)
      ..write(obj.skype)
      ..writeByte(13)
      ..write(obj.twitter)
      ..writeByte(14)
      ..write(obj.facebook)
      ..writeByte(15)
      ..write(obj.linkedin)
      ..writeByte(16)
      ..write(obj.url)
      ..writeByte(17)
      ..write(obj.barcode)
      ..writeByte(18)
      ..write(obj.idprof1)
      ..writeByte(19)
      ..write(obj.idprof2)
      ..writeByte(20)
      ..write(obj.idprof3)
      ..writeByte(21)
      ..write(obj.idprof4)
      ..writeByte(22)
      ..write(obj.idprof5)
      ..writeByte(23)
      ..write(obj.idprof6)
      ..writeByte(24)
      ..write(obj.socialobject)
      ..writeByte(25)
      ..write(obj.tvaAssuj)
      ..writeByte(26)
      ..write(obj.tvaIntra)
      ..writeByte(27)
      ..write(obj.vatReverseCharge)
      ..writeByte(28)
      ..write(obj.localtax1Assuj)
      ..writeByte(29)
      ..write(obj.localtax1Value)
      ..writeByte(30)
      ..write(obj.localtax2Assuj)
      ..writeByte(31)
      ..write(obj.localtax2Value)
      ..writeByte(32)
      ..write(obj.managers)
      ..writeByte(33)
      ..write(obj.capital)
      ..writeByte(34)
      ..write(obj.typentId)
      ..writeByte(35)
      ..write(obj.typentCode)
      ..writeByte(36)
      ..write(obj.effectif)
      ..writeByte(37)
      ..write(obj.effectifId)
      ..writeByte(38)
      ..write(obj.formeJuridiqueCode)
      ..writeByte(39)
      ..write(obj.formeJuridique)
      ..writeByte(40)
      ..write(obj.remisePercent)
      ..writeByte(41)
      ..write(obj.remiseSupplierPercent)
      ..writeByte(42)
      ..write(obj.modeReglementId)
      ..writeByte(43)
      ..write(obj.condReglementId)
      ..writeByte(44)
      ..write(obj.depositPercent)
      ..writeByte(45)
      ..write(obj.modeReglementSupplierId)
      ..writeByte(46)
      ..write(obj.condReglementSupplierId)
      ..writeByte(47)
      ..write(obj.transportModeSupplierId)
      ..writeByte(48)
      ..write(obj.fkProspectlevel)
      ..writeByte(49)
      ..write(obj.dateModification)
      ..writeByte(50)
      ..write(obj.userModification)
      ..writeByte(51)
      ..write(obj.dateCreation)
      ..writeByte(52)
      ..write(obj.userCreation)
      ..writeByte(53)
      ..write(obj.client)
      ..writeByte(54)
      ..write(obj.prospect)
      ..writeByte(55)
      ..write(obj.fournisseur)
      ..writeByte(56)
      ..write(obj.codeClient)
      ..writeByte(57)
      ..write(obj.codeFournisseur)
      ..writeByte(58)
      ..write(obj.codeComptaClient)
      ..writeByte(59)
      ..write(obj.codeCompta)
      ..writeByte(60)
      ..write(obj.accountancyCodeCustomer)
      ..writeByte(61)
      ..write(obj.codeComptaFournisseur)
      ..writeByte(62)
      ..write(obj.accountancyCodeSupplier)
      ..writeByte(63)
      ..write(obj.codeComptaProduct)
      ..writeByte(64)
      ..write(obj.notePrivate)
      ..writeByte(65)
      ..write(obj.notePublic)
      ..writeByte(66)
      ..write(obj.stcommId)
      ..writeByte(67)
      ..write(obj.stcommPicto)
      ..writeByte(68)
      ..write(obj.statusProspectLabel)
      ..writeByte(69)
      ..write(obj.priceLevel)
      ..writeByte(70)
      ..write(obj.outstandingLimit)
      ..writeByte(71)
      ..write(obj.orderMinAmount)
      ..writeByte(72)
      ..write(obj.supplierOrderMinAmount)
      ..writeByte(73)
      ..write(obj.parent)
      ..writeByte(74)
      ..write(obj.defaultLang)
      ..writeByte(75)
      ..write(obj.ref)
      ..writeByte(76)
      ..write(obj.refExt)
      ..writeByte(77)
      ..write(obj.importKey)
      ..writeByte(78)
      ..write(obj.webservicesUrl)
      ..writeByte(79)
      ..write(obj.webservicesKey)
      ..writeByte(80)
      ..write(obj.logo)
      ..writeByte(81)
      ..write(obj.logoSmall)
      ..writeByte(82)
      ..write(obj.logoMini)
      ..writeByte(83)
      ..write(obj.logoSquarred)
      ..writeByte(84)
      ..write(obj.logoSquarredSmall)
      ..writeByte(85)
      ..write(obj.logoSquarredMini)
      ..writeByte(86)
      ..write(obj.accountancyCodeSell)
      ..writeByte(87)
      ..write(obj.accountancyCodeBuy)
      ..writeByte(88)
      ..write(obj.fkMulticurrency)
      ..writeByte(89)
      ..write(obj.fkWarehouse)
      ..writeByte(90)
      ..write(obj.multicurrencyCode)
      ..writeByte(91)
      ..write(obj.partnerships)
      ..writeByte(92)
      ..write(obj.bankAccount)
      ..writeByte(93)
      ..write(obj.id)
      ..writeByte(94)
      ..write(obj.arrayOptions)
      ..writeByte(95)
      ..write(obj.arrayLanguages)
      ..writeByte(96)
      ..write(obj.contactsIds)
      ..writeByte(97)
      ..write(obj.linkedObjects)
      ..writeByte(98)
      ..write(obj.linkedObjectsIds)
      ..writeByte(99)
      ..write(obj.oldref)
      ..writeByte(100)
      ..write(obj.canvas)
      ..writeByte(101)
      ..write(obj.fkProject)
      ..writeByte(102)
      ..write(obj.contactId)
      ..writeByte(103)
      ..write(obj.user)
      ..writeByte(104)
      ..write(obj.origin)
      ..writeByte(105)
      ..write(obj.originId)
      ..writeByte(106)
      ..write(obj.statut)
      ..writeByte(107)
      ..write(obj.countryId)
      ..writeByte(108)
      ..write(obj.countryCode)
      ..writeByte(109)
      ..write(obj.stateId)
      ..writeByte(110)
      ..write(obj.regionId)
      ..writeByte(111)
      ..write(obj.barcodeType)
      ..writeByte(112)
      ..write(obj.barcodeTypeCoder)
      ..writeByte(113)
      ..write(obj.demandReasonId)
      ..writeByte(114)
      ..write(obj.transportModeId)
      ..writeByte(115)
      ..write(obj.shippingMethodId)
      ..writeByte(116)
      ..write(obj.shippingMethod)
      ..writeByte(117)
      ..write(obj.multicurrencyTx)
      ..writeByte(118)
      ..write(obj.modelPdf)
      ..writeByte(119)
      ..write(obj.lastMainDoc)
      ..writeByte(120)
      ..write(obj.fkBank)
      ..writeByte(121)
      ..write(obj.fkAccount)
      ..writeByte(122)
      ..write(obj.lastname)
      ..writeByte(123)
      ..write(obj.firstname)
      ..writeByte(124)
      ..write(obj.civilityId)
      ..writeByte(125)
      ..write(obj.dateValidation)
      ..writeByte(126)
      ..write(obj.dateUpdate)
      ..writeByte(127)
      ..write(obj.dateCloture)
      ..writeByte(128)
      ..write(obj.userAuthor)
      ..writeByte(129)
      ..write(obj.userCreationId)
      ..writeByte(130)
      ..write(obj.userValid)
      ..writeByte(131)
      ..write(obj.userValidation)
      ..writeByte(132)
      ..write(obj.userValidationId)
      ..writeByte(133)
      ..write(obj.userClosingId)
      ..writeByte(134)
      ..write(obj.userModificationId)
      ..writeByte(135)
      ..write(obj.specimen)
      ..writeByte(136)
      ..write(obj.labelStatus)
      ..writeByte(137)
      ..write(obj.showphotoOnPopup)
      ..writeByte(138)
      ..write(obj.nb)
      ..writeByte(139)
      ..write(obj.output)
      ..writeByte(140)
      ..write(obj.extraparams)
      ..writeByte(141)
      ..write(obj.fkIncoterms)
      ..writeByte(142)
      ..write(obj.labelIncoterms)
      ..writeByte(143)
      ..write(obj.locationIncoterms)
      ..writeByte(144)
      ..write(obj.socialnetworks)
      ..writeByte(145)
      ..write(obj.address)
      ..writeByte(146)
      ..write(obj.zip)
      ..writeByte(147)
      ..write(obj.town);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
