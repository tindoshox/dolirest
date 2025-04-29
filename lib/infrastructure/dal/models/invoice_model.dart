// To parse this JSON data, do
//
//     final invoiceModel = invoiceModelFromJson(jsonString);

import 'package:hive_ce_flutter/hive_flutter.dart';

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'invoice_model.g.dart';

InvoiceModel invoiceModelFromJson(String str) => InvoiceModel.fromJson(json.decode(str));

String invoiceModelToJson(InvoiceModel data) => json.encode(data.toJson());

@HiveType(typeId: 1)
@JsonSerializable()
class InvoiceModel {
    @HiveField(1)
    @JsonKey(name: "module")
    dynamic module;
    @HiveField(3)
    @JsonKey(name: "id")
    dynamic id;
    @HiveField(5)
    @JsonKey(name: "entity")
    dynamic entity;
    @HiveField(7)
    @JsonKey(name: "import_key")
    dynamic importKey;
    @HiveField(9)
    @JsonKey(name: "array_options")
    List<dynamic>? arrayOptions;
    @HiveField(11)
    @JsonKey(name: "array_languages")
    dynamic arrayLanguages;
    @HiveField(13)
    @JsonKey(name: "contacts_ids")
    List<dynamic>? contactsIds;
    @HiveField(15)
    @JsonKey(name: "linkedObjectsIds")
    dynamic linkedObjectsIds;
    @HiveField(17)
    @JsonKey(name: "fk_project")
    dynamic fkProject;
    @HiveField(19)
    @JsonKey(name: "contact_id")
    dynamic contactId;
    @HiveField(21)
    @JsonKey(name: "user")
    dynamic user;
    @HiveField(23)
    @JsonKey(name: "origin_type")
    dynamic originType;
    @HiveField(25)
    @JsonKey(name: "origin_id")
    dynamic originId;
    @HiveField(27)
    @JsonKey(name: "ref")
    dynamic ref;
    @HiveField(29)
    @JsonKey(name: "ref_ext")
    dynamic refExt;
    @HiveField(31)
    @JsonKey(name: "statut")
    dynamic statut;
    @HiveField(33)
    @JsonKey(name: "status")
    dynamic status;
    @HiveField(35)
    @JsonKey(name: "country_id")
    dynamic countryId;
    @HiveField(37)
    @JsonKey(name: "country_code")
    dynamic countryCode;
    @HiveField(39)
    @JsonKey(name: "state_id")
    dynamic stateId;
    @HiveField(41)
    @JsonKey(name: "region_id")
    dynamic regionId;
    @HiveField(43)
    @JsonKey(name: "mode_reglement_id")
    dynamic modeReglementId;
    @HiveField(45)
    @JsonKey(name: "cond_reglement_id")
    dynamic condReglementId;
    @HiveField(47)
    @JsonKey(name: "demand_reason_id")
    dynamic demandReasonId;
    @HiveField(49)
    @JsonKey(name: "transport_mode_id")
    dynamic transportModeId;
    @HiveField(51)
    @JsonKey(name: "shipping_method_id")
    dynamic shippingMethodId;
    @HiveField(53)
    @JsonKey(name: "shipping_method")
    dynamic shippingMethod;
    @HiveField(55)
    @JsonKey(name: "fk_multicurrency")
    dynamic fkMulticurrency;
    @HiveField(57)
    @JsonKey(name: "multicurrency_code")
    dynamic multicurrencyCode;
    @HiveField(59)
    @JsonKey(name: "multicurrency_tx")
    dynamic multicurrencyTx;
    @HiveField(61)
    @JsonKey(name: "multicurrency_total_ht")
    dynamic multicurrencyTotalHt;
    @HiveField(63)
    @JsonKey(name: "multicurrency_total_tva")
    dynamic multicurrencyTotalTva;
    @HiveField(65)
    @JsonKey(name: "multicurrency_total_ttc")
    dynamic multicurrencyTotalTtc;
    @HiveField(67)
    @JsonKey(name: "multicurrency_total_localtax1")
    dynamic multicurrencyTotalLocaltax1;
    @HiveField(69)
    @JsonKey(name: "multicurrency_total_localtax2")
    dynamic multicurrencyTotalLocaltax2;
    @HiveField(71)
    @JsonKey(name: "last_main_doc")
    dynamic lastMainDoc;
    @HiveField(73)
    @JsonKey(name: "fk_account")
    dynamic fkAccount;
    @HiveField(75)
    @JsonKey(name: "note_public")
    dynamic notePublic;
    @HiveField(77)
    @JsonKey(name: "note_private")
    dynamic notePrivate;
    @HiveField(79)
    @JsonKey(name: "total_ht")
    dynamic totalHt;
    @HiveField(81)
    @JsonKey(name: "total_tva")
    dynamic totalTva;
    @HiveField(83)
    @JsonKey(name: "total_localtax1")
    dynamic totalLocaltax1;
    @HiveField(85)
    @JsonKey(name: "total_localtax2")
    dynamic totalLocaltax2;
    @HiveField(87)
    @JsonKey(name: "total_ttc")
    dynamic totalTtc;
    @HiveField(89)
    @JsonKey(name: "lines")
    List<Line>? lines;
    @HiveField(91)
    @JsonKey(name: "actiontypecode")
    dynamic actiontypecode;
    @HiveField(93)
    @JsonKey(name: "name")
    dynamic name;
    @HiveField(95)
    @JsonKey(name: "lastname")
    dynamic lastname;
    @HiveField(97)
    @JsonKey(name: "firstname")
    dynamic firstname;
    @HiveField(99)
    @JsonKey(name: "civility_id")
    dynamic civilityId;
    @HiveField(101)
    @JsonKey(name: "date_creation")
    dynamic dateCreation;
    @HiveField(103)
    @JsonKey(name: "date_validation")
    dynamic dateValidation;
    @HiveField(105)
    @JsonKey(name: "date_modification")
    dynamic dateModification;
    @HiveField(107)
    @JsonKey(name: "tms")
    dynamic tms;
    @HiveField(109)
    @JsonKey(name: "date_cloture")
    dynamic dateCloture;
    @HiveField(111)
    @JsonKey(name: "user_author")
    dynamic userAuthor;
    @HiveField(113)
    @JsonKey(name: "user_creation")
    dynamic userCreation;
    @HiveField(115)
    @JsonKey(name: "user_creation_id")
    dynamic userCreationId;
    @HiveField(117)
    @JsonKey(name: "user_valid")
    dynamic userValid;
    @HiveField(119)
    @JsonKey(name: "user_validation")
    dynamic userValidation;
    @HiveField(121)
    @JsonKey(name: "user_validation_id")
    dynamic userValidationId;
    @HiveField(123)
    @JsonKey(name: "user_closing_id")
    dynamic userClosingId;
    @HiveField(125)
    @JsonKey(name: "user_modification")
    dynamic userModification;
    @HiveField(127)
    @JsonKey(name: "user_modification_id")
    dynamic userModificationId;
    @HiveField(129)
    @JsonKey(name: "fk_user_creat")
    dynamic fkUserCreat;
    @HiveField(131)
    @JsonKey(name: "fk_user_modif")
    dynamic fkUserModif;
    @HiveField(133)
    @JsonKey(name: "specimen")
    dynamic specimen;
    @HiveField(135)
    @JsonKey(name: "totalpaid")
    dynamic totalpaid;
    @HiveField(137)
    @JsonKey(name: "extraparams")
    Map<String, dynamic>? extraparams;
    @HiveField(139)
    @JsonKey(name: "product")
    dynamic product;
    @HiveField(141)
    @JsonKey(name: "cond_reglement_supplier_id")
    dynamic condReglementSupplierId;
    @HiveField(143)
    @JsonKey(name: "deposit_percent")
    dynamic depositPercent;
    @HiveField(145)
    @JsonKey(name: "retained_warranty_fk_cond_reglement")
    dynamic retainedWarrantyFkCondReglement;
    @HiveField(147)
    @JsonKey(name: "warehouse_id")
    dynamic warehouseId;
    @HiveField(149)
    @JsonKey(name: "title")
    dynamic title;
    @HiveField(151)
    @JsonKey(name: "type")
    dynamic type;
    @HiveField(153)
    @JsonKey(name: "subtype")
    dynamic subtype;
    @HiveField(155)
    @JsonKey(name: "fk_soc")
    dynamic fkSoc;
    @HiveField(157)
    @JsonKey(name: "socid")
    dynamic socid;
    @HiveField(159)
    @JsonKey(name: "paye")
    dynamic paye;
    @HiveField(161)
    @JsonKey(name: "date")
    dynamic date;
    @HiveField(163)
    @JsonKey(name: "date_lim_reglement")
    dynamic dateLimReglement;
    @HiveField(165)
    @JsonKey(name: "cond_reglement_code")
    dynamic condReglementCode;
    @HiveField(167)
    @JsonKey(name: "cond_reglement_label")
    dynamic condReglementLabel;
    @HiveField(169)
    @JsonKey(name: "cond_reglement_doc")
    dynamic condReglementDoc;
    @HiveField(171)
    @JsonKey(name: "mode_reglement_code")
    dynamic modeReglementCode;
    @HiveField(173)
    @JsonKey(name: "revenuestamp")
    dynamic revenuestamp;
    @HiveField(175)
    @JsonKey(name: "totaldeposits")
    dynamic totaldeposits;
    @HiveField(177)
    @JsonKey(name: "totalcreditnotes")
    dynamic totalcreditnotes;
    @HiveField(179)
    @JsonKey(name: "sumpayed")
    dynamic sumpayed;
    @HiveField(181)
    @JsonKey(name: "sumpayed_multicurrency")
    dynamic sumpayedMulticurrency;
    @HiveField(183)
    @JsonKey(name: "sumdeposit")
    dynamic sumdeposit;
    @HiveField(185)
    @JsonKey(name: "sumdeposit_multicurrency")
    dynamic sumdepositMulticurrency;
    @HiveField(187)
    @JsonKey(name: "sumcreditnote")
    dynamic sumcreditnote;
    @HiveField(189)
    @JsonKey(name: "sumcreditnote_multicurrency")
    dynamic sumcreditnoteMulticurrency;
    @HiveField(191)
    @JsonKey(name: "remaintopay")
    dynamic remaintopay;
    @HiveField(193)
    @JsonKey(name: "nbofopendirectdebitorcredittransfer")
    dynamic nbofopendirectdebitorcredittransfer;
    @HiveField(195)
    @JsonKey(name: "description")
    dynamic description;
    @HiveField(197)
    @JsonKey(name: "ref_client")
    dynamic refClient;
    @HiveField(199)
    @JsonKey(name: "situation_cycle_ref")
    dynamic situationCycleRef;
    @HiveField(201)
    @JsonKey(name: "close_code")
    dynamic closeCode;
    @HiveField(203)
    @JsonKey(name: "close_note")
    dynamic closeNote;
    @HiveField(205)
    @JsonKey(name: "postactionmessages")
    dynamic postactionmessages;
    @HiveField(207)
    @JsonKey(name: "fk_incoterms")
    dynamic fkIncoterms;
    @HiveField(209)
    @JsonKey(name: "label_incoterms")
    dynamic labelIncoterms;
    @HiveField(211)
    @JsonKey(name: "location_incoterms")
    dynamic locationIncoterms;
    @HiveField(213)
    @JsonKey(name: "fk_user_author")
    dynamic fkUserAuthor;
    @HiveField(215)
    @JsonKey(name: "fk_user_valid")
    dynamic fkUserValid;
    @HiveField(217)
    @JsonKey(name: "datem")
    dynamic datem;
    @HiveField(219)
    @JsonKey(name: "delivery_date")
    dynamic deliveryDate;
    @HiveField(221)
    @JsonKey(name: "ref_customer")
    dynamic refCustomer;
    @HiveField(223)
    @JsonKey(name: "resteapayer")
    dynamic resteapayer;
    @HiveField(225)
    @JsonKey(name: "module_source")
    dynamic moduleSource;
    @HiveField(227)
    @JsonKey(name: "pos_source")
    dynamic posSource;
    @HiveField(229)
    @JsonKey(name: "fk_fac_rec_source")
    dynamic fkFacRecSource;
    @HiveField(231)
    @JsonKey(name: "fk_facture_source")
    dynamic fkFactureSource;
    @HiveField(233)
    @JsonKey(name: "line")
    Line? line;
    @HiveField(235)
    @JsonKey(name: "fac_rec")
    dynamic facRec;
    @HiveField(237)
    @JsonKey(name: "date_pointoftax")
    dynamic datePointoftax;
    @HiveField(239)
    @JsonKey(name: "situation_counter")
    dynamic situationCounter;
    @HiveField(241)
    @JsonKey(name: "situation_final")
    dynamic situationFinal;
    @HiveField(243)
    @JsonKey(name: "tab_previous_situation_invoice")
    List<dynamic>? tabPreviousSituationInvoice;
    @HiveField(245)
    @JsonKey(name: "tab_next_situation_invoice")
    List<dynamic>? tabNextSituationInvoice;
    @HiveField(247)
    @JsonKey(name: "retained_warranty")
    dynamic retainedWarranty;
    @HiveField(249)
    @JsonKey(name: "retained_warranty_date_limit")
    dynamic retainedWarrantyDateLimit;
    @HiveField(251)
    @JsonKey(name: "date_closing")
    dynamic dateClosing;
    @HiveField(253)
    @JsonKey(name: "remise_percent")
    dynamic remisePercent;

