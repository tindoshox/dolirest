// To parse this JSON data, do
//
//     final companyModel = companyModelFromJson(jsonString);

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'company_model.g.dart';

CompanyModel companyModelFromJson(String str) =>
    CompanyModel.fromJson(json.decode(str));

String companyModelToJson(CompanyModel data) => json.encode(data.toJson());

@HiveType(typeId: 14)
@JsonSerializable()
class CompanyModel {
  @HiveField(1)
  @JsonKey(name: "module")
  String? module;
  @HiveField(3)
  @JsonKey(name: "entity")
  int? entity;
  @HiveField(5)
  @JsonKey(name: "name")
  String? name;
  @HiveField(7)
  @JsonKey(name: "name_alias")
  dynamic nameAlias;
  @HiveField(9)
  @JsonKey(name: "particulier")
  dynamic particulier;
  @HiveField(11)
  @JsonKey(name: "status")
  int? status;
  @HiveField(13)
  @JsonKey(name: "phone")
  String? phone;
  @HiveField(15)
  @JsonKey(name: "fax")
  String? fax;
  @HiveField(17)
  @JsonKey(name: "email")
  String? email;
  @HiveField(19)
  @JsonKey(name: "no_email")
  dynamic noEmail;
  @HiveField(21)
  @JsonKey(name: "skype")
  dynamic skype;
  @HiveField(23)
  @JsonKey(name: "twitter")
  dynamic twitter;
  @HiveField(25)
  @JsonKey(name: "facebook")
  dynamic facebook;
  @HiveField(27)
  @JsonKey(name: "linkedin")
  dynamic linkedin;
  @HiveField(29)
  @JsonKey(name: "url")
  String? url;
  @HiveField(31)
  @JsonKey(name: "barcode")
  dynamic barcode;
  @HiveField(33)
  @JsonKey(name: "idprof1")
  String? idprof1;
  @HiveField(35)
  @JsonKey(name: "siren")
  dynamic siren;
  @HiveField(37)
  @JsonKey(name: "idprof2")
  String? idprof2;
  @HiveField(39)
  @JsonKey(name: "siret")
  dynamic siret;
  @HiveField(41)
  @JsonKey(name: "idprof3")
  String? idprof3;
  @HiveField(43)
  @JsonKey(name: "ape")
  dynamic ape;
  @HiveField(45)
  @JsonKey(name: "idprof4")
  String? idprof4;
  @HiveField(47)
  @JsonKey(name: "idprof5")
  String? idprof5;
  @HiveField(49)
  @JsonKey(name: "idprof6")
  String? idprof6;
  @HiveField(51)
  @JsonKey(name: "socialobject")
  String? socialobject;
  @HiveField(53)
  @JsonKey(name: "tva_assuj")
  String? tvaAssuj;
  @HiveField(55)
  @JsonKey(name: "tva_intra")
  String? tvaIntra;
  @HiveField(57)
  @JsonKey(name: "vat_reverse_charge")
  int? vatReverseCharge;
  @HiveField(59)
  @JsonKey(name: "localtax1_assuj")
  int? localtax1Assuj;
  @HiveField(61)
  @JsonKey(name: "localtax1_value")
  dynamic localtax1Value;
  @HiveField(63)
  @JsonKey(name: "localtax2_assuj")
  int? localtax2Assuj;
  @HiveField(65)
  @JsonKey(name: "localtax2_value")
  dynamic localtax2Value;
  @HiveField(67)
  @JsonKey(name: "managers")
  String? managers;
  @HiveField(69)
  @JsonKey(name: "capital")
  String? capital;
  @HiveField(71)
  @JsonKey(name: "typent_id")
  int? typentId;
  @HiveField(73)
  @JsonKey(name: "typent_code")
  dynamic typentCode;
  @HiveField(75)
  @JsonKey(name: "remise_percent")
  dynamic remisePercent;
  @HiveField(77)
  @JsonKey(name: "remise_supplier_percent")
  dynamic remiseSupplierPercent;
  @HiveField(79)
  @JsonKey(name: "mode_reglement_id")
  dynamic modeReglementId;
  @HiveField(81)
  @JsonKey(name: "cond_reglement_id")
  dynamic condReglementId;
  @HiveField(83)
  @JsonKey(name: "deposit_percent")
  dynamic depositPercent;
  @HiveField(85)
  @JsonKey(name: "date_modification")
  dynamic dateModification;
  @HiveField(87)
  @JsonKey(name: "user_modification")
  dynamic userModification;
  @HiveField(89)
  @JsonKey(name: "date_creation")
  dynamic dateCreation;
  @HiveField(91)
  @JsonKey(name: "user_creation")
  dynamic userCreation;
  @HiveField(93)
  @JsonKey(name: "code_client")
  dynamic codeClient;
  @HiveField(95)
  @JsonKey(name: "code_fournisseur")
  dynamic codeFournisseur;
  @HiveField(97)
  @JsonKey(name: "code_compta_client")
  dynamic codeComptaClient;
  @HiveField(99)
  @JsonKey(name: "code_compta")
  dynamic codeCompta;
  @HiveField(101)
  @JsonKey(name: "accountancy_code_customer")
  dynamic accountancyCodeCustomer;
  @HiveField(103)
  @JsonKey(name: "code_compta_fournisseur")
  dynamic codeComptaFournisseur;
  @HiveField(105)
  @JsonKey(name: "accountancy_code_supplier")
  dynamic accountancyCodeSupplier;
  @HiveField(107)
  @JsonKey(name: "code_compta_product")
  dynamic codeComptaProduct;
  @HiveField(109)
  @JsonKey(name: "note_private")
  String? notePrivate;
  @HiveField(111)
  @JsonKey(name: "note_public")
  dynamic notePublic;
  @HiveField(113)
  @JsonKey(name: "stcomm_id")
  dynamic stcommId;
  @HiveField(115)
  @JsonKey(name: "stcomm_picto")
  dynamic stcommPicto;
  @HiveField(117)
  @JsonKey(name: "status_prospect_label")
  dynamic statusProspectLabel;
  @HiveField(119)
  @JsonKey(name: "price_level")
  dynamic priceLevel;
  @HiveField(121)
  @JsonKey(name: "outstanding_limit")
  dynamic outstandingLimit;
  @HiveField(123)
  @JsonKey(name: "order_min_amount")
  dynamic orderMinAmount;
  @HiveField(125)
  @JsonKey(name: "supplier_order_min_amount")
  dynamic supplierOrderMinAmount;
  @HiveField(127)
  @JsonKey(name: "commercial_id")
  dynamic commercialId;
  @HiveField(129)
  @JsonKey(name: "parent")
  dynamic parent;
  @HiveField(131)
  @JsonKey(name: "default_lang")
  String? defaultLang;
  @HiveField(133)
  @JsonKey(name: "ref")
  dynamic ref;
  @HiveField(135)
  @JsonKey(name: "ref_ext")
  dynamic refExt;
  @HiveField(137)
  @JsonKey(name: "import_key")
  dynamic importKey;
  @HiveField(139)
  @JsonKey(name: "webservices_url")
  dynamic webservicesUrl;
  @HiveField(141)
  @JsonKey(name: "webservices_key")
  dynamic webservicesKey;
  @HiveField(143)
  @JsonKey(name: "logo")
  String? logo;
  @HiveField(145)
  @JsonKey(name: "logo_small")
  String? logoSmall;
  @HiveField(147)
  @JsonKey(name: "logo_mini")
  String? logoMini;
  @HiveField(149)
  @JsonKey(name: "logo_squarred")
  String? logoSquarred;
  @HiveField(151)
  @JsonKey(name: "logo_squarred_small")
  String? logoSquarredSmall;
  @HiveField(153)
  @JsonKey(name: "logo_squarred_mini")
  String? logoSquarredMini;
  @HiveField(155)
  @JsonKey(name: "accountancy_code_sell")
  dynamic accountancyCodeSell;
  @HiveField(157)
  @JsonKey(name: "accountancy_code_buy")
  dynamic accountancyCodeBuy;
  @HiveField(159)
  @JsonKey(name: "fk_multicurrency")
  dynamic fkMulticurrency;
  @HiveField(161)
  @JsonKey(name: "fk_warehouse")
  dynamic fkWarehouse;
  @HiveField(163)
  @JsonKey(name: "multicurrency_code")
  dynamic multicurrencyCode;
  @HiveField(165)
  @JsonKey(name: "bank_account")
  dynamic bankAccount;
  @HiveField(167)
  @JsonKey(name: "id")
  int? id;
  @HiveField(169)
  @JsonKey(name: "array_languages")
  dynamic arrayLanguages;
  @HiveField(171)
  @JsonKey(name: "contacts_ids")
  dynamic contactsIds;
  @HiveField(173)
  @JsonKey(name: "linked_objects")
  dynamic linkedObjects;
  @HiveField(175)
  @JsonKey(name: "linkedObjectsIds")
  dynamic linkedObjectsIds;
  @HiveField(177)
  @JsonKey(name: "oldref")
  dynamic oldref;
  @HiveField(179)
  @JsonKey(name: "canvas")
  dynamic canvas;
  @HiveField(181)
  @JsonKey(name: "fk_project")
  dynamic fkProject;
  @HiveField(183)
  @JsonKey(name: "user")
  dynamic user;
  @HiveField(185)
  @JsonKey(name: "origin")
  dynamic origin;
  @HiveField(187)
  @JsonKey(name: "origin_id")
  dynamic originId;
  @HiveField(189)
  @JsonKey(name: "statut")
  dynamic statut;
  @HiveField(191)
  @JsonKey(name: "country_id")
  String? countryId;
  @HiveField(193)
  @JsonKey(name: "country_code")
  String? countryCode;
  @HiveField(195)
  @JsonKey(name: "state_id")
  int? stateId;
  @HiveField(197)
  @JsonKey(name: "region_id")
  dynamic regionId;
  @HiveField(199)
  @JsonKey(name: "barcode_type")
  dynamic barcodeType;
  @HiveField(201)
  @JsonKey(name: "barcode_type_coder")
  dynamic barcodeTypeCoder;
  @HiveField(203)
  @JsonKey(name: "demand_reason_id")
  dynamic demandReasonId;
  @HiveField(205)
  @JsonKey(name: "transport_mode_id")
  dynamic transportModeId;
  @HiveField(207)
  @JsonKey(name: "shipping_method_id")
  dynamic shippingMethodId;
  @HiveField(209)
  @JsonKey(name: "shipping_method")
  dynamic shippingMethod;
  @HiveField(211)
  @JsonKey(name: "multicurrency_tx")
  dynamic multicurrencyTx;
  @HiveField(213)
  @JsonKey(name: "model_pdf")
  dynamic modelPdf;
  @HiveField(215)
  @JsonKey(name: "last_main_doc")
  dynamic lastMainDoc;
  @HiveField(217)
  @JsonKey(name: "fk_bank")
  dynamic fkBank;
  @HiveField(219)
  @JsonKey(name: "fk_account")
  dynamic fkAccount;
  @HiveField(221)
  @JsonKey(name: "date_validation")
  dynamic dateValidation;
  @HiveField(223)
  @JsonKey(name: "date_update")
  dynamic dateUpdate;
  @HiveField(225)
  @JsonKey(name: "date_cloture")
  dynamic dateCloture;
  @HiveField(227)
  @JsonKey(name: "user_author")
  dynamic userAuthor;
  @HiveField(229)
  @JsonKey(name: "user_creation_id")
  dynamic userCreationId;
  @HiveField(231)
  @JsonKey(name: "user_valid")
  dynamic userValid;
  @HiveField(233)
  @JsonKey(name: "user_validation")
  dynamic userValidation;
  @HiveField(235)
  @JsonKey(name: "user_validation_id")
  dynamic userValidationId;
  @HiveField(237)
  @JsonKey(name: "user_closing_id")
  dynamic userClosingId;
  @HiveField(239)
  @JsonKey(name: "user_modification_id")
  dynamic userModificationId;
  @HiveField(241)
  @JsonKey(name: "specimen")
  int? specimen;
  @HiveField(243)
  @JsonKey(name: "labelStatus")
  dynamic labelStatus;
  @HiveField(245)
  @JsonKey(name: "showphoto_on_popup")
  dynamic showphotoOnPopup;
  @HiveField(247)
  @JsonKey(name: "output")
  dynamic output;
  @HiveField(249)
  @JsonKey(name: "address")
  String? address;
  @HiveField(251)
  @JsonKey(name: "zip")
  String? zip;
  @HiveField(253)
  @JsonKey(name: "town")
  String? town;

  CompanyModel({
    this.module,
    this.entity,
    this.name,
    this.nameAlias,
    this.particulier,
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
    this.siren,
    this.idprof2,
    this.siret,
    this.idprof3,
    this.ape,
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
    this.remisePercent,
    this.remiseSupplierPercent,
    this.modeReglementId,
    this.condReglementId,
    this.depositPercent,
    this.dateModification,
    this.userModification,
    this.dateCreation,
    this.userCreation,
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
    this.commercialId,
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
    this.bankAccount,
    this.id,
    this.arrayLanguages,
    this.contactsIds,
    this.linkedObjects,
    this.linkedObjectsIds,
    this.oldref,
    this.canvas,
    this.fkProject,
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
    this.output,
    this.address,
    this.zip,
    this.town,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyModelToJson(this);
}
