// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 17;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[1] as String?,
      statut: fields[3] as String?,
      employee: fields[5] as String?,
      civilityCode: fields[7] as String?,
      fullname: fields[9] as dynamic,
      gender: fields[11] as dynamic,
      birth: fields[13] as String?,
      email: fields[15] as String?,
      personalEmail: fields[17] as String?,
      socialnetworks: (fields[19] as List?)?.cast<dynamic>(),
      job: fields[21] as String?,
      signature: fields[23] as String?,
      officePhone: fields[25] as String?,
      officeFax: fields[27] as String?,
      userMobile: fields[29] as String?,
      personalMobile: fields[31] as String?,
      admin: fields[33] as String?,
      login: fields[35] as String?,
      entity: fields[37] as String?,
      datec: (fields[39] as num?)?.toInt(),
      datem: (fields[41] as num?)?.toInt(),
      socid: fields[43] as dynamic,
      contactId: fields[45] as dynamic,
      fkMember: fields[47] as dynamic,
      fkUser: fields[49] as dynamic,
      fkUserExpenseValidator: fields[51] as dynamic,
      fkUserHolidayValidator: fields[53] as dynamic,
      clicktodialUrl: fields[55] as dynamic,
      clicktodialLogin: fields[57] as dynamic,
      clicktodialPoste: fields[59] as dynamic,
      datelastlogin: (fields[61] as num?)?.toInt(),
      datepreviouslogin: (fields[63] as num?)?.toInt(),
      flagdelsessionsbefore: (fields[65] as num?)?.toInt(),
      iplastlogin: fields[67] as String?,
      ippreviouslogin: fields[69] as String?,
      datestartvalidity: fields[71] as String?,
      dateendvalidity: fields[73] as String?,
      photo: fields[75] as dynamic,
      lang: fields[77] as dynamic,
      userGroupList: (fields[79] as List?)?.cast<dynamic>(),
      users: (fields[81] as List?)?.cast<dynamic>(),
      parentof: fields[83] as dynamic,
      accountancyCode: fields[85] as String?,
      thm: fields[87] as dynamic,
      tjm: fields[89] as dynamic,
      salary: fields[91] as dynamic,
      salaryextra: fields[93] as dynamic,
      weeklyhours: fields[95] as dynamic,
      color: fields[97] as String?,
      dateemployment: fields[99] as String?,
      dateemploymentend: fields[101] as String?,
      defaultCExpTaxCat: fields[103] as dynamic,
      refEmployee: fields[105] as String?,
      nationalRegistrationNumber: fields[107] as String?,
      defaultRange: fields[109] as dynamic,
      fkWarehouse: fields[111] as dynamic,
      module: fields[113] as dynamic,
      importKey: fields[115] as dynamic,
      arrayOptions: (fields[117] as List?)?.cast<dynamic>(),
      arrayLanguages: fields[119] as dynamic,
      contactsIds: fields[121] as dynamic,
      linkedObjects: fields[123] as dynamic,
      linkedObjectsIds: fields[125] as dynamic,
      oldref: fields[127] as dynamic,
      canvas: fields[129] as dynamic,
      fkProject: fields[131] as dynamic,
      user: fields[133] as dynamic,
      origin: fields[135] as dynamic,
      originId: fields[137] as dynamic,
      ref: fields[139] as String?,
      refExt: fields[141] as dynamic,
      status: fields[143] as String?,
      countryId: fields[145] as dynamic,
      countryCode: fields[147] as String?,
      stateId: fields[149] as String?,
      regionId: fields[151] as dynamic,
      barcodeType: fields[153] as dynamic,
      barcodeTypeCoder: fields[155] as dynamic,
      modeReglementId: fields[157] as dynamic,
      condReglementId: fields[159] as dynamic,
      demandReasonId: fields[161] as dynamic,
      transportModeId: fields[163] as dynamic,
      shippingMethod: fields[165] as dynamic,
      multicurrencyCode: fields[167] as dynamic,
      multicurrencyTx: fields[169] as dynamic,
      lastMainDoc: fields[171] as dynamic,
      fkBank: fields[173] as dynamic,
      fkAccount: fields[175] as dynamic,
      notePublic: fields[177] as String?,
      notePrivate: fields[179] as String?,
      name: fields[181] as dynamic,
      lastname: fields[183] as String?,
      firstname: fields[185] as String?,
      civilityId: fields[187] as dynamic,
      dateCreation: fields[189] as dynamic,
      dateValidation: fields[191] as dynamic,
      dateModification: fields[193] as dynamic,
      dateUpdate: fields[195] as dynamic,
      dateCloture: fields[197] as dynamic,
      userAuthor: fields[199] as dynamic,
      userCreation: fields[201] as dynamic,
      userCreationId: fields[203] as dynamic,
      userValid: fields[205] as dynamic,
      userValidation: fields[207] as dynamic,
      userValidationId: fields[209] as dynamic,
      userClosingId: fields[211] as dynamic,
      userModification: fields[213] as dynamic,
      userModificationId: fields[215] as dynamic,
      specimen: (fields[217] as num?)?.toInt(),
      labelStatus: fields[219] as dynamic,
      showphotoOnPopup: fields[221] as dynamic,
      nb: (fields[223] as List?)?.cast<dynamic>(),
      output: fields[225] as dynamic,
      extraparams: (fields[227] as List?)?.cast<dynamic>(),
      address: fields[229] as String?,
      zip: fields[231] as String?,
      town: fields[233] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(117)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.statut)
      ..writeByte(5)
      ..write(obj.employee)
      ..writeByte(7)
      ..write(obj.civilityCode)
      ..writeByte(9)
      ..write(obj.fullname)
      ..writeByte(11)
      ..write(obj.gender)
      ..writeByte(13)
      ..write(obj.birth)
      ..writeByte(15)
      ..write(obj.email)
      ..writeByte(17)
      ..write(obj.personalEmail)
      ..writeByte(19)
      ..write(obj.socialnetworks)
      ..writeByte(21)
      ..write(obj.job)
      ..writeByte(23)
      ..write(obj.signature)
      ..writeByte(25)
      ..write(obj.officePhone)
      ..writeByte(27)
      ..write(obj.officeFax)
      ..writeByte(29)
      ..write(obj.userMobile)
      ..writeByte(31)
      ..write(obj.personalMobile)
      ..writeByte(33)
      ..write(obj.admin)
      ..writeByte(35)
      ..write(obj.login)
      ..writeByte(37)
      ..write(obj.entity)
      ..writeByte(39)
      ..write(obj.datec)
      ..writeByte(41)
      ..write(obj.datem)
      ..writeByte(43)
      ..write(obj.socid)
      ..writeByte(45)
      ..write(obj.contactId)
      ..writeByte(47)
      ..write(obj.fkMember)
      ..writeByte(49)
      ..write(obj.fkUser)
      ..writeByte(51)
      ..write(obj.fkUserExpenseValidator)
      ..writeByte(53)
      ..write(obj.fkUserHolidayValidator)
      ..writeByte(55)
      ..write(obj.clicktodialUrl)
      ..writeByte(57)
      ..write(obj.clicktodialLogin)
      ..writeByte(59)
      ..write(obj.clicktodialPoste)
      ..writeByte(61)
      ..write(obj.datelastlogin)
      ..writeByte(63)
      ..write(obj.datepreviouslogin)
      ..writeByte(65)
      ..write(obj.flagdelsessionsbefore)
      ..writeByte(67)
      ..write(obj.iplastlogin)
      ..writeByte(69)
      ..write(obj.ippreviouslogin)
      ..writeByte(71)
      ..write(obj.datestartvalidity)
      ..writeByte(73)
      ..write(obj.dateendvalidity)
      ..writeByte(75)
      ..write(obj.photo)
      ..writeByte(77)
      ..write(obj.lang)
      ..writeByte(79)
      ..write(obj.userGroupList)
      ..writeByte(81)
      ..write(obj.users)
      ..writeByte(83)
      ..write(obj.parentof)
      ..writeByte(85)
      ..write(obj.accountancyCode)
      ..writeByte(87)
      ..write(obj.thm)
      ..writeByte(89)
      ..write(obj.tjm)
      ..writeByte(91)
      ..write(obj.salary)
      ..writeByte(93)
      ..write(obj.salaryextra)
      ..writeByte(95)
      ..write(obj.weeklyhours)
      ..writeByte(97)
      ..write(obj.color)
      ..writeByte(99)
      ..write(obj.dateemployment)
      ..writeByte(101)
      ..write(obj.dateemploymentend)
      ..writeByte(103)
      ..write(obj.defaultCExpTaxCat)
      ..writeByte(105)
      ..write(obj.refEmployee)
      ..writeByte(107)
      ..write(obj.nationalRegistrationNumber)
      ..writeByte(109)
      ..write(obj.defaultRange)
      ..writeByte(111)
      ..write(obj.fkWarehouse)
      ..writeByte(113)
      ..write(obj.module)
      ..writeByte(115)
      ..write(obj.importKey)
      ..writeByte(117)
      ..write(obj.arrayOptions)
      ..writeByte(119)
      ..write(obj.arrayLanguages)
      ..writeByte(121)
      ..write(obj.contactsIds)
      ..writeByte(123)
      ..write(obj.linkedObjects)
      ..writeByte(125)
      ..write(obj.linkedObjectsIds)
      ..writeByte(127)
      ..write(obj.oldref)
      ..writeByte(129)
      ..write(obj.canvas)
      ..writeByte(131)
      ..write(obj.fkProject)
      ..writeByte(133)
      ..write(obj.user)
      ..writeByte(135)
      ..write(obj.origin)
      ..writeByte(137)
      ..write(obj.originId)
      ..writeByte(139)
      ..write(obj.ref)
      ..writeByte(141)
      ..write(obj.refExt)
      ..writeByte(143)
      ..write(obj.status)
      ..writeByte(145)
      ..write(obj.countryId)
      ..writeByte(147)
      ..write(obj.countryCode)
      ..writeByte(149)
      ..write(obj.stateId)
      ..writeByte(151)
      ..write(obj.regionId)
      ..writeByte(153)
      ..write(obj.barcodeType)
      ..writeByte(155)
      ..write(obj.barcodeTypeCoder)
      ..writeByte(157)
      ..write(obj.modeReglementId)
      ..writeByte(159)
      ..write(obj.condReglementId)
      ..writeByte(161)
      ..write(obj.demandReasonId)
      ..writeByte(163)
      ..write(obj.transportModeId)
      ..writeByte(165)
      ..write(obj.shippingMethod)
      ..writeByte(167)
      ..write(obj.multicurrencyCode)
      ..writeByte(169)
      ..write(obj.multicurrencyTx)
      ..writeByte(171)
      ..write(obj.lastMainDoc)
      ..writeByte(173)
      ..write(obj.fkBank)
      ..writeByte(175)
      ..write(obj.fkAccount)
      ..writeByte(177)
      ..write(obj.notePublic)
      ..writeByte(179)
      ..write(obj.notePrivate)
      ..writeByte(181)
      ..write(obj.name)
      ..writeByte(183)
      ..write(obj.lastname)
      ..writeByte(185)
      ..write(obj.firstname)
      ..writeByte(187)
      ..write(obj.civilityId)
      ..writeByte(189)
      ..write(obj.dateCreation)
      ..writeByte(191)
      ..write(obj.dateValidation)
      ..writeByte(193)
      ..write(obj.dateModification)
      ..writeByte(195)
      ..write(obj.dateUpdate)
      ..writeByte(197)
      ..write(obj.dateCloture)
      ..writeByte(199)
      ..write(obj.userAuthor)
      ..writeByte(201)
      ..write(obj.userCreation)
      ..writeByte(203)
      ..write(obj.userCreationId)
      ..writeByte(205)
      ..write(obj.userValid)
      ..writeByte(207)
      ..write(obj.userValidation)
      ..writeByte(209)
      ..write(obj.userValidationId)
      ..writeByte(211)
      ..write(obj.userClosingId)
      ..writeByte(213)
      ..write(obj.userModification)
      ..writeByte(215)
      ..write(obj.userModificationId)
      ..writeByte(217)
      ..write(obj.specimen)
      ..writeByte(219)
      ..write(obj.labelStatus)
      ..writeByte(221)
      ..write(obj.showphotoOnPopup)
      ..writeByte(223)
      ..write(obj.nb)
      ..writeByte(225)
      ..write(obj.output)
      ..writeByte(227)
      ..write(obj.extraparams)
      ..writeByte(229)
      ..write(obj.address)
      ..writeByte(231)
      ..write(obj.zip)
      ..writeByte(233)
      ..write(obj.town);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String?,
      statut: json['statut'] as String?,
      employee: json['employee'] as String?,
      civilityCode: json['civility_code'] as String?,
      fullname: json['fullname'],
      gender: json['gender'],
      birth: json['birth'] as String?,
      email: json['email'] as String?,
      personalEmail: json['personal_email'] as String?,
      socialnetworks: json['socialnetworks'] as List<dynamic>?,
      job: json['job'] as String?,
      signature: json['signature'] as String?,
      officePhone: json['office_phone'] as String?,
      officeFax: json['office_fax'] as String?,
      userMobile: json['user_mobile'] as String?,
      personalMobile: json['personal_mobile'] as String?,
      admin: json['admin'] as String?,
      login: json['login'] as String?,
      entity: json['entity'] as String?,
      datec: (json['datec'] as num?)?.toInt(),
      datem: (json['datem'] as num?)?.toInt(),
      socid: json['socid'],
      contactId: json['contact_id'],
      fkMember: json['fk_member'],
      fkUser: json['fk_user'],
      fkUserExpenseValidator: json['fk_user_expense_validator'],
      fkUserHolidayValidator: json['fk_user_holiday_validator'],
      clicktodialUrl: json['clicktodial_url'],
      clicktodialLogin: json['clicktodial_login'],
      clicktodialPoste: json['clicktodial_poste'],
      datelastlogin: (json['datelastlogin'] as num?)?.toInt(),
      datepreviouslogin: (json['datepreviouslogin'] as num?)?.toInt(),
      flagdelsessionsbefore: (json['flagdelsessionsbefore'] as num?)?.toInt(),
      iplastlogin: json['iplastlogin'] as String?,
      ippreviouslogin: json['ippreviouslogin'] as String?,
      datestartvalidity: json['datestartvalidity'] as String?,
      dateendvalidity: json['dateendvalidity'] as String?,
      photo: json['photo'],
      lang: json['lang'],
      userGroupList: json['user_group_list'] as List<dynamic>?,
      users: json['users'] as List<dynamic>?,
      parentof: json['parentof'],
      accountancyCode: json['accountancy_code'] as String?,
      thm: json['thm'],
      tjm: json['tjm'],
      salary: json['salary'],
      salaryextra: json['salaryextra'],
      weeklyhours: json['weeklyhours'],
      color: json['color'] as String?,
      dateemployment: json['dateemployment'] as String?,
      dateemploymentend: json['dateemploymentend'] as String?,
      defaultCExpTaxCat: json['default_c_exp_tax_cat'],
      refEmployee: json['ref_employee'] as String?,
      nationalRegistrationNumber:
          json['national_registration_number'] as String?,
      defaultRange: json['default_range'],
      fkWarehouse: json['fk_warehouse'],
      module: json['module'],
      importKey: json['import_key'],
      arrayOptions: json['array_options'] as List<dynamic>?,
      arrayLanguages: json['array_languages'],
      contactsIds: json['contacts_ids'],
      linkedObjects: json['linked_objects'],
      linkedObjectsIds: json['linkedObjectsIds'],
      oldref: json['oldref'],
      canvas: json['canvas'],
      fkProject: json['fk_project'],
      user: json['user'],
      origin: json['origin'],
      originId: json['origin_id'],
      ref: json['ref'] as String?,
      refExt: json['ref_ext'],
      status: json['status'] as String?,
      countryId: json['country_id'],
      countryCode: json['country_code'] as String?,
      stateId: json['state_id'] as String?,
      regionId: json['region_id'],
      barcodeType: json['barcode_type'],
      barcodeTypeCoder: json['barcode_type_coder'],
      modeReglementId: json['mode_reglement_id'],
      condReglementId: json['cond_reglement_id'],
      demandReasonId: json['demand_reason_id'],
      transportModeId: json['transport_mode_id'],
      shippingMethod: json['shipping_method'],
      multicurrencyCode: json['multicurrency_code'],
      multicurrencyTx: json['multicurrency_tx'],
      lastMainDoc: json['last_main_doc'],
      fkBank: json['fk_bank'],
      fkAccount: json['fk_account'],
      notePublic: json['note_public'] as String?,
      notePrivate: json['note_private'] as String?,
      name: json['name'],
      lastname: json['lastname'] as String?,
      firstname: json['firstname'] as String?,
      civilityId: json['civility_id'],
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
      specimen: (json['specimen'] as num?)?.toInt(),
      labelStatus: json['labelStatus'],
      showphotoOnPopup: json['showphoto_on_popup'],
      nb: json['nb'] as List<dynamic>?,
      output: json['output'],
      extraparams: json['extraparams'] as List<dynamic>?,
      address: json['address'] as String?,
      zip: json['zip'] as String?,
      town: json['town'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'statut': instance.statut,
      'employee': instance.employee,
      'civility_code': instance.civilityCode,
      'fullname': instance.fullname,
      'gender': instance.gender,
      'birth': instance.birth,
      'email': instance.email,
      'personal_email': instance.personalEmail,
      'socialnetworks': instance.socialnetworks,
      'job': instance.job,
      'signature': instance.signature,
      'office_phone': instance.officePhone,
      'office_fax': instance.officeFax,
      'user_mobile': instance.userMobile,
      'personal_mobile': instance.personalMobile,
      'admin': instance.admin,
      'login': instance.login,
      'entity': instance.entity,
      'datec': instance.datec,
      'datem': instance.datem,
      'socid': instance.socid,
      'contact_id': instance.contactId,
      'fk_member': instance.fkMember,
      'fk_user': instance.fkUser,
      'fk_user_expense_validator': instance.fkUserExpenseValidator,
      'fk_user_holiday_validator': instance.fkUserHolidayValidator,
      'clicktodial_url': instance.clicktodialUrl,
      'clicktodial_login': instance.clicktodialLogin,
      'clicktodial_poste': instance.clicktodialPoste,
      'datelastlogin': instance.datelastlogin,
      'datepreviouslogin': instance.datepreviouslogin,
      'flagdelsessionsbefore': instance.flagdelsessionsbefore,
      'iplastlogin': instance.iplastlogin,
      'ippreviouslogin': instance.ippreviouslogin,
      'datestartvalidity': instance.datestartvalidity,
      'dateendvalidity': instance.dateendvalidity,
      'photo': instance.photo,
      'lang': instance.lang,
      'user_group_list': instance.userGroupList,
      'users': instance.users,
      'parentof': instance.parentof,
      'accountancy_code': instance.accountancyCode,
      'thm': instance.thm,
      'tjm': instance.tjm,
      'salary': instance.salary,
      'salaryextra': instance.salaryextra,
      'weeklyhours': instance.weeklyhours,
      'color': instance.color,
      'dateemployment': instance.dateemployment,
      'dateemploymentend': instance.dateemploymentend,
      'default_c_exp_tax_cat': instance.defaultCExpTaxCat,
      'ref_employee': instance.refEmployee,
      'national_registration_number': instance.nationalRegistrationNumber,
      'default_range': instance.defaultRange,
      'fk_warehouse': instance.fkWarehouse,
      'module': instance.module,
      'import_key': instance.importKey,
      'array_options': instance.arrayOptions,
      'array_languages': instance.arrayLanguages,
      'contacts_ids': instance.contactsIds,
      'linked_objects': instance.linkedObjects,
      'linkedObjectsIds': instance.linkedObjectsIds,
      'oldref': instance.oldref,
      'canvas': instance.canvas,
      'fk_project': instance.fkProject,
      'user': instance.user,
      'origin': instance.origin,
      'origin_id': instance.originId,
      'ref': instance.ref,
      'ref_ext': instance.refExt,
      'status': instance.status,
      'country_id': instance.countryId,
      'country_code': instance.countryCode,
      'state_id': instance.stateId,
      'region_id': instance.regionId,
      'barcode_type': instance.barcodeType,
      'barcode_type_coder': instance.barcodeTypeCoder,
      'mode_reglement_id': instance.modeReglementId,
      'cond_reglement_id': instance.condReglementId,
      'demand_reason_id': instance.demandReasonId,
      'transport_mode_id': instance.transportModeId,
      'shipping_method': instance.shippingMethod,
      'multicurrency_code': instance.multicurrencyCode,
      'multicurrency_tx': instance.multicurrencyTx,
      'last_main_doc': instance.lastMainDoc,
      'fk_bank': instance.fkBank,
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
      'address': instance.address,
      'zip': instance.zip,
      'town': instance.town,
    };