    InvoiceModel({
        this.module,
        this.id,
        this.entity,
        this.importKey,
        this.arrayOptions,
        this.arrayLanguages,
        this.contactsIds,
        this.linkedObjectsIds,
        this.fkProject,
        this.contactId,
        this.user,
        this.originType,
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
        this.fkMulticurrency,
        this.multicurrencyCode,
        this.multicurrencyTx,
        this.multicurrencyTotalHt,
        this.multicurrencyTotalTva,
        this.multicurrencyTotalTtc,
        this.multicurrencyTotalLocaltax1,
        this.multicurrencyTotalLocaltax2,
        this.lastMainDoc,
        this.fkAccount,
        this.notePublic,
        this.notePrivate,
        this.totalHt,
        this.totalTva,
        this.totalLocaltax1,
        this.totalLocaltax2,
        this.totalTtc,
        this.lines,
        this.actiontypecode,
        this.name,
        this.lastname,
        this.firstname,
        this.civilityId,
        this.dateCreation,
        this.dateValidation,
        this.dateModification,
        this.tms,
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
        this.fkUserCreat,
        this.fkUserModif,
        this.specimen,
        this.totalpaid,
        this.extraparams,
        this.product,
        this.condReglementSupplierId,
        this.depositPercent,
        this.retainedWarrantyFkCondReglement,
        this.warehouseId,
        this.title,
        this.type,
        this.subtype,
        this.fkSoc,
        this.socid,
        this.paye,
        this.date,
        this.dateLimReglement,
        this.condReglementCode,
        this.condReglementLabel,
        this.condReglementDoc,
        this.modeReglementCode,
        this.revenuestamp,
        this.totaldeposits,
        this.totalcreditnotes,
        this.sumpayed,
        this.sumpayedMulticurrency,
        this.sumdeposit,
        this.sumdepositMulticurrency,
        this.sumcreditnote,
        this.sumcreditnoteMulticurrency,
        this.remaintopay,
        this.nbofopendirectdebitorcredittransfer,
        this.description,
        this.refClient,
        this.situationCycleRef,
        this.closeCode,
        this.closeNote,
        this.postactionmessages,
        this.fkIncoterms,
        this.labelIncoterms,
        this.locationIncoterms,
        this.fkUserAuthor,
        this.fkUserValid,
        this.datem,
        this.deliveryDate,
        this.refCustomer,
        this.resteapayer,
        this.moduleSource,
        this.posSource,
        this.fkFacRecSource,
        this.fkFactureSource,
        this.line,
        this.facRec,
        this.datePointoftax,
        this.situationCounter,
        this.situationFinal,
        this.tabPreviousSituationInvoice,
        this.tabNextSituationInvoice,
        this.retainedWarranty,
        this.retainedWarrantyDateLimit,
        this.dateClosing,
        this.remisePercent,
    });

