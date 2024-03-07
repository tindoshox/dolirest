// To parse this JSON data, do
//
//     final invoiceModel = invoiceModelFromJson(jsonString);

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'invoice_model.g.dart';

InvoiceModel invoiceModelFromJson(String str) =>
    InvoiceModel.fromJson(json.decode(str));

String invoiceModelToJson(InvoiceModel data) => json.encode(data.toJson());

@HiveType(typeId: 1)
@JsonSerializable()
class InvoiceModel {
  @HiveField(1)
  @JsonKey(name: "brouillon")
  dynamic brouillon;
  @HiveField(3)
  @JsonKey(name: "socid")
  dynamic socid;
  @HiveField(5)
  @JsonKey(name: "user_author")
  dynamic userAuthor;
  @HiveField(7)
  @JsonKey(name: "fk_user_author")
  dynamic fkUserAuthor;
  @HiveField(9)
  @JsonKey(name: "user_valid")
  dynamic userValid;
  @HiveField(11)
  @JsonKey(name: "fk_user_valid")
  dynamic fkUserValid;
  @HiveField(13)
  @JsonKey(name: "user_modification")
  dynamic userModification;
  @HiveField(15)
  @JsonKey(name: "fk_user_modif")
  dynamic fkUserModif;
  @HiveField(17)
  @JsonKey(name: "date")
  dynamic date;
  @HiveField(19)
  @JsonKey(name: "datem")
  dynamic datem;
  @HiveField(21)
  @JsonKey(name: "date_livraison")
  dynamic dateLivraison;
  @HiveField(23)
  @JsonKey(name: "delivery_date")
  dynamic deliveryDate;
  @HiveField(25)
  @JsonKey(name: "ref_client")
  dynamic refClient;
  @HiveField(27)
  @JsonKey(name: "ref_customer")
  dynamic refCustomer;
  @HiveField(29)
  @JsonKey(name: "remise_absolue")
  dynamic remiseAbsolue;
  @HiveField(31)
  @JsonKey(name: "remise_percent")
  dynamic remisePercent;
  @HiveField(33)
  @JsonKey(name: "total_ht")
  dynamic totalHt;
  @HiveField(35)
  @JsonKey(name: "total_tva")
  dynamic totalTva;
  @HiveField(37)
  @JsonKey(name: "total_localtax1")
  dynamic totalLocaltax1;
  @HiveField(39)
  @JsonKey(name: "total_localtax2")
  dynamic totalLocaltax2;
  @HiveField(41)
  @JsonKey(name: "total_ttc")
  dynamic totalTtc;
  @HiveField(43)
  @JsonKey(name: "revenuestamp")
  dynamic revenuestamp;
  @HiveField(45)
  @JsonKey(name: "resteapayer")
  dynamic resteapayer;
  @HiveField(47)
  @JsonKey(name: "close_code")
  dynamic closeCode;
  @HiveField(49)
  @JsonKey(name: "close_note")
  dynamic closeNote;
  @HiveField(51)
  @JsonKey(name: "paye")
  dynamic paye;
  @HiveField(53)
  @JsonKey(name: "module_source")
  dynamic moduleSource;
  @HiveField(55)
  @JsonKey(name: "pos_source")
  dynamic posSource;
  @HiveField(57)
  @JsonKey(name: "fk_fac_rec_source")
  dynamic fkFacRecSource;
  @HiveField(59)
  @JsonKey(name: "fk_facture_source")
  dynamic fkFactureSource;
  @HiveField(61)
  @JsonKey(name: "linked_objects")
  List<dynamic>? linkedObjects;
  @HiveField(63)
  @JsonKey(name: "date_lim_reglement")
  dynamic dateLimReglement;
  @HiveField(65)
  @JsonKey(name: "cond_reglement_code")
  dynamic condReglementCode;
  @HiveField(67)
  @JsonKey(name: "cond_reglement_doc")
  dynamic condReglementDoc;
  @HiveField(69)
  @JsonKey(name: "mode_reglement_code")
  dynamic modeReglementCode;
  @HiveField(71)
  @JsonKey(name: "fk_bank")
  dynamic fkBank;
  @HiveField(73)
  @JsonKey(name: "lines")
  List<Line>? lines;
  @HiveField(75)
  @JsonKey(name: "line")
  dynamic line;
  @HiveField(77)
  @JsonKey(name: "extraparams")
  dynamic extraparams;
  @HiveField(79)
  @JsonKey(name: "fac_rec")
  dynamic facRec;
  @HiveField(81)
  @JsonKey(name: "date_pointoftax")
  dynamic datePointoftax;
  @HiveField(83)
  @JsonKey(name: "fk_multicurrency")
  dynamic fkMulticurrency;
  @HiveField(85)
  @JsonKey(name: "multicurrency_code")
  dynamic multicurrencyCode;
  @HiveField(87)
  @JsonKey(name: "multicurrency_tx")
  dynamic multicurrencyTx;
  @HiveField(89)
  @JsonKey(name: "multicurrency_total_ht")
  dynamic multicurrencyTotalHt;
  @HiveField(91)
  @JsonKey(name: "multicurrency_total_tva")
  dynamic multicurrencyTotalTva;
  @HiveField(93)
  @JsonKey(name: "multicurrency_total_ttc")
  dynamic multicurrencyTotalTtc;
  @HiveField(95)
  @JsonKey(name: "situation_cycle_ref")
  dynamic situationCycleRef;
  @HiveField(97)
  @JsonKey(name: "situation_counter")
  dynamic situationCounter;
  @HiveField(99)
  @JsonKey(name: "situation_final")
  dynamic situationFinal;
  @HiveField(101)
  @JsonKey(name: "tab_previous_situation_invoice")
  List<dynamic>? tabPreviousSituationInvoice;
  @HiveField(103)
  @JsonKey(name: "tab_next_situation_invoice")
  List<dynamic>? tabNextSituationInvoice;
  @HiveField(105)
  @JsonKey(name: "retained_warranty")
  dynamic retainedWarranty;
  @HiveField(107)
  @JsonKey(name: "retained_warranty_date_limit")
  dynamic retainedWarrantyDateLimit;
  @HiveField(109)
  @JsonKey(name: "retained_warranty_fk_cond_reglement")
  dynamic retainedWarrantyFkCondReglement;
  @HiveField(111)
  @JsonKey(name: "type")
  dynamic type;
  @HiveField(113)
  @JsonKey(name: "subtype")
  dynamic subtype;
  @HiveField(115)
  @JsonKey(name: "totalpaid")
  dynamic totalpaid;
  @HiveField(117)
  @JsonKey(name: "totaldeposits")
  dynamic totaldeposits;
  @HiveField(119)
  @JsonKey(name: "totalcreditnotes")
  dynamic totalcreditnotes;
  @HiveField(121)
  @JsonKey(name: "sumpayed")
  dynamic sumpayed;
  @HiveField(123)
  @JsonKey(name: "sumpayed_multicurrency")
  dynamic sumpayedMulticurrency;
  @HiveField(125)
  @JsonKey(name: "sumdeposit")
  dynamic sumdeposit;
  @HiveField(127)
  @JsonKey(name: "sumdeposit_multicurrency")
  dynamic sumdepositMulticurrency;
  @HiveField(129)
  @JsonKey(name: "sumcreditnote")
  dynamic sumcreditnote;
  @HiveField(131)
  @JsonKey(name: "sumcreditnote_multicurrency")
  dynamic sumcreditnoteMulticurrency;
  @HiveField(133)
  @JsonKey(name: "remaintopay")
  dynamic remaintopay;
  @HiveField(135)
  @JsonKey(name: "module")
  dynamic module;
  @HiveField(137)
  @JsonKey(name: "id")
  dynamic id;
  @HiveField(139)
  @JsonKey(name: "entity")
  dynamic entity;
  @HiveField(141)
  @JsonKey(name: "import_key")
  dynamic importKey;
  @HiveField(143)
  @JsonKey(name: "array_options")
  List<dynamic>? arrayOptions;
  @HiveField(145)
  @JsonKey(name: "array_languages")
  dynamic arrayLanguages;
  @HiveField(147)
  @JsonKey(name: "contacts_ids")
  List<dynamic>? contactsIds;
  @HiveField(149)
  @JsonKey(name: "linkedObjectsIds")
  dynamic linkedObjectsIds;
  @HiveField(151)
  @JsonKey(name: "oldref")
  dynamic oldref;
  @HiveField(153)
  @JsonKey(name: "fk_project")
  dynamic fkProject;
  @HiveField(155)
  @JsonKey(name: "contact_id")
  dynamic contactId;
  @HiveField(157)
  @JsonKey(name: "user")
  dynamic user;
  @HiveField(159)
  @JsonKey(name: "origin")
  dynamic origin;
  @HiveField(161)
  @JsonKey(name: "origin_id")
  dynamic originId;
  @HiveField(163)
  @JsonKey(name: "ref")
  dynamic ref;
  @HiveField(165)
  @JsonKey(name: "ref_ext")
  dynamic refExt;
  @HiveField(167)
  @JsonKey(name: "statut")
  dynamic statut;
  @HiveField(169)
  @JsonKey(name: "status")
  dynamic status;
  @HiveField(171)
  @JsonKey(name: "country_id")
  dynamic countryId;
  @HiveField(173)
  @JsonKey(name: "country_code")
  dynamic countryCode;
  @HiveField(175)
  @JsonKey(name: "state_id")
  dynamic stateId;
  @HiveField(177)
  @JsonKey(name: "region_id")
  dynamic regionId;
  @HiveField(179)
  @JsonKey(name: "mode_reglement_id")
  dynamic modeReglementId;
  @HiveField(181)
  @JsonKey(name: "cond_reglement_id")
  dynamic condReglementId;
  @HiveField(183)
  @JsonKey(name: "demand_reason_id")
  dynamic demandReasonId;
  @HiveField(185)
  @JsonKey(name: "transport_mode_id")
  dynamic transportModeId;
  @HiveField(187)
  @JsonKey(name: "shipping_method_id")
  dynamic shippingMethodId;
  @HiveField(189)
  @JsonKey(name: "shipping_method")
  dynamic shippingMethod;
  @HiveField(191)
  @JsonKey(name: "model_pdf")
  dynamic modelPdf;
  @HiveField(193)
  @JsonKey(name: "last_main_doc")
  dynamic lastMainDoc;
  @HiveField(195)
  @JsonKey(name: "fk_account")
  dynamic fkAccount;
  @HiveField(197)
  @JsonKey(name: "note_public")
  dynamic notePublic;
  @HiveField(199)
  @JsonKey(name: "note_private")
  dynamic notePrivate;
  @HiveField(201)
  @JsonKey(name: "name")
  dynamic name;
  @HiveField(203)
  @JsonKey(name: "lastname")
  dynamic lastname;
  @HiveField(205)
  @JsonKey(name: "firstname")
  dynamic firstname;
  @HiveField(207)
  @JsonKey(name: "civility_id")
  dynamic civilityId;
  @HiveField(209)
  @JsonKey(name: "date_creation")
  dynamic dateCreation;
  @HiveField(211)
  @JsonKey(name: "date_validation")
  dynamic dateValidation;
  @HiveField(213)
  @JsonKey(name: "date_modification")
  dynamic dateModification;
  @HiveField(215)
  @JsonKey(name: "date_update")
  dynamic dateUpdate;
  @HiveField(217)
  @JsonKey(name: "date_cloture")
  dynamic dateCloture;
  @HiveField(219)
  @JsonKey(name: "user_creation")
  dynamic userCreation;
  @HiveField(221)
  @JsonKey(name: "user_creation_id")
  dynamic userCreationId;
  @HiveField(223)
  @JsonKey(name: "user_validation")
  dynamic userValidation;
  @HiveField(225)
  @JsonKey(name: "user_validation_id")
  dynamic userValidationId;
  @HiveField(227)
  @JsonKey(name: "user_closing_id")
  dynamic userClosingId;
  @HiveField(229)
  @JsonKey(name: "user_modification_id")
  dynamic userModificationId;
  @HiveField(231)
  @JsonKey(name: "specimen")
  dynamic specimen;
  @HiveField(233)
  @JsonKey(name: "labelStatus")
  dynamic labelStatus;
  @HiveField(235)
  @JsonKey(name: "showphoto_on_popup")
  dynamic showphotoOnPopup;
  @HiveField(237)
  @JsonKey(name: "nb")
  List<dynamic>? nb;
  @HiveField(239)
  @JsonKey(name: "output")
  dynamic output;
  @HiveField(241)
  @JsonKey(name: "fk_incoterms")
  dynamic fkIncoterms;
  @HiveField(243)
  @JsonKey(name: "label_incoterms")
  dynamic labelIncoterms;
  @HiveField(245)
  @JsonKey(name: "location_incoterms")
  dynamic locationIncoterms;
  @HiveField(247)
  @JsonKey(name: "nom")
  dynamic nom;

