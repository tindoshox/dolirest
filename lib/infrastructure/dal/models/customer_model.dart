// To parse this JSON data, do
//
//     final thirdPartyModel = thirdPartyModelFromJson(jsonString);

import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

part 'customer_model.g.dart';

CustomerModel customerModelFromJson(String str) =>
    CustomerModel.fromJson(json.decode(str));
List<CustomerModel> customerModelFromMap(String str) =>
    List<CustomerModel>.from(
        json.decode(str).map((x) => CustomerModel.fromMap(x)));

String customerModelToJson(CustomerModel data) => json.encode(data.toJson());
String customerModelToMap(List<CustomerModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

@HiveType(typeId: 3)
class CustomerModel {
  @HiveField(1)
  dynamic module;
  @HiveField(2)
  List<dynamic>? supplierCategories;
  @HiveField(3)
  dynamic prefixCustomerIsRequired;
  @HiveField(4)
  dynamic entity;
  @HiveField(5)
  dynamic name;
  @HiveField(6)
  dynamic nameAlias;
  @HiveField(7)
  dynamic status;
  @HiveField(8)
  dynamic phone;
  @HiveField(9)
  dynamic fax;
  @HiveField(10)
  dynamic email;
  @HiveField(11)
  dynamic noEmail;
  @HiveField(12)
  dynamic skype;
  @HiveField(13)
  dynamic twitter;
  @HiveField(14)
  dynamic facebook;
  @HiveField(15)
  dynamic linkedin;
  @HiveField(16)
  dynamic url;
  @HiveField(17)
  dynamic barcode;
  @HiveField(18)
  dynamic idprof1;
  @HiveField(19)
  dynamic idprof2;
  @HiveField(20)
  dynamic idprof3;
  @HiveField(21)
  dynamic idprof4;
  @HiveField(22)
  dynamic idprof5;
  @HiveField(23)
  dynamic idprof6;
  @HiveField(24)
  dynamic socialobject;
  @HiveField(25)
  dynamic tvaAssuj;
  @HiveField(26)
  dynamic tvaIntra;
  @HiveField(27)
  dynamic vatReverseCharge;
  @HiveField(28)
  dynamic localtax1Assuj;
  @HiveField(29)
  dynamic localtax1Value;
  @HiveField(30)
  dynamic localtax2Assuj;
  @HiveField(31)
  dynamic localtax2Value;
  @HiveField(32)
  dynamic managers;
  @HiveField(33)
  dynamic capital;
  @HiveField(34)
  dynamic typentId;
  @HiveField(35)
  dynamic typentCode;
  @HiveField(36)
  dynamic effectif;
  @HiveField(37)
  dynamic effectifId;
  @HiveField(38)
  dynamic formeJuridiqueCode;
  @HiveField(39)
  dynamic formeJuridique;
  @HiveField(40)
  dynamic remisePercent;
  @HiveField(41)
  dynamic remiseSupplierPercent;
  @HiveField(42)
  dynamic modeReglementId;
  @HiveField(43)
  dynamic condReglementId;
  @HiveField(44)
  dynamic depositPercent;
  @HiveField(45)
  dynamic modeReglementSupplierId;
  @HiveField(46)
  dynamic condReglementSupplierId;
  @HiveField(47)
  dynamic transportModeSupplierId;
  @HiveField(48)
  dynamic fkProspectlevel;
  @HiveField(49)
  dynamic dateModification;
  @HiveField(50)
  dynamic userModification;
  @HiveField(51)
  dynamic dateCreation;
  @HiveField(52)
  dynamic userCreation;
  @HiveField(53)
  dynamic client;
  @HiveField(54)
  dynamic prospect;
  @HiveField(55)
  dynamic fournisseur;
  @HiveField(56)
  dynamic codeClient;
  @HiveField(57)
  dynamic codeFournisseur;
  @HiveField(58)
  dynamic codeComptaClient;
  @HiveField(59)
  dynamic codeCompta;
  @HiveField(60)
  dynamic accountancyCodeCustomer;
  @HiveField(61)
  dynamic codeComptaFournisseur;
  @HiveField(62)
  dynamic accountancyCodeSupplier;
  @HiveField(63)
  dynamic codeComptaProduct;
  @HiveField(64)
  dynamic notePrivate;
  @HiveField(65)
  dynamic notePublic;
  @HiveField(66)
  dynamic stcommId;
  @HiveField(67)
  dynamic stcommPicto;
  @HiveField(68)
  dynamic statusProspectLabel;
  @HiveField(69)
  dynamic priceLevel;
  @HiveField(70)
  dynamic outstandingLimit;
  @HiveField(71)
  dynamic orderMinAmount;
  @HiveField(72)
  dynamic supplierOrderMinAmount;
  @HiveField(73)
  dynamic parent;
  @HiveField(74)
  dynamic defaultLang;
  @HiveField(75)
  dynamic ref;
  @HiveField(76)
  dynamic refExt;
  @HiveField(77)
  dynamic importKey;
  @HiveField(78)
  dynamic webservicesUrl;
  @HiveField(79)
  dynamic webservicesKey;
  @HiveField(80)
  dynamic logo;
  @HiveField(81)
  dynamic logoSmall;
  @HiveField(82)
  dynamic logoMini;
  @HiveField(83)
  dynamic logoSquarred;
  @HiveField(84)
  dynamic logoSquarredSmall;
  @HiveField(85)
  dynamic logoSquarredMini;
  @HiveField(86)
  dynamic accountancyCodeSell;
  @HiveField(87)
  dynamic accountancyCodeBuy;
  @HiveField(88)
  dynamic fkMulticurrency;
  @HiveField(89)
  dynamic fkWarehouse;
  @HiveField(90)
  dynamic multicurrencyCode;
  @HiveField(91)
  List<dynamic>? partnerships;
  @HiveField(92)
  dynamic bankAccount;
  @HiveField(93)
  dynamic id;
  @HiveField(94)
  List<dynamic>? arrayOptions;
  @HiveField(95)
  dynamic arrayLanguages;
  @HiveField(96)
  dynamic contactsIds;
  @HiveField(97)
  dynamic linkedObjects;
  @HiveField(98)
  dynamic linkedObjectsIds;
  @HiveField(99)
  dynamic oldref;
  @HiveField(100)
  dynamic canvas;
  @HiveField(101)
  dynamic fkProject;
  @HiveField(102)
  dynamic contactId;
  @HiveField(103)
  dynamic user;
  @HiveField(104)
  dynamic origin;
  @HiveField(105)
  dynamic originId;
  @HiveField(106)
  dynamic statut;
  @HiveField(107)
  dynamic countryId;
  @HiveField(108)
  dynamic countryCode;
  @HiveField(109)
  dynamic stateId;
  @HiveField(110)
  dynamic regionId;
  @HiveField(111)
  dynamic barcodeType;
  @HiveField(112)
  dynamic barcodeTypeCoder;
  @HiveField(113)
  dynamic demandReasonId;
  @HiveField(114)
  dynamic transportModeId;
  @HiveField(115)
  dynamic shippingMethodId;
  @HiveField(116)
  dynamic shippingMethod;
  @HiveField(117)
  dynamic multicurrencyTx;
  @HiveField(118)
  dynamic modelPdf;
  @HiveField(119)
  dynamic lastMainDoc;
  @HiveField(120)
  dynamic fkBank;
  @HiveField(121)
  dynamic fkAccount;
  @HiveField(122)
  dynamic lastname;
  @HiveField(123)
  dynamic firstname;
  @HiveField(124)
  dynamic civilityId;
  @HiveField(125)
  dynamic dateValidation;
  @HiveField(126)
  dynamic dateUpdate;
  @HiveField(127)
  dynamic dateCloture;
  @HiveField(128)
  dynamic userAuthor;
  @HiveField(129)
  dynamic userCreationId;
  @HiveField(130)
  dynamic userValid;
  @HiveField(131)
  dynamic userValidation;
  @HiveField(132)
  dynamic userValidationId;
  @HiveField(133)
  dynamic userClosingId;
  @HiveField(134)
  dynamic userModificationId;
  @HiveField(135)
  dynamic specimen;
  @HiveField(136)
  dynamic labelStatus;
  @HiveField(137)
  dynamic showphotoOnPopup;
  @HiveField(138)
  List<dynamic>? nb;
  @HiveField(139)
  dynamic output;
  @HiveField(140)
  List<dynamic>? extraparams;
  @HiveField(141)
  dynamic fkIncoterms;
  @HiveField(142)
  dynamic labelIncoterms;
  @HiveField(143)
  dynamic locationIncoterms;
  @HiveField(144)
  List<dynamic>? socialnetworks;
  @HiveField(145)
  dynamic address;
  @HiveField(146)
  dynamic zip;
  @HiveField(147)
  dynamic town;

  CustomerModel({
    this.module,
    this.supplierCategories,
    this.prefixCustomerIsRequired,
    this.entity,
    this.name,
    this.nameAlias,
    this.status,
    this.phone,
    this.fax,
    this.email,
    this.noEmail,
    this.skype,
    this.twitter,
    this.facebook,
    this.linkedin,
    this.url,
    this.barcode,
    this.idprof1,
    this.idprof2,
    this.idprof3,
    this.idprof4,
    this.idprof5,
    this.idprof6,
    this.socialobject,
    this.tvaAssuj,
    this.tvaIntra,
    this.vatReverseCharge,
    this.localtax1Assuj,
    this.localtax1Value,
    this.localtax2Assuj,
    this.localtax2Value,
    this.managers,
    this.capital,
    this.typentId,
    this.typentCode,
    this.effectif,
    this.effectifId,
    this.formeJuridiqueCode,
    this.formeJuridique,
    this.remisePercent,
    this.remiseSupplierPercent,
    this.modeReglementId,
    this.condReglementId,
    this.depositPercent,
    this.modeReglementSupplierId,
    this.condReglementSupplierId,
    this.transportModeSupplierId,
    this.fkProspectlevel,
    this.dateModification,
    this.userModification,
    this.dateCreation,
    this.userCreation,
    this.client,
    this.prospect,
    this.fournisseur,
    this.codeClient,
    this.codeFournisseur,
    this.codeComptaClient,
    this.codeCompta,
    this.accountancyCodeCustomer,
    this.codeComptaFournisseur,
    this.accountancyCodeSupplier,
    this.codeComptaProduct,
    this.notePrivate,
    this.notePublic,
    this.stcommId,
    this.stcommPicto,
    this.statusProspectLabel,
    this.priceLevel,
    this.outstandingLimit,
    this.orderMinAmount,
    this.supplierOrderMinAmount,
    this.parent,
    this.defaultLang,
    this.ref,
    this.refExt,
    this.importKey,
    this.webservicesUrl,
    this.webservicesKey,
    this.logo,
    this.logoSmall,
    this.logoMini,
    this.logoSquarred,
    this.logoSquarredSmall,
    this.logoSquarredMini,
    this.accountancyCodeSell,
    this.accountancyCodeBuy,
    this.fkMulticurrency,
    this.fkWarehouse,
    this.multicurrencyCode,
    this.partnerships,
    this.bankAccount,
    this.id,
    this.arrayOptions,
    this.arrayLanguages,
    this.contactsIds,
    this.linkedObjects,
    this.linkedObjectsIds,
    this.oldref,
    this.canvas,
    this.fkProject,
    this.contactId,
    this.user,
    this.origin,
    this.originId,
    this.statut,
    this.countryId,
    this.countryCode,
    this.stateId,
    this.regionId,
    this.barcodeType,
    this.barcodeTypeCoder,
    this.demandReasonId,
    this.transportModeId,
    this.shippingMethodId,
    this.shippingMethod,
    this.multicurrencyTx,
    this.modelPdf,
    this.lastMainDoc,
    this.fkBank,
    this.fkAccount,
    this.lastname,
    this.firstname,
    this.civilityId,
    this.dateValidation,
    this.dateUpdate,
    this.dateCloture,
    this.userAuthor,
    this.userCreationId,
    this.userValid,
    this.userValidation,
    this.userValidationId,
    this.userClosingId,
    this.userModificationId,
    this.specimen,
    this.labelStatus,
    this.showphotoOnPopup,
    this.nb,
    this.output,
    this.extraparams,
    this.fkIncoterms,
    this.labelIncoterms,
    this.locationIncoterms,
    this.socialnetworks,
    this.address,
    this.zip,
    this.town,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        module: json["module"],
        supplierCategories: json["SupplierCategories"] == null
            ? []
            : List<dynamic>.from(json["SupplierCategories"]!.map((x) => x)),
        prefixCustomerIsRequired: json["prefixCustomerIsRequired"],
        entity: json["entity"],
        name: json["name"],
        nameAlias: json["name_alias"],
        status: json["status"],
        phone: json["phone"],
        fax: json["fax"],
        email: json["email"],
        noEmail: json["no_email"],
        skype: json["skype"],
        twitter: json["twitter"],
        facebook: json["facebook"],
        linkedin: json["linkedin"],
        url: json["url"],
        barcode: json["barcode"],
        idprof1: json["idprof1"],
        idprof2: json["idprof2"],
        idprof3: json["idprof3"],
        idprof4: json["idprof4"],
        idprof5: json["idprof5"],
        idprof6: json["idprof6"],
        socialobject: json["socialobject"],
        tvaAssuj: json["tva_assuj"],
        tvaIntra: json["tva_intra"],
        vatReverseCharge: json["vat_reverse_charge"],
        localtax1Assuj: json["localtax1_assuj"],
        localtax1Value: json["localtax1_value"],
        localtax2Assuj: json["localtax2_assuj"],
        localtax2Value: json["localtax2_value"],
        managers: json["managers"],
        capital: json["capital"],
        typentId: json["typent_id"],
        typentCode: json["typent_code"],
        effectif: json["effectif"],
        effectifId: json["effectif_id"],
        formeJuridiqueCode: json["forme_juridique_code"],
        formeJuridique: json["forme_juridique"],
        remisePercent: json["remise_percent"],
        remiseSupplierPercent: json["remise_supplier_percent"],
        modeReglementId: json["mode_reglement_id"],
        condReglementId: json["cond_reglement_id"],
        depositPercent: json["deposit_percent"],
        modeReglementSupplierId: json["mode_reglement_supplier_id"],
        condReglementSupplierId: json["cond_reglement_supplier_id"],
        transportModeSupplierId: json["transport_mode_supplier_id"],
        fkProspectlevel: json["fk_prospectlevel"],
        dateModification: json["date_modification"],
        userModification: json["user_modification"],
        dateCreation: json["date_creation"],
        userCreation: json["user_creation"],
        client: json["client"],
        prospect: json["prospect"],
        fournisseur: json["fournisseur"],
        codeClient: json["code_client"],
        codeFournisseur: json["code_fournisseur"],
        codeComptaClient: json["code_compta_client"],
        codeCompta: json["code_compta"],
        accountancyCodeCustomer: json["accountancy_code_customer"],
        codeComptaFournisseur: json["code_compta_fournisseur"],
        accountancyCodeSupplier: json["accountancy_code_supplier"],
        codeComptaProduct: json["code_compta_product"],
        notePrivate: json["note_private"],
        notePublic: json["note_public"],
        stcommId: json["stcomm_id"],
        stcommPicto: json["stcomm_picto"],
        statusProspectLabel: json["status_prospect_label"],
        priceLevel: json["price_level"],
        outstandingLimit: json["outstanding_limit"],
        orderMinAmount: json["order_min_amount"],
        supplierOrderMinAmount: json["supplier_order_min_amount"],
        parent: json["parent"],
        defaultLang: json["default_lang"],
        ref: json["ref"],
        refExt: json["ref_ext"],
        importKey: json["import_key"],
        webservicesUrl: json["webservices_url"],
        webservicesKey: json["webservices_key"],
        logo: json["logo"],
        logoSmall: json["logo_small"],
        logoMini: json["logo_mini"],
        logoSquarred: json["logo_squarred"],
        logoSquarredSmall: json["logo_squarred_small"],
        logoSquarredMini: json["logo_squarred_mini"],
        accountancyCodeSell: json["accountancy_code_sell"],
        accountancyCodeBuy: json["accountancy_code_buy"],
        fkMulticurrency: json["fk_multicurrency"],
        fkWarehouse: json["fk_warehouse"],
        multicurrencyCode: json["multicurrency_code"],
        partnerships: json["partnerships"] == null
            ? []
            : List<dynamic>.from(json["partnerships"]!.map((x) => x)),
        bankAccount: json["bank_account"],
        id: json["id"],
        arrayOptions: json["array_options"] == null
            ? []
            : List<dynamic>.from(json["array_options"]!.map((x) => x)),
        arrayLanguages: json["array_languages"],
        contactsIds: json["contacts_ids"],
        linkedObjects: json["linked_objects"],
        linkedObjectsIds: json["linkedObjectsIds"],
        oldref: json["oldref"],
        canvas: json["canvas"],
        fkProject: json["fk_project"],
        contactId: json["contact_id"],
        user: json["user"],
        origin: json["origin"],
        originId: json["origin_id"],
        statut: json["statut"],
        countryId: json["country_id"],
        countryCode: json["country_code"],
        stateId: json["state_id"],
        regionId: json["region_id"],
        barcodeType: json["barcode_type"],
        barcodeTypeCoder: json["barcode_type_coder"],
        demandReasonId: json["demand_reason_id"],
        transportModeId: json["transport_mode_id"],
        shippingMethodId: json["shipping_method_id"],
        shippingMethod: json["shipping_method"],
        multicurrencyTx: json["multicurrency_tx"],
        modelPdf: json["model_pdf"],
        lastMainDoc: json["last_main_doc"],
        fkBank: json["fk_bank"],
        fkAccount: json["fk_account"],
        lastname: json["lastname"],
        firstname: json["firstname"],
        civilityId: json["civility_id"],
        dateValidation: json["date_validation"],
        dateUpdate: json["date_update"],
        dateCloture: json["date_cloture"],
        userAuthor: json["user_author"],
        userCreationId: json["user_creation_id"],
        userValid: json["user_valid"],
        userValidation: json["user_validation"],
        userValidationId: json["user_validation_id"],
        userClosingId: json["user_closing_id"],
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
        fkIncoterms: json["fk_incoterms"],
        labelIncoterms: json["label_incoterms"],
        locationIncoterms: json["location_incoterms"],
        socialnetworks: json["socialnetworks"] == null
            ? []
            : List<dynamic>.from(json["socialnetworks"]!.map((x) => x)),
        address: json["address"],
        zip: json["zip"],
        town: json["town"],
      );

  Map<String, dynamic> toJson() => {
        "module": module,
        "SupplierCategories": supplierCategories == null
            ? []
            : List<dynamic>.from(supplierCategories!.map((x) => x)),
        "prefixCustomerIsRequired": prefixCustomerIsRequired,
        "entity": entity,
        "name": name,
        "name_alias": nameAlias,
        "status": status,
        "phone": phone,
        "fax": fax,
        "email": email,
        "no_email": noEmail,
        "skype": skype,
        "twitter": twitter,
        "facebook": facebook,
        "linkedin": linkedin,
        "url": url,
        "barcode": barcode,
        "idprof1": idprof1,
        "idprof2": idprof2,
        "idprof3": idprof3,
        "idprof4": idprof4,
        "idprof5": idprof5,
        "idprof6": idprof6,
        "socialobject": socialobject,
        "tva_assuj": tvaAssuj,
        "tva_intra": tvaIntra,
        "vat_reverse_charge": vatReverseCharge,
        "localtax1_assuj": localtax1Assuj,
        "localtax1_value": localtax1Value,
        "localtax2_assuj": localtax2Assuj,
        "localtax2_value": localtax2Value,
        "managers": managers,
        "capital": capital,
        "typent_id": typentId,
        "typent_code": typentCode,
        "effectif": effectif,
        "effectif_id": effectifId,
        "forme_juridique_code": formeJuridiqueCode,
        "forme_juridique": formeJuridique,
        "remise_percent": remisePercent,
        "remise_supplier_percent": remiseSupplierPercent,
        "mode_reglement_id": modeReglementId,
        "cond_reglement_id": condReglementId,
        "deposit_percent": depositPercent,
        "mode_reglement_supplier_id": modeReglementSupplierId,
        "cond_reglement_supplier_id": condReglementSupplierId,
        "transport_mode_supplier_id": transportModeSupplierId,
        "fk_prospectlevel": fkProspectlevel,
        "date_modification": dateModification,
        "user_modification": userModification,
        "date_creation": dateCreation,
        "user_creation": userCreation,
        "client": client,
        "prospect": prospect,
        "fournisseur": fournisseur,
        "code_client": codeClient,
        "code_fournisseur": codeFournisseur,
        "code_compta_client": codeComptaClient,
        "code_compta": codeCompta,
        "accountancy_code_customer": accountancyCodeCustomer,
        "code_compta_fournisseur": codeComptaFournisseur,
        "accountancy_code_supplier": accountancyCodeSupplier,
        "code_compta_product": codeComptaProduct,
        "note_private": notePrivate,
        "note_public": notePublic,
        "stcomm_id": stcommId,
        "stcomm_picto": stcommPicto,
        "status_prospect_label": statusProspectLabel,
        "price_level": priceLevel,
        "outstanding_limit": outstandingLimit,
        "order_min_amount": orderMinAmount,
        "supplier_order_min_amount": supplierOrderMinAmount,
        "parent": parent,
        "default_lang": defaultLang,
        "ref": ref,
        "ref_ext": refExt,
        "import_key": importKey,
        "webservices_url": webservicesUrl,
        "webservices_key": webservicesKey,
        "logo": logo,
        "logo_small": logoSmall,
        "logo_mini": logoMini,
        "logo_squarred": logoSquarred,
        "logo_squarred_small": logoSquarredSmall,
        "logo_squarred_mini": logoSquarredMini,
        "accountancy_code_sell": accountancyCodeSell,
        "accountancy_code_buy": accountancyCodeBuy,
        "fk_multicurrency": fkMulticurrency,
        "fk_warehouse": fkWarehouse,
        "multicurrency_code": multicurrencyCode,
        "partnerships": partnerships == null
            ? []
            : List<dynamic>.from(partnerships!.map((x) => x)),
        "bank_account": bankAccount,
        "id": id,
        "array_options": arrayOptions == null
            ? []
            : List<dynamic>.from(arrayOptions!.map((x) => x)),
        "array_languages": arrayLanguages,
        "contacts_ids": contactsIds,
        "linked_objects": linkedObjects,
        "linkedObjectsIds": linkedObjectsIds,
        "oldref": oldref,
        "canvas": canvas,
        "fk_project": fkProject,
        "contact_id": contactId,
        "user": user,
        "origin": origin,
        "origin_id": originId,
        "statut": statut,
        "country_id": countryId,
        "country_code": countryCode,
        "state_id": stateId,
        "region_id": regionId,
        "barcode_type": barcodeType,
        "barcode_type_coder": barcodeTypeCoder,
        "demand_reason_id": demandReasonId,
        "transport_mode_id": transportModeId,
        "shipping_method_id": shippingMethodId,
        "shipping_method": shippingMethod,
        "multicurrency_tx": multicurrencyTx,
        "model_pdf": modelPdf,
        "last_main_doc": lastMainDoc,
        "fk_bank": fkBank,
        "fk_account": fkAccount,
        "lastname": lastname,
        "firstname": firstname,
        "civility_id": civilityId,
        "date_validation": dateValidation,
        "date_update": dateUpdate,
        "date_cloture": dateCloture,
        "user_author": userAuthor,
        "user_creation_id": userCreationId,
        "user_valid": userValid,
        "user_validation": userValidation,
        "user_validation_id": userValidationId,
        "user_closing_id": userClosingId,
        "user_modification_id": userModificationId,
        "specimen": specimen,
        "labelStatus": labelStatus,
        "showphoto_on_popup": showphotoOnPopup,
        "nb": nb == null ? [] : List<dynamic>.from(nb!.map((x) => x)),
        "output": output,
        "extraparams": extraparams == null
            ? []
            : List<dynamic>.from(extraparams!.map((x) => x)),
        "fk_incoterms": fkIncoterms,
        "label_incoterms": labelIncoterms,
        "location_incoterms": locationIncoterms,
        "socialnetworks": socialnetworks == null
            ? []
            : List<dynamic>.from(socialnetworks!.map((x) => x)),
        "address": address,
        "zip": zip,
        "town": town,
      };

  factory CustomerModel.fromMap(Map<String, dynamic> json) => CustomerModel(
        module: json["module"],
        supplierCategories: json["SupplierCategories"] == null
            ? []
            : List<dynamic>.from(json["SupplierCategories"]!.map((x) => x)),
        prefixCustomerIsRequired: json["prefixCustomerIsRequired"],
        entity: json["entity"],
        name: json["name"],
        nameAlias: json["name_alias"],
        status: json["status"],
        phone: json["phone"],
        fax: json["fax"],
        email: json["email"],
        noEmail: json["no_email"],
        skype: json["skype"],
        twitter: json["twitter"],
        facebook: json["facebook"],
        linkedin: json["linkedin"],
        url: json["url"],
        barcode: json["barcode"],
        idprof1: json["idprof1"],
        idprof2: json["idprof2"],
        idprof3: json["idprof3"],
        idprof4: json["idprof4"],
        idprof5: json["idprof5"],
        idprof6: json["idprof6"],
        socialobject: json["socialobject"],
        tvaAssuj: json["tva_assuj"],
        tvaIntra: json["tva_intra"],
        vatReverseCharge: json["vat_reverse_charge"],
        localtax1Assuj: json["localtax1_assuj"],
        localtax1Value: json["localtax1_value"],
        localtax2Assuj: json["localtax2_assuj"],
        localtax2Value: json["localtax2_value"],
        managers: json["managers"],
        capital: json["capital"],
        typentId: json["typent_id"],
        typentCode: json["typent_code"],
        effectif: json["effectif"],
        effectifId: json["effectif_id"],
        formeJuridiqueCode: json["forme_juridique_code"],
        formeJuridique: json["forme_juridique"],
        remisePercent: json["remise_percent"],
        remiseSupplierPercent: json["remise_supplier_percent"],
        modeReglementId: json["mode_reglement_id"],
        condReglementId: json["cond_reglement_id"],
        depositPercent: json["deposit_percent"],
        modeReglementSupplierId: json["mode_reglement_supplier_id"],
        condReglementSupplierId: json["cond_reglement_supplier_id"],
        transportModeSupplierId: json["transport_mode_supplier_id"],
        fkProspectlevel: json["fk_prospectlevel"],
        dateModification: json["date_modification"],
        userModification: json["user_modification"],
        dateCreation: json["date_creation"],
        userCreation: json["user_creation"],
        client: json["client"],
        prospect: json["prospect"],
        fournisseur: json["fournisseur"],
        codeClient: json["code_client"],
        codeFournisseur: json["code_fournisseur"],
        codeComptaClient: json["code_compta_client"],
        codeCompta: json["code_compta"],
        accountancyCodeCustomer: json["accountancy_code_customer"],
        codeComptaFournisseur: json["code_compta_fournisseur"],
        accountancyCodeSupplier: json["accountancy_code_supplier"],
        codeComptaProduct: json["code_compta_product"],
        notePrivate: json["note_private"],
        notePublic: json["note_public"],
        stcommId: json["stcomm_id"],
        stcommPicto: json["stcomm_picto"],
        statusProspectLabel: json["status_prospect_label"],
        priceLevel: json["price_level"],
        outstandingLimit: json["outstanding_limit"],
        orderMinAmount: json["order_min_amount"],
        supplierOrderMinAmount: json["supplier_order_min_amount"],
        parent: json["parent"],
        defaultLang: json["default_lang"],
        ref: json["ref"],
        refExt: json["ref_ext"],
        importKey: json["import_key"],
        webservicesUrl: json["webservices_url"],
        webservicesKey: json["webservices_key"],
        logo: json["logo"],
        logoSmall: json["logo_small"],
        logoMini: json["logo_mini"],
        logoSquarred: json["logo_squarred"],
        logoSquarredSmall: json["logo_squarred_small"],
        logoSquarredMini: json["logo_squarred_mini"],
        accountancyCodeSell: json["accountancy_code_sell"],
        accountancyCodeBuy: json["accountancy_code_buy"],
        fkMulticurrency: json["fk_multicurrency"],
        fkWarehouse: json["fk_warehouse"],
        multicurrencyCode: json["multicurrency_code"],
        partnerships: json["partnerships"] == null
            ? []
            : List<dynamic>.from(json["partnerships"]!.map((x) => x)),
        bankAccount: json["bank_account"],
        id: json["id"],
        arrayOptions: json["array_options"] == null
            ? []
            : List<dynamic>.from(json["array_options"]!.map((x) => x)),
        arrayLanguages: json["array_languages"],
        contactsIds: json["contacts_ids"],
        linkedObjects: json["linked_objects"],
        linkedObjectsIds: json["linkedObjectsIds"],
        oldref: json["oldref"],
        canvas: json["canvas"],
        fkProject: json["fk_project"],
        contactId: json["contact_id"],
        user: json["user"],
        origin: json["origin"],
        originId: json["origin_id"],
        statut: json["statut"],
        countryId: json["country_id"],
        countryCode: json["country_code"],
        stateId: json["state_id"],
        regionId: json["region_id"],
        barcodeType: json["barcode_type"],
        barcodeTypeCoder: json["barcode_type_coder"],
        demandReasonId: json["demand_reason_id"],
        transportModeId: json["transport_mode_id"],
        shippingMethodId: json["shipping_method_id"],
        shippingMethod: json["shipping_method"],
        multicurrencyTx: json["multicurrency_tx"],
        modelPdf: json["model_pdf"],
        lastMainDoc: json["last_main_doc"],
        fkBank: json["fk_bank"],
        fkAccount: json["fk_account"],
        lastname: json["lastname"],
        firstname: json["firstname"],
        civilityId: json["civility_id"],
        dateValidation: json["date_validation"],
        dateUpdate: json["date_update"],
        dateCloture: json["date_cloture"],
        userAuthor: json["user_author"],
        userCreationId: json["user_creation_id"],
        userValid: json["user_valid"],
        userValidation: json["user_validation"],
        userValidationId: json["user_validation_id"],
        userClosingId: json["user_closing_id"],
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
        fkIncoterms: json["fk_incoterms"],
        labelIncoterms: json["label_incoterms"],
        locationIncoterms: json["location_incoterms"],
        socialnetworks: json["socialnetworks"] == null
            ? []
            : List<dynamic>.from(json["socialnetworks"]!.map((x) => x)),
        address: json["address"],
        zip: json["zip"],
        town: json["town"],
      );

  Map<String, dynamic> toMap() => {
        "module": module,
        "SupplierCategories": supplierCategories == null
            ? []
            : List<dynamic>.from(supplierCategories!.map((x) => x)),
        "prefixCustomerIsRequired": prefixCustomerIsRequired,
        "entity": entity,
        "name": name,
        "name_alias": nameAlias,
        "status": status,
        "phone": phone,
        "fax": fax,
        "email": email,
        "no_email": noEmail,
        "skype": skype,
        "twitter": twitter,
        "facebook": facebook,
        "linkedin": linkedin,
        "url": url,
        "barcode": barcode,
        "idprof1": idprof1,
        "idprof2": idprof2,
        "idprof3": idprof3,
        "idprof4": idprof4,
        "idprof5": idprof5,
        "idprof6": idprof6,
        "socialobject": socialobject,
        "tva_assuj": tvaAssuj,
        "tva_intra": tvaIntra,
        "vat_reverse_charge": vatReverseCharge,
        "localtax1_assuj": localtax1Assuj,
        "localtax1_value": localtax1Value,
        "localtax2_assuj": localtax2Assuj,
        "localtax2_value": localtax2Value,
        "managers": managers,
        "capital": capital,
        "typent_id": typentId,
        "typent_code": typentCode,
        "effectif": effectif,
        "effectif_id": effectifId,
        "forme_juridique_code": formeJuridiqueCode,
        "forme_juridique": formeJuridique,
        "remise_percent": remisePercent,
        "remise_supplier_percent": remiseSupplierPercent,
        "mode_reglement_id": modeReglementId,
        "cond_reglement_id": condReglementId,
        "deposit_percent": depositPercent,
        "mode_reglement_supplier_id": modeReglementSupplierId,
        "cond_reglement_supplier_id": condReglementSupplierId,
        "transport_mode_supplier_id": transportModeSupplierId,
        "fk_prospectlevel": fkProspectlevel,
        "date_modification": dateModification,
        "user_modification": userModification,
        "date_creation": dateCreation,
        "user_creation": userCreation,
        "client": client,
        "prospect": prospect,
        "fournisseur": fournisseur,
        "code_client": codeClient,
        "code_fournisseur": codeFournisseur,
        "code_compta_client": codeComptaClient,
        "code_compta": codeCompta,
        "accountancy_code_customer": accountancyCodeCustomer,
        "code_compta_fournisseur": codeComptaFournisseur,
        "accountancy_code_supplier": accountancyCodeSupplier,
        "code_compta_product": codeComptaProduct,
        "note_private": notePrivate,
        "note_public": notePublic,
        "stcomm_id": stcommId,
        "stcomm_picto": stcommPicto,
        "status_prospect_label": statusProspectLabel,
        "price_level": priceLevel,
        "outstanding_limit": outstandingLimit,
        "order_min_amount": orderMinAmount,
        "supplier_order_min_amount": supplierOrderMinAmount,
        "parent": parent,
        "default_lang": defaultLang,
        "ref": ref,
        "ref_ext": refExt,
        "import_key": importKey,
        "webservices_url": webservicesUrl,
        "webservices_key": webservicesKey,
        "logo": logo,
        "logo_small": logoSmall,
        "logo_mini": logoMini,
        "logo_squarred": logoSquarred,
        "logo_squarred_small": logoSquarredSmall,
        "logo_squarred_mini": logoSquarredMini,
        "accountancy_code_sell": accountancyCodeSell,
        "accountancy_code_buy": accountancyCodeBuy,
        "fk_multicurrency": fkMulticurrency,
        "fk_warehouse": fkWarehouse,
        "multicurrency_code": multicurrencyCode,
        "partnerships": partnerships == null
            ? []
            : List<dynamic>.from(partnerships!.map((x) => x)),
        "bank_account": bankAccount,
        "id": id,
        "array_options": arrayOptions == null
            ? []
            : List<dynamic>.from(arrayOptions!.map((x) => x)),
        "array_languages": arrayLanguages,
        "contacts_ids": contactsIds,
        "linked_objects": linkedObjects,
        "linkedObjectsIds": linkedObjectsIds,
        "oldref": oldref,
        "canvas": canvas,
        "fk_project": fkProject,
        "contact_id": contactId,
        "user": user,
        "origin": origin,
        "origin_id": originId,
        "statut": statut,
        "country_id": countryId,
        "country_code": countryCode,
        "state_id": stateId,
        "region_id": regionId,
        "barcode_type": barcodeType,
        "barcode_type_coder": barcodeTypeCoder,
        "demand_reason_id": demandReasonId,
        "transport_mode_id": transportModeId,
        "shipping_method_id": shippingMethodId,
        "shipping_method": shippingMethod,
        "multicurrency_tx": multicurrencyTx,
        "model_pdf": modelPdf,
        "last_main_doc": lastMainDoc,
        "fk_bank": fkBank,
        "fk_account": fkAccount,
        "lastname": lastname,
        "firstname": firstname,
        "civility_id": civilityId,
        "date_validation": dateValidation,
        "date_update": dateUpdate,
        "date_cloture": dateCloture,
        "user_author": userAuthor,
        "user_creation_id": userCreationId,
        "user_valid": userValid,
        "user_validation": userValidation,
        "user_validation_id": userValidationId,
        "user_closing_id": userClosingId,
        "user_modification_id": userModificationId,
        "specimen": specimen,
        "labelStatus": labelStatus,
        "showphoto_on_popup": showphotoOnPopup,
        "nb": nb == null ? [] : List<dynamic>.from(nb!.map((x) => x)),
        "output": output,
        "extraparams": extraparams == null
            ? []
            : List<dynamic>.from(extraparams!.map((x) => x)),
        "fk_incoterms": fkIncoterms,
        "label_incoterms": labelIncoterms,
        "location_incoterms": locationIncoterms,
        "socialnetworks": socialnetworks == null
            ? []
            : List<dynamic>.from(socialnetworks!.map((x) => x)),
        "address": address,
        "zip": zip,
        "town": town,
      };
}