    factory InvoiceModel.fromJson(Map<String, dynamic> json) {
      return InvoiceModel(
        module: json['module'],
        id: json['id'],
        entity: json['entity'],
        importKey: json['import_key'],
        arrayOptions: json['array_options'] != null
            ? List<dynamic>.from(json['array_options'])
            : null,
        arrayLanguages: json['array_languages'],
        contactsIds: json['contacts_ids'] != null
            ? List<dynamic>.from(json['contacts_ids'])
            : null,
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
        lines: json['lines'] != null
            ? List<Line>.from(json['lines'].map((x) => Line.fromJson(x)))
            : null,
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
        extraparams: json['extraparams'] is Map<String, dynamic>
            ? Map<String, dynamic>.from(json['extraparams'])
            : null,
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
        line: json['line'] != null ? Line.fromJson(json['line']) : null,
        facRec: json['fac_rec'],
        datePointoftax: json['date_pointoftax'],
        situationCounter: json['situation_counter'],
        situationFinal: json['situation_final'],
        tabPreviousSituationInvoice: json['tab_previous_situation_invoice'] != null
            ? List<dynamic>.from(json['tab_previous_situation_invoice'])
            : null,
        tabNextSituationInvoice: json['tab_next_situation_invoice'] != null
            ? List<dynamic>.from(json['tab_next_situation_invoice'])
            : null,
        retainedWarranty: json['retained_warranty'],
        retainedWarrantyDateLimit: json['retained_warranty_date_limit'],
        dateClosing: json['date_closing'],
        remisePercent: json['remise_percent'],
      );
    }