  InvoiceModel({
    this.brouillon,
    this.socid,
    this.userAuthor,
    this.fkUserAuthor,
    this.userValid,
    this.fkUserValid,
    this.userModification,
    this.fkUserModif,
    this.date,
    this.datem,
    this.dateLivraison,
    this.deliveryDate,
    this.refClient,
    this.refCustomer,
    this.remiseAbsolue,
    this.remisePercent,
    this.totalHt,
    this.totalTva,
    this.totalLocaltax1,
    this.totalLocaltax2,
    this.totalTtc,
    this.revenuestamp,
    this.resteapayer,
    this.closeCode,
    this.closeNote,
    this.paye,
    this.moduleSource,
    this.posSource,
    this.fkFacRecSource,
    this.fkFactureSource,
    this.linkedObjects,
    this.dateLimReglement,
    this.condReglementCode,
    this.condReglementDoc,
    this.modeReglementCode,
    this.fkBank,
    this.lines,
    this.line,
    this.extraparams,
    this.facRec,
    this.datePointoftax,
    this.fkMulticurrency,
    this.multicurrencyCode,
    this.multicurrencyTx,
    this.multicurrencyTotalHt,
    this.multicurrencyTotalTva,
    this.multicurrencyTotalTtc,
    this.situationCycleRef,
    this.situationCounter,
    this.situationFinal,
    this.tabPreviousSituationInvoice,
    this.tabNextSituationInvoice,
    this.retainedWarranty,
    this.retainedWarrantyDateLimit,
    this.retainedWarrantyFkCondReglement,
    this.type,
    this.subtype,
    this.totalpaid,
    this.totaldeposits,
    this.totalcreditnotes,
    this.sumpayed,
    this.sumpayedMulticurrency,
    this.sumdeposit,
    this.sumdepositMulticurrency,
    this.sumcreditnote,
    this.sumcreditnoteMulticurrency,
    this.remaintopay,
    this.module,
    this.id,
    this.entity,
    this.importKey,
    this.arrayOptions,
    this.arrayLanguages,
    this.contactsIds,
    this.linkedObjectsIds,
    this.oldref,
    this.fkProject,
    this.contactId,
    this.user,
    this.origin,
    this.originId,
    this.ref,
    this.refExt,
    this.statut,
    this.status,
    this.countryId,
    this.countryCode,
    this.stateId,
    this.regionId,
    this.modeReglementId,
    this.condReglementId,
    this.demandReasonId,
    this.transportModeId,
    this.shippingMethodId,
    this.shippingMethod,
    this.modelPdf,
    this.lastMainDoc,
    this.fkAccount,
    this.notePublic,
    this.notePrivate,
    this.name,
    this.lastname,
    this.firstname,
    this.civilityId,
    this.dateCreation,
    this.dateValidation,
    this.dateModification,
    this.dateUpdate,
    this.dateCloture,
    this.userCreation,
    this.userCreationId,
    this.userValidation,
    this.userValidationId,
    this.userClosingId,
    this.userModificationId,
    this.specimen,
    this.labelStatus,
    this.showphotoOnPopup,
    this.nb,
    this.output,
    this.fkIncoterms,
    this.labelIncoterms,
    this.locationIncoterms,
    this.nom,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) =>
      _$InvoiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceModelToJson(this);
}

@HiveType(typeId: 2)
@JsonSerializable()
class Line {
  @HiveField(1)
  @JsonKey(name: "fk_facture")
  dynamic fkFacture;
  @HiveField(3)
  @JsonKey(name: "fk_parent_line")
  dynamic fkParentLine;
  @HiveField(5)
  @JsonKey(name: "desc")
  dynamic desc;
  @HiveField(7)
  @JsonKey(name: "ref_ext")
  dynamic refExt;
  @HiveField(9)
  @JsonKey(name: "localtax1_type")
  dynamic localtax1Type;
  @HiveField(11)
  @JsonKey(name: "localtax2_type")
  dynamic localtax2Type;
  @HiveField(13)
  @JsonKey(name: "fk_remise_except")
  dynamic fkRemiseExcept;
  @HiveField(15)
  @JsonKey(name: "rang")
  dynamic rang;
  @HiveField(17)
  @JsonKey(name: "fk_fournprice")
  dynamic fkFournprice;
  @HiveField(19)
  @JsonKey(name: "pa_ht")
  dynamic paHt;
  @HiveField(21)
  @JsonKey(name: "marge_tx")
  dynamic margeTx;
  @HiveField(23)
  @JsonKey(name: "marque_tx")
  dynamic marqueTx;
  @HiveField(25)
  @JsonKey(name: "remise_percent")
  dynamic remisePercent;
  @HiveField(27)
  @JsonKey(name: "special_code")
  dynamic specialCode;
  @HiveField(29)
  @JsonKey(name: "origin")
  dynamic origin;
  @HiveField(31)
  @JsonKey(name: "origin_id")
  dynamic originId;
  @HiveField(33)
  @JsonKey(name: "fk_code_ventilation")
  dynamic fkCodeVentilation;
  @HiveField(35)
  @JsonKey(name: "date_start")
  dynamic dateStart;
  @HiveField(37)
  @JsonKey(name: "date_end")
  dynamic dateEnd;
  @HiveField(39)
  @JsonKey(name: "situation_percent")
  dynamic situationPercent;
  @HiveField(41)
  @JsonKey(name: "fk_prev_id")
  dynamic fkPrevId;
  @HiveField(43)
  @JsonKey(name: "multicurrency_subprice")
  dynamic multicurrencySubprice;
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
  @JsonKey(name: "label")
  dynamic label;
  @HiveField(53)
  @JsonKey(name: "ref")
  dynamic ref;
  @HiveField(55)
  @JsonKey(name: "libelle")
  dynamic libelle;
  @HiveField(57)
  @JsonKey(name: "product_type")
  dynamic productType;
  @HiveField(59)
  @JsonKey(name: "product_ref")
  dynamic productRef;
  @HiveField(61)
  @JsonKey(name: "product_label")
  dynamic productLabel;
  @HiveField(63)
  @JsonKey(name: "product_desc")
  dynamic productDesc;
  @HiveField(65)
  @JsonKey(name: "qty")
  dynamic qty;
  @HiveField(67)
  @JsonKey(name: "subprice")
  dynamic subprice;
  @HiveField(69)
  @JsonKey(name: "price")
  dynamic price;
  @HiveField(71)
  @JsonKey(name: "fk_product")
  dynamic fkProduct;
  @HiveField(73)
  @JsonKey(name: "vat_src_code")
  dynamic vatSrcCode;
  @HiveField(75)
  @JsonKey(name: "tva_tx")
  dynamic tvaTx;
  @HiveField(77)
  @JsonKey(name: "localtax1_tx")
  dynamic localtax1Tx;
  @HiveField(79)
  @JsonKey(name: "localtax2_tx")
  dynamic localtax2Tx;
  @HiveField(81)
  @JsonKey(name: "remise")
  dynamic remise;
  @HiveField(83)
  @JsonKey(name: "total_ht")
  dynamic totalHt;
  @HiveField(85)
  @JsonKey(name: "total_tva")
  dynamic totalTva;
  @HiveField(87)
  @JsonKey(name: "total_localtax1")
  dynamic totalLocaltax1;
  @HiveField(89)
  @JsonKey(name: "total_localtax2")
  dynamic totalLocaltax2;
  @HiveField(91)
  @JsonKey(name: "total_ttc")
  dynamic totalTtc;
  @HiveField(93)
  @JsonKey(name: "date_start_fill")
  dynamic dateStartFill;
  @HiveField(95)
  @JsonKey(name: "date_end_fill")
  dynamic dateEndFill;
  @HiveField(97)
  @JsonKey(name: "buy_price_ht")
  dynamic buyPriceHt;
  @HiveField(99)
  @JsonKey(name: "buyprice")
  dynamic buyprice;
  @HiveField(101)
  @JsonKey(name: "info_bits")
  dynamic infoBits;
  @HiveField(103)
  @JsonKey(name: "fk_user_author")
  dynamic fkUserAuthor;
  @HiveField(105)
  @JsonKey(name: "fk_user_modif")
  dynamic fkUserModif;
  @HiveField(107)
  @JsonKey(name: "fk_accounting_account")
  dynamic fkAccountingAccount;
  @HiveField(109)
  @JsonKey(name: "id")
  dynamic id;
  @HiveField(111)
  @JsonKey(name: "rowid")
  dynamic rowid;
  @HiveField(113)
  @JsonKey(name: "fk_unit")
  dynamic fkUnit;
  @HiveField(115)
  @JsonKey(name: "date_debut_prevue")
  dynamic dateDebutPrevue;
  @HiveField(117)
  @JsonKey(name: "date_debut_reel")
  dynamic dateDebutReel;
  @HiveField(119)
  @JsonKey(name: "date_fin_prevue")
  dynamic dateFinPrevue;
  @HiveField(121)
  @JsonKey(name: "date_fin_reel")
  dynamic dateFinReel;
  @HiveField(123)
  @JsonKey(name: "weight")
  dynamic weight;
  @HiveField(125)
  @JsonKey(name: "weight_units")
  dynamic weightUnits;
  @HiveField(127)
  @JsonKey(name: "width")
  dynamic width;
  @HiveField(129)
  @JsonKey(name: "width_units")
  dynamic widthUnits;
  @HiveField(131)
  @JsonKey(name: "height")
  dynamic height;
  @HiveField(133)
  @JsonKey(name: "height_units")
  dynamic heightUnits;
  @HiveField(135)
  @JsonKey(name: "length")
  dynamic length;
  @HiveField(137)
  @JsonKey(name: "length_units")
  dynamic lengthUnits;
  @HiveField(139)
  @JsonKey(name: "surface")
  dynamic surface;
  @HiveField(141)
  @JsonKey(name: "surface_units")
  dynamic surfaceUnits;
  @HiveField(143)
  @JsonKey(name: "volume")
  dynamic volume;
  @HiveField(145)
  @JsonKey(name: "volume_units")
  dynamic volumeUnits;
  @HiveField(147)
  @JsonKey(name: "multilangs")
  dynamic multilangs;
  @HiveField(149)
  @JsonKey(name: "description")
  dynamic description;
  @HiveField(151)
  @JsonKey(name: "product")
  dynamic product;
  @HiveField(153)
  @JsonKey(name: "product_barcode")
  dynamic productBarcode;
  @HiveField(155)
  @JsonKey(name: "fk_product_type")
  dynamic fkProductType;
  @HiveField(157)
  @JsonKey(name: "duree")
  dynamic duree;
  @HiveField(159)
  @JsonKey(name: "module")
  dynamic module;
  @HiveField(161)
  @JsonKey(name: "entity")
  dynamic entity;
  @HiveField(163)
  @JsonKey(name: "import_key")
  dynamic importKey;
  @HiveField(165)
  @JsonKey(name: "array_options")
  List<dynamic>? arrayOptions;
  @HiveField(167)
  @JsonKey(name: "array_languages")
  dynamic arrayLanguages;
  @HiveField(169)
  @JsonKey(name: "contacts_ids")
  dynamic contactsIds;
  @HiveField(171)
  @JsonKey(name: "linked_objects")
  dynamic linkedObjects;
  @HiveField(173)
  @JsonKey(name: "linkedObjectsIds")
  dynamic linkedObjectsIds;
  @HiveField(175)
  @JsonKey(name: "oldref")
  dynamic oldref;
  @HiveField(177)
  @JsonKey(name: "statut")
  dynamic statut;
  @HiveField(179)
  @JsonKey(name: "status")
  dynamic status;
  @HiveField(181)
  @JsonKey(name: "state_id")
  dynamic stateId;
  @HiveField(183)
  @JsonKey(name: "region_id")
  dynamic regionId;
  @HiveField(185)
  @JsonKey(name: "demand_reason_id")
  dynamic demandReasonId;
  @HiveField(187)
  @JsonKey(name: "transport_mode_id")
  dynamic transportModeId;
  @HiveField(189)
  @JsonKey(name: "shipping_method")
  dynamic shippingMethod;
  @HiveField(191)
  @JsonKey(name: "multicurrency_tx")
  dynamic multicurrencyTx;
  @HiveField(193)
  @JsonKey(name: "last_main_doc")
  dynamic lastMainDoc;
  @HiveField(195)
  @JsonKey(name: "fk_bank")
  dynamic fkBank;
  @HiveField(197)
  @JsonKey(name: "fk_account")
  dynamic fkAccount;
  @HiveField(199)
  @JsonKey(name: "lines")
  dynamic lines;
  @HiveField(201)
  @JsonKey(name: "date_creation")
  dynamic dateCreation;
  @HiveField(203)
  @JsonKey(name: "date_validation")
  dynamic dateValidation;
  @HiveField(205)
  @JsonKey(name: "date_modification")
  dynamic dateModification;
  @HiveField(207)
  @JsonKey(name: "date_update")
  dynamic dateUpdate;
  @HiveField(209)
  @JsonKey(name: "date_cloture")
  dynamic dateCloture;
  @HiveField(211)
  @JsonKey(name: "user_author")
  dynamic userAuthor;
  @HiveField(213)
  @JsonKey(name: "user_creation")
  dynamic userCreation;
  @HiveField(215)
  @JsonKey(name: "user_creation_id")
  dynamic userCreationId;
  @HiveField(217)
  @JsonKey(name: "user_valid")
  dynamic userValid;
  @HiveField(219)
  @JsonKey(name: "user_validation")
  dynamic userValidation;
  @HiveField(221)
  @JsonKey(name: "user_validation_id")
  dynamic userValidationId;
  @HiveField(223)
  @JsonKey(name: "user_closing_id")
  dynamic userClosingId;
  @HiveField(225)
  @JsonKey(name: "user_modification")
  dynamic userModification;
  @HiveField(227)
  @JsonKey(name: "user_modification_id")
  dynamic userModificationId;
  @HiveField(229)
  @JsonKey(name: "specimen")
  dynamic specimen;
  @HiveField(231)
  @JsonKey(name: "labelStatus")
  dynamic labelStatus;
  @HiveField(233)
  @JsonKey(name: "showphoto_on_popup")
  dynamic showphotoOnPopup;
  @HiveField(235)
  @JsonKey(name: "nb")
  List<dynamic>? nb;
  @HiveField(237)
  @JsonKey(name: "output")
  dynamic output;
  @HiveField(239)
  @JsonKey(name: "extraparams")
  dynamic extraparams;
  @HiveField(241)
  @JsonKey(name: "code_ventilation")
  dynamic codeVentilation;