    Map<String, dynamic> toJson() => _$InvoiceModelToJson(this);
}

@HiveType(typeId: 2)
@JsonSerializable()
class Line {
    @HiveField(1)
    @JsonKey(name: "module")
    dynamic module;
    @HiveField(3)
    @JsonKey(name: "id")
    dynamic id;
    @HiveField(5)
    @JsonKey(name: "entity")
    dynamic entity;
    @HiveField(7)
    @JsonKey(name: "import_key")
    dynamic importKey;
    @HiveField(9)
    @JsonKey(name: "array_options")
    List<dynamic>? arrayOptions;
    @HiveField(11)
    @JsonKey(name: "array_languages")
    dynamic arrayLanguages;
    @HiveField(13)
    @JsonKey(name: "contacts_ids")
    dynamic contactsIds;
    @HiveField(15)
    @JsonKey(name: "linkedObjectsIds")
    dynamic linkedObjectsIds;
    @HiveField(17)
    @JsonKey(name: "origin_type")
    dynamic originType;
    @HiveField(19)
    @JsonKey(name: "origin_id")
    dynamic originId;
    @HiveField(21)
    @JsonKey(name: "ref")
    dynamic ref;
    @HiveField(23)
    @JsonKey(name: "ref_ext")
    dynamic refExt;
    @HiveField(25)
    @JsonKey(name: "statut")
    dynamic statut;
    @HiveField(27)
    @JsonKey(name: "status")
    dynamic status;
    @HiveField(29)
    @JsonKey(name: "state_id")
    dynamic stateId;
    @HiveField(31)
    @JsonKey(name: "region_id")
    dynamic regionId;
    @HiveField(33)
    @JsonKey(name: "demand_reason_id")
    dynamic demandReasonId;
    @HiveField(35)
    @JsonKey(name: "transport_mode_id")
    dynamic transportModeId;
    @HiveField(37)
    @JsonKey(name: "shipping_method")
    dynamic shippingMethod;
    @HiveField(39)
    @JsonKey(name: "multicurrency_tx")
    dynamic multicurrencyTx;
    @HiveField(41)
    @JsonKey(name: "multicurrency_total_ht")
    dynamic multicurrencyTotalHt;
    @HiveField(43)
    @JsonKey(name: "multicurrency_total_tva")
    dynamic multicurrencyTotalTva;
    @HiveField(45)
    @JsonKey(name: "multicurrency_total_ttc")
    dynamic multicurrencyTotalTtc;
    @HiveField(47)
    @JsonKey(name: "multicurrency_total_localtax1")
    dynamic multicurrencyTotalLocaltax1;
    @HiveField(49)
    @JsonKey(name: "multicurrency_total_localtax2")
    dynamic multicurrencyTotalLocaltax2;
    @HiveField(51)
    @JsonKey(name: "last_main_doc")
    dynamic lastMainDoc;
    @HiveField(53)
    @JsonKey(name: "fk_account")
    dynamic fkAccount;
    @HiveField(55)
    @JsonKey(name: "total_ht")
    dynamic totalHt;
    @HiveField(57)
    @JsonKey(name: "total_tva")
    dynamic totalTva;
    @HiveField(59)
    @JsonKey(name: "total_localtax1")
    dynamic totalLocaltax1;
    @HiveField(61)
    @JsonKey(name: "total_localtax2")
    dynamic totalLocaltax2;
    @HiveField(63)
    @JsonKey(name: "total_ttc")
    dynamic totalTtc;
    @HiveField(65)
    @JsonKey(name: "lines")
    List<Line>? lines;
    @HiveField(67)
    @JsonKey(name: "actiontypecode")
    dynamic actiontypecode;
    @HiveField(69)
    @JsonKey(name: "date_creation")
    dynamic dateCreation;
    @HiveField(71)
    @JsonKey(name: "date_validation")
    dynamic dateValidation;
    @HiveField(73)
    @JsonKey(name: "date_modification")
    dynamic dateModification;
    @HiveField(75)
    @JsonKey(name: "tms")
    dynamic tms;
    @HiveField(77)
    @JsonKey(name: "date_cloture")
    dynamic dateCloture;
    @HiveField(79)
    @JsonKey(name: "user_author")
    dynamic userAuthor;
    @HiveField(81)
    @JsonKey(name: "user_creation")
    dynamic userCreation;
    @HiveField(83)
    @JsonKey(name: "user_creation_id")
    dynamic userCreationId;
    @HiveField(85)
    @JsonKey(name: "user_valid")
    dynamic userValid;
    @HiveField(87)
    @JsonKey(name: "user_validation")
    dynamic userValidation;
    @HiveField(89)
    @JsonKey(name: "user_validation_id")
    dynamic userValidationId;
    @HiveField(91)
    @JsonKey(name: "user_closing_id")
    dynamic userClosingId;
    @HiveField(93)
    @JsonKey(name: "user_modification")
    dynamic userModification;
    @HiveField(95)
    @JsonKey(name: "user_modification_id")
    dynamic userModificationId;
    @HiveField(97)
    @JsonKey(name: "fk_user_creat")
    dynamic fkUserCreat;
    @HiveField(99)
    @JsonKey(name: "fk_user_modif")
    dynamic fkUserModif;
    @HiveField(101)
    @JsonKey(name: "specimen")
    dynamic specimen;
    @HiveField(103)
    @JsonKey(name: "totalpaid")
    dynamic totalpaid;
    @HiveField(105)
    @JsonKey(name: "extraparams")
    List<dynamic>? extraparams;
    @HiveField(107)
    @JsonKey(name: "product")
    dynamic product;
    @HiveField(109)
    @JsonKey(name: "cond_reglement_supplier_id")
    dynamic condReglementSupplierId;
    @HiveField(111)
    @JsonKey(name: "deposit_percent")
    dynamic depositPercent;
    @HiveField(113)
    @JsonKey(name: "retained_warranty_fk_cond_reglement")
    dynamic retainedWarrantyFkCondReglement;
    @HiveField(115)
    @JsonKey(name: "warehouse_id")
    dynamic warehouseId;
    @HiveField(117)
    @JsonKey(name: "parent_element")
    dynamic parentElement;
    @HiveField(119)
    @JsonKey(name: "fk_parent_attribute")
    dynamic fkParentAttribute;
    @HiveField(121)
    @JsonKey(name: "rowid")
    dynamic rowid;
    @HiveField(123)
    @JsonKey(name: "fk_unit")
    dynamic fkUnit;
    @HiveField(125)
    @JsonKey(name: "date_debut_prevue")
    dynamic dateDebutPrevue;
    @HiveField(127)
    @JsonKey(name: "date_debut_reel")
    dynamic dateDebutReel;
    @HiveField(129)
    @JsonKey(name: "date_fin_prevue")
    dynamic dateFinPrevue;
    @HiveField(131)
    @JsonKey(name: "date_fin_reel")
    dynamic dateFinReel;
    @HiveField(133)
    @JsonKey(name: "weight")
    dynamic weight;
    @HiveField(135)
    @JsonKey(name: "weight_units")
    dynamic weightUnits;
    @HiveField(137)
    @JsonKey(name: "length")
    dynamic length;
    @HiveField(139)
    @JsonKey(name: "length_units")
    dynamic lengthUnits;
    @HiveField(141)
    @JsonKey(name: "width")
    dynamic width;
    @HiveField(143)
    @JsonKey(name: "width_units")
    dynamic widthUnits;
    @HiveField(145)
    @JsonKey(name: "height")
    dynamic height;
    @HiveField(147)
    @JsonKey(name: "height_units")
    dynamic heightUnits;
    @HiveField(149)
    @JsonKey(name: "surface")
    dynamic surface;
    @HiveField(151)
    @JsonKey(name: "surface_units")
    dynamic surfaceUnits;
    @HiveField(153)
    @JsonKey(name: "volume")
    dynamic volume;
    @HiveField(155)
    @JsonKey(name: "volume_units")
    dynamic volumeUnits;
    @HiveField(157)
    @JsonKey(name: "multilangs")
    dynamic multilangs;
    @HiveField(159)
    @JsonKey(name: "product_type")
    dynamic productType;
    @HiveField(161)
    @JsonKey(name: "fk_product")
    dynamic fkProduct;
    @HiveField(163)
    @JsonKey(name: "desc")
    dynamic desc;
    @HiveField(165)
    @JsonKey(name: "description")
    dynamic description;
    @HiveField(167)
    @JsonKey(name: "product_ref")
    dynamic productRef;
    @HiveField(169)
    @JsonKey(name: "product_label")
    dynamic productLabel;
    @HiveField(171)
    @JsonKey(name: "product_barcode")
    dynamic productBarcode;
    @HiveField(173)
    @JsonKey(name: "product_desc")
    dynamic productDesc;
    @HiveField(175)
    @JsonKey(name: "fk_product_type")
    dynamic fkProductType;
    @HiveField(177)
    @JsonKey(name: "qty")
    dynamic qty;
    @HiveField(179)
    @JsonKey(name: "duree")
    dynamic duree;
    @HiveField(181)
    @JsonKey(name: "remise_percent")
    dynamic remisePercent;
    @HiveField(183)
    @JsonKey(name: "info_bits")
    dynamic infoBits;
    @HiveField(185)
    @JsonKey(name: "special_code")
    dynamic specialCode;
    @HiveField(187)
    @JsonKey(name: "subprice")
    dynamic subprice;
    @HiveField(189)
    @JsonKey(name: "tva_tx")
    dynamic tvaTx;
    @HiveField(191)
    @JsonKey(name: "multicurrency_subprice")
    dynamic multicurrencySubprice;
    @HiveField(193)
    @JsonKey(name: "label")
    dynamic label;
    @HiveField(195)
    @JsonKey(name: "libelle")
    dynamic libelle;
    @HiveField(197)
    @JsonKey(name: "price")
    dynamic price;
    @HiveField(199)
    @JsonKey(name: "vat_src_code")
    dynamic vatSrcCode;
    @HiveField(201)
    @JsonKey(name: "localtax1_tx")
    dynamic localtax1Tx;
    @HiveField(203)
    @JsonKey(name: "localtax2_tx")
    dynamic localtax2Tx;
    @HiveField(205)
    @JsonKey(name: "localtax1_type")
    dynamic localtax1Type;
    @HiveField(207)
    @JsonKey(name: "localtax2_type")
    dynamic localtax2Type;
    @HiveField(209)
    @JsonKey(name: "remise")
    dynamic remise;
    @HiveField(211)
    @JsonKey(name: "date_start_fill")
    dynamic dateStartFill;
    @HiveField(213)
    @JsonKey(name: "date_end_fill")
    dynamic dateEndFill;
    @HiveField(215)
    @JsonKey(name: "buy_price_ht")
    dynamic buyPriceHt;
    @HiveField(217)
    @JsonKey(name: "buyprice")
    dynamic buyprice;
    @HiveField(219)
    @JsonKey(name: "pa_ht")
    dynamic paHt;
    @HiveField(221)
    @JsonKey(name: "marge_tx")
    dynamic margeTx;
    @HiveField(223)
    @JsonKey(name: "marque_tx")
    dynamic marqueTx;
    @HiveField(225)
    @JsonKey(name: "fk_user_author")
    dynamic fkUserAuthor;
    @HiveField(227)
    @JsonKey(name: "fk_accounting_account")
    dynamic fkAccountingAccount;
    @HiveField(229)
    @JsonKey(name: "fk_facture")
    dynamic fkFacture;
    @HiveField(231)
    @JsonKey(name: "fk_parent_line")
    dynamic fkParentLine;
    @HiveField(233)
    @JsonKey(name: "fk_remise_except")
    dynamic fkRemiseExcept;
    @HiveField(235)
    @JsonKey(name: "rang")
    dynamic rang;
    @HiveField(237)
    @JsonKey(name: "fk_fournprice")
    dynamic fkFournprice;
    @HiveField(239)
    @JsonKey(name: "tva_npr")
    dynamic tvaNpr;
    @HiveField(241)
    @JsonKey(name: "batch")
    dynamic batch;
    @HiveField(243)
    @JsonKey(name: "fk_warehouse")
    dynamic fkWarehouse;
    @HiveField(245)
    @JsonKey(name: "fk_code_ventilation")
    dynamic fkCodeVentilation;
    @HiveField(247)
    @JsonKey(name: "date_start")
    dynamic dateStart;
    @HiveField(249)
    @JsonKey(name: "date_end")
    dynamic dateEnd;
    @HiveField(251)
    @JsonKey(name: "situation_percent")
    dynamic situationPercent;
    @HiveField(253)
    @JsonKey(name: "fk_prev_id")
    dynamic fkPrevId;