  Line({
    this.fkFacture,
    this.fkParentLine,
    this.desc,
    this.refExt,
    this.localtax1Type,
    this.localtax2Type,
    this.fkRemiseExcept,
    this.rang,
    this.fkFournprice,
    this.paHt,
    this.margeTx,
    this.marqueTx,
    this.remisePercent,
    this.specialCode,
    this.origin,
    this.originId,
    this.fkCodeVentilation,
    this.dateStart,
    this.dateEnd,
    this.situationPercent,
    this.fkPrevId,
    this.multicurrencySubprice,
    this.multicurrencyTotalHt,
    this.multicurrencyTotalTva,
    this.multicurrencyTotalTtc,
    this.label,
    this.ref,
    this.libelle,
    this.productType,
    this.productRef,
    this.productLabel,
    this.productDesc,
    this.qty,
    this.subprice,
    this.price,
    this.fkProduct,
    this.vatSrcCode,
    this.tvaTx,
    this.localtax1Tx,
    this.localtax2Tx,
    this.remise,
    this.totalHt,
    this.totalTva,
    this.totalLocaltax1,
    this.totalLocaltax2,
    this.totalTtc,
    this.dateStartFill,
    this.dateEndFill,
    this.buyPriceHt,
    this.buyprice,
    this.infoBits,
    this.fkUserAuthor,
    this.fkUserModif,
    this.fkAccountingAccount,
    this.id,
    this.rowid,
    this.fkUnit,
    this.dateDebutPrevue,
    this.dateDebutReel,
    this.dateFinPrevue,
    this.dateFinReel,
    this.weight,
    this.weightUnits,
    this.width,
    this.widthUnits,
    this.height,
    this.heightUnits,
    this.length,
    this.lengthUnits,
    this.surface,
    this.surfaceUnits,
    this.volume,
    this.volumeUnits,
    this.multilangs,
    this.description,
    this.product,
    this.productBarcode,
    this.fkProductType,
    this.duree,
    this.module,
    this.entity,
    this.importKey,
    this.arrayOptions,
    this.arrayLanguages,
    this.contactsIds,
    this.linkedObjects,
    this.linkedObjectsIds,
    this.oldref,
    this.statut,
    this.status,
    this.stateId,
    this.regionId,
    this.demandReasonId,
    this.transportModeId,
    this.shippingMethod,
    this.multicurrencyTx,
    this.lastMainDoc,
    this.fkBank,
    this.fkAccount,
    this.lines,
    this.dateCreation,
    this.dateValidation,
    this.dateModification,
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
    this.codeVentilation,
  });

  factory Line.fromJson(Map<String, dynamic> json) => _$LineFromJson(json);

  Map<String, dynamic> toJson() => _$LineToJson(this);
}