    Line({
        this.module,
        this.id,
        this.entity,
        this.importKey,
        this.arrayOptions,
        this.arrayLanguages,
        this.contactsIds,
        this.linkedObjectsIds,
        this.originType,
        this.originId,
        this.ref,
        this.refExt,
        this.statut,
        this.status,
        this.stateId,
        this.regionId,
        this.demandReasonId,
        this.transportModeId,
        this.shippingMethod,
        this.multicurrencyTx,
        this.multicurrencyTotalHt,
        this.multicurrencyTotalTva,
        this.multicurrencyTotalTtc,
        this.multicurrencyTotalLocaltax1,
        this.multicurrencyTotalLocaltax2,
        this.lastMainDoc,
        this.fkAccount,
        this.totalHt,
        this.totalTva,
        this.totalLocaltax1,
        this.totalLocaltax2,
        this.totalTtc,
        this.lines,
        this.actiontypecode,
        this.dateCreation,
        this.dateValidation,
        this.dateModification,
        this.tms,
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
        this.fkUserCreat,
        this.fkUserModif,
        this.specimen,
        this.totalpaid,
        this.extraparams,
        this.product,
        this.condReglementSupplierId,
        this.depositPercent,
        this.retainedWarrantyFkCondReglement,
        this.warehouseId,
        this.parentElement,
        this.fkParentAttribute,
        this.rowid,
        this.fkUnit,
        this.dateDebutPrevue,
        this.dateDebutReel,
        this.dateFinPrevue,
        this.dateFinReel,
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
        this.multilangs,
        this.productType,
        this.fkProduct,
        this.desc,
        this.description,
        this.productRef,
        this.productLabel,
        this.productBarcode,
        this.productDesc,
        this.fkProductType,
        this.qty,
        this.duree,
        this.remisePercent,
        this.infoBits,
        this.specialCode,
        this.subprice,
        this.tvaTx,
        this.multicurrencySubprice,
        this.label,
        this.libelle,
        this.price,
        this.vatSrcCode,
        this.localtax1Tx,
        this.localtax2Tx,
        this.localtax1Type,
        this.localtax2Type,
        this.remise,
        this.dateStartFill,
        this.dateEndFill,
        this.buyPriceHt,
        this.buyprice,
        this.paHt,
        this.margeTx,
        this.marqueTx,
        this.fkUserAuthor,
        this.fkAccountingAccount,
        this.fkFacture,
        this.fkParentLine,
        this.fkRemiseExcept,
        this.rang,
        this.fkFournprice,
        this.tvaNpr,
        this.batch,
        this.fkWarehouse,
        this.fkCodeVentilation,
        this.dateStart,
        this.dateEnd,
        this.situationPercent,
        this.fkPrevId,
    });

    factory Line.fromJson(Map<String, dynamic> json) => _$LineFromJson(json);

    Map<String, dynamic> toJson() => _$LineToJson(this);
}
