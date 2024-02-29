// To parse this JSON data, do
//
//     final invoiceById = invoiceByIdFromMap(jsonString);

import 'dart:convert';

InvoiceById invoiceByIdFromMap(String str) =>
    InvoiceById.fromMap(json.decode(str));

String invoiceByIdToMap(InvoiceById data) => json.encode(data.toMap());

class InvoiceById {
  dynamic brouillon;
  dynamic socid;
  dynamic userAuthor;
  dynamic fkUserAuthor;
  dynamic userValid;
  dynamic fkUserValid;
  dynamic userModification;
  dynamic fkUserModif;
  dynamic date;
  dynamic datem;
  dynamic dateLivraison;
  dynamic deliveryDate;
  dynamic refClient;
  dynamic refCustomer;
  dynamic remiseAbsolue;
  dynamic remisePercent;
  dynamic totalHt;
  dynamic totalTva;
  dynamic totalLocaltax1;
  dynamic totalLocaltax2;
  dynamic totalTtc;
  dynamic revenuestamp;
  dynamic resteapayer;
  dynamic closeCode;
  dynamic closeNote;
  dynamic paye;
  dynamic moduleSource;
  dynamic posSource;
  dynamic fkFacRecSource;
  dynamic fkFactureSource;
  List<dynamic>? linkedObjects;
  dynamic dateLimReglement;
  dynamic condReglementCode;
  dynamic condReglementDoc;
  dynamic modeReglementCode;
  dynamic fkBank;
  List<Line>? lines;
  dynamic line;
  List<dynamic>? extraparams;
  dynamic facRec;
  dynamic datePointoftax;
  dynamic fkMulticurrency;
  dynamic multicurrencyCode;
  dynamic multicurrencyTx;
  dynamic multicurrencyTotalHt;
  dynamic multicurrencyTotalTva;
  dynamic multicurrencyTotalTtc;
  dynamic situationCycleRef;
  dynamic situationCounter;
  dynamic situationFinal;
  List<dynamic>? tabPreviousSituationInvoice;
  List<dynamic>? tabNextSituationInvoice;
  dynamic retainedWarranty;
  dynamic retainedWarrantyDateLimit;
  dynamic retainedWarrantyFkCondReglement;
  dynamic type;
  dynamic subtype;
  dynamic totalpaid;
  dynamic totaldeposits;
  dynamic totalcreditnotes;
  dynamic sumpayed;
  dynamic sumpayedMulticurrency;
  dynamic sumdeposit;
  dynamic sumdepositMulticurrency;
  dynamic sumcreditnote;
  dynamic sumcreditnoteMulticurrency;
  dynamic remaintopay;
  dynamic module;
  dynamic id;
  dynamic entity;
  dynamic importKey;
  List<dynamic>? arrayOptions;
  dynamic arrayLanguages;
  List<dynamic>? contactsIds;
  List<dynamic>? linkedObjectsIds;
  dynamic oldref;
  dynamic fkProject;
  dynamic contactId;
  dynamic user;
  dynamic origin;
  dynamic originId;
  dynamic ref;
  dynamic refExt;
  dynamic statut;
  dynamic status;
  dynamic countryId;
  dynamic countryCode;
  dynamic stateId;
  dynamic regionId;
  dynamic modeReglementId;
  dynamic condReglementId;
  dynamic demandReasonId;
  dynamic transportModeId;
  dynamic shippingMethodId;
  dynamic shippingMethod;
  dynamic modelPdf;
  dynamic lastMainDoc;
  dynamic fkAccount;
  dynamic notePublic;
  dynamic notePrivate;
  dynamic name;
  dynamic lastname;
  dynamic firstname;
  dynamic civilityId;
  dynamic dateCreation;
  dynamic dateValidation;
  dynamic dateModification;
  dynamic dateUpdate;
  dynamic dateCloture;
  dynamic userCreation;
  dynamic userCreationId;
  dynamic userValidation;
  dynamic userValidationId;
  dynamic userClosingId;
  dynamic userModificationId;
  dynamic specimen;
  dynamic labelStatus;
  dynamic showphotoOnPopup;
  List<dynamic>? nb;
  dynamic output;
  dynamic fkIncoterms;
  dynamic labelIncoterms;
  dynamic locationIncoterms;
  dynamic nom;

  InvoiceById({
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

  factory InvoiceById.fromMap(Map<String, dynamic> json) => InvoiceById(
        brouillon: json["brouillon"],
        socid: json["socid"],
        userAuthor: json["user_author"],
        fkUserAuthor: json["fk_user_author"],
        userValid: json["user_valid"],
        fkUserValid: json["fk_user_valid"],
        userModification: json["user_modification"],
        fkUserModif: json["fk_user_modif"],
        date: json["date"],
        datem: json["datem"],
        dateLivraison: json["date_livraison"],
        deliveryDate: json["delivery_date"],
        refClient: json["ref_client"],
        refCustomer: json["ref_customer"],
        remiseAbsolue: json["remise_absolue"],
        remisePercent: json["remise_percent"],
        totalHt: json["total_ht"],
        totalTva: json["total_tva"],
        totalLocaltax1: json["total_localtax1"],
        totalLocaltax2: json["total_localtax2"],
        totalTtc: json["total_ttc"],
        revenuestamp: json["revenuestamp"],
        resteapayer: json["resteapayer"],
        closeCode: json["close_code"],
        closeNote: json["close_note"],
        paye: json["paye"],
        moduleSource: json["module_source"],
        posSource: json["pos_source"],
        fkFacRecSource: json["fk_fac_rec_source"],
        fkFactureSource: json["fk_facture_source"],
        linkedObjects: json["linked_objects"] == null
            ? []
            : List<dynamic>.from(json["linked_objects"]!.map((x) => x)),
        dateLimReglement: json["date_lim_reglement"],
        condReglementCode: json["cond_reglement_code"],
        condReglementDoc: json["cond_reglement_doc"],
        modeReglementCode: json["mode_reglement_code"],
        fkBank: json["fk_bank"],
        lines: json["lines"] == null
            ? []
            : List<Line>.from(json["lines"]!.map((x) => Line.fromMap(x))),
        line: json["line"],
        extraparams: json["extraparams"] == null
            ? []
            : List<dynamic>.from(json["extraparams"]!.map((x) => x)),
        facRec: json["fac_rec"],
        datePointoftax: json["date_pointoftax"],
        fkMulticurrency: json["fk_multicurrency"],
        multicurrencyCode: json["multicurrency_code"],
        multicurrencyTx: json["multicurrency_tx"],
        multicurrencyTotalHt: json["multicurrency_total_ht"],
        multicurrencyTotalTva: json["multicurrency_total_tva"],
        multicurrencyTotalTtc: json["multicurrency_total_ttc"],
        situationCycleRef: json["situation_cycle_ref"],
        situationCounter: json["situation_counter"],
        situationFinal: json["situation_final"],
        tabPreviousSituationInvoice:
            json["tab_previous_situation_invoice"] == null
                ? []
                : List<dynamic>.from(
                    json["tab_previous_situation_invoice"]!.map((x) => x)),
        tabNextSituationInvoice: json["tab_next_situation_invoice"] == null
            ? []
            : List<dynamic>.from(
                json["tab_next_situation_invoice"]!.map((x) => x)),
        retainedWarranty: json["retained_warranty"],
        retainedWarrantyDateLimit: json["retained_warranty_date_limit"],
        retainedWarrantyFkCondReglement:
            json["retained_warranty_fk_cond_reglement"],
        type: json["type"],
        subtype: json["subtype"],
        totalpaid: json["totalpaid"],
        totaldeposits: json["totaldeposits"],
        totalcreditnotes: json["totalcreditnotes"],
        sumpayed: json["sumpayed"],
        sumpayedMulticurrency: json["sumpayed_multicurrency"],
        sumdeposit: json["sumdeposit"],
        sumdepositMulticurrency: json["sumdeposit_multicurrency"],
        sumcreditnote: json["sumcreditnote"],
        sumcreditnoteMulticurrency: json["sumcreditnote_multicurrency"],
        remaintopay: json["remaintopay"],
        module: json["module"],
        id: json["id"],
        entity: json["entity"],
        importKey: json["import_key"],
        arrayOptions: json["array_options"] == null
            ? []
            : List<dynamic>.from(json["array_options"]!.map((x) => x)),
        arrayLanguages: json["array_languages"],
        contactsIds: json["contacts_ids"] == null
            ? []
            : List<dynamic>.from(json["contacts_ids"]!.map((x) => x)),
        linkedObjectsIds: json["linkedObjectsIds"] == null
            ? []
            : List<dynamic>.from(json["linkedObjectsIds"]!.map((x) => x)),
        oldref: json["oldref"],
        fkProject: json["fk_project"],
        contactId: json["contact_id"],
        user: json["user"],
        origin: json["origin"],
        originId: json["origin_id"],
        ref: json["ref"],
        refExt: json["ref_ext"],
        statut: json["statut"],
        status: json["status"],
        countryId: json["country_id"],
        countryCode: json["country_code"],
        stateId: json["state_id"],
        regionId: json["region_id"],
        modeReglementId: json["mode_reglement_id"],
        condReglementId: json["cond_reglement_id"],
        demandReasonId: json["demand_reason_id"],
        transportModeId: json["transport_mode_id"],
        shippingMethodId: json["shipping_method_id"],
        shippingMethod: json["shipping_method"],
        modelPdf: json["model_pdf"],
        lastMainDoc: json["last_main_doc"],
        fkAccount: json["fk_account"],
        notePublic: json["note_public"],
        notePrivate: json["note_private"],
        name: json["name"],
        lastname: json["lastname"],
        firstname: json["firstname"],
        civilityId: json["civility_id"],
        dateCreation: json["date_creation"],
        dateValidation: json["date_validation"],
        dateModification: json["date_modification"],
        dateUpdate: json["date_update"],
        dateCloture: json["date_cloture"],
        userCreation: json["user_creation"],
        userCreationId: json["user_creation_id"],
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
        fkIncoterms: json["fk_incoterms"],
        labelIncoterms: json["label_incoterms"],
        locationIncoterms: json["location_incoterms"],
        nom: json["nom"],
      );

  Map<String, dynamic> toMap() => {
        "brouillon": brouillon,
        "socid": socid,
        "user_author": userAuthor,
        "fk_user_author": fkUserAuthor,
        "user_valid": userValid,
        "fk_user_valid": fkUserValid,
        "user_modification": userModification,
        "fk_user_modif": fkUserModif,
        "date": date,
        "datem": datem,
        "date_livraison": dateLivraison,
        "delivery_date": deliveryDate,
        "ref_client": refClient,
        "ref_customer": refCustomer,
        "remise_absolue": remiseAbsolue,
        "remise_percent": remisePercent,
        "total_ht": totalHt,
        "total_tva": totalTva,
        "total_localtax1": totalLocaltax1,
        "total_localtax2": totalLocaltax2,
        "total_ttc": totalTtc,
        "revenuestamp": revenuestamp,
        "resteapayer": resteapayer,
        "close_code": closeCode,
        "close_note": closeNote,
        "paye": paye,
        "module_source": moduleSource,
        "pos_source": posSource,
        "fk_fac_rec_source": fkFacRecSource,
        "fk_facture_source": fkFactureSource,
        "linked_objects": linkedObjects == null
            ? []
            : List<dynamic>.from(linkedObjects!.map((x) => x)),
        "date_lim_reglement": dateLimReglement,
        "cond_reglement_code": condReglementCode,
        "cond_reglement_doc": condReglementDoc,
        "mode_reglement_code": modeReglementCode,
        "fk_bank": fkBank,
        "lines": lines == null
            ? []
            : List<dynamic>.from(lines!.map((x) => x.toMap())),
        "line": line,
        "extraparams": extraparams == null
            ? []
            : List<dynamic>.from(extraparams!.map((x) => x)),
        "fac_rec": facRec,
        "date_pointoftax": datePointoftax,
        "fk_multicurrency": fkMulticurrency,
        "multicurrency_code": multicurrencyCode,
        "multicurrency_tx": multicurrencyTx,
        "multicurrency_total_ht": multicurrencyTotalHt,
        "multicurrency_total_tva": multicurrencyTotalTva,
        "multicurrency_total_ttc": multicurrencyTotalTtc,
        "situation_cycle_ref": situationCycleRef,
        "situation_counter": situationCounter,
        "situation_final": situationFinal,
        "tab_previous_situation_invoice": tabPreviousSituationInvoice == null
            ? []
            : List<dynamic>.from(tabPreviousSituationInvoice!.map((x) => x)),
        "tab_next_situation_invoice": tabNextSituationInvoice == null
            ? []
            : List<dynamic>.from(tabNextSituationInvoice!.map((x) => x)),
        "retained_warranty": retainedWarranty,
        "retained_warranty_date_limit": retainedWarrantyDateLimit,
        "retained_warranty_fk_cond_reglement": retainedWarrantyFkCondReglement,
        "type": type,
        "subtype": subtype,
        "totalpaid": totalpaid,
        "totaldeposits": totaldeposits,
        "totalcreditnotes": totalcreditnotes,
        "sumpayed": sumpayed,
        "sumpayed_multicurrency": sumpayedMulticurrency,
        "sumdeposit": sumdeposit,
        "sumdeposit_multicurrency": sumdepositMulticurrency,
        "sumcreditnote": sumcreditnote,
        "sumcreditnote_multicurrency": sumcreditnoteMulticurrency,
        "remaintopay": remaintopay,
        "module": module,
        "id": id,
        "entity": entity,
        "import_key": importKey,
        "array_options": arrayOptions == null
            ? []
            : List<dynamic>.from(arrayOptions!.map((x) => x)),
        "array_languages": arrayLanguages,
        "contacts_ids": contactsIds == null
            ? []
            : List<dynamic>.from(contactsIds!.map((x) => x)),
        "linkedObjectsIds": linkedObjectsIds == null
            ? []
            : List<dynamic>.from(linkedObjectsIds!.map((x) => x)),
        "oldref": oldref,
        "fk_project": fkProject,
        "contact_id": contactId,
        "user": user,
        "origin": origin,
        "origin_id": originId,
        "ref": ref,
        "ref_ext": refExt,
        "statut": statut,
        "status": status,
        "country_id": countryId,
        "country_code": countryCode,
        "state_id": stateId,
        "region_id": regionId,
        "mode_reglement_id": modeReglementId,
        "cond_reglement_id": condReglementId,
        "demand_reason_id": demandReasonId,
        "transport_mode_id": transportModeId,
        "shipping_method_id": shippingMethodId,
        "shipping_method": shippingMethod,
        "model_pdf": modelPdf,
        "last_main_doc": lastMainDoc,
        "fk_account": fkAccount,
        "note_public": notePublic,
        "note_private": notePrivate,
        "name": name,
        "lastname": lastname,
        "firstname": firstname,
        "civility_id": civilityId,
        "date_creation": dateCreation,
        "date_validation": dateValidation,
        "date_modification": dateModification,
        "date_update": dateUpdate,
        "date_cloture": dateCloture,
        "user_creation": userCreation,
        "user_creation_id": userCreationId,
        "user_validation": userValidation,
        "user_validation_id": userValidationId,
        "user_closing_id": userClosingId,
        "user_modification_id": userModificationId,
        "specimen": specimen,
        "labelStatus": labelStatus,
        "showphoto_on_popup": showphotoOnPopup,
        "nb": nb == null ? [] : List<dynamic>.from(nb!.map((x) => x)),
        "output": output,
        "fk_incoterms": fkIncoterms,
        "label_incoterms": labelIncoterms,
        "location_incoterms": locationIncoterms,
        "nom": nom,
      };
}

class Line {
  dynamic fkFacture;
  dynamic fkParentLine;
  dynamic desc;
  dynamic refExt;
  dynamic localtax1Type;
  dynamic localtax2Type;
  dynamic fkRemiseExcept;
  dynamic rang;
  dynamic fkFournprice;
  dynamic paHt;
  dynamic margeTx;
  dynamic marqueTx;
  dynamic remisePercent;
  dynamic specialCode;
  dynamic origin;
  dynamic originId;
  dynamic fkCodeVentilation;
  dynamic dateStart;
  dynamic dateEnd;
  dynamic situationPercent;
  dynamic fkPrevId;
  dynamic multicurrencySubprice;
  dynamic multicurrencyTotalHt;
  dynamic multicurrencyTotalTva;
  dynamic multicurrencyTotalTtc;
  dynamic label;
  dynamic ref;
  dynamic libelle;
  dynamic productType;
  dynamic productRef;
  dynamic productLabel;
  dynamic productDesc;
  dynamic qty;
  dynamic subprice;
  dynamic price;
  dynamic fkProduct;
  dynamic vatSrcCode;
  dynamic tvaTx;
  dynamic localtax1Tx;
  dynamic localtax2Tx;
  dynamic remise;
  dynamic totalHt;
  dynamic totalTva;
  dynamic totalLocaltax1;
  dynamic totalLocaltax2;
  dynamic totalTtc;
  dynamic dateStartFill;
  dynamic dateEndFill;
  dynamic buyPriceHt;
  dynamic buyprice;
  dynamic infoBits;
  dynamic fkUserAuthor;
  dynamic fkUserModif;
  dynamic fkAccountingAccount;
  dynamic id;
  dynamic rowid;
  dynamic fkUnit;
  dynamic dateDebutPrevue;
  dynamic dateDebutReel;
  dynamic dateFinPrevue;
  dynamic dateFinReel;
  dynamic weight;
  dynamic weightUnits;
  dynamic width;
  dynamic widthUnits;
  dynamic height;
  dynamic heightUnits;
  dynamic length;
  dynamic lengthUnits;
  dynamic surface;
  dynamic surfaceUnits;
  dynamic volume;
  dynamic volumeUnits;
  dynamic multilangs;
  dynamic description;
  dynamic product;
  dynamic productBarcode;
  dynamic fkProductType;
  dynamic duree;
  dynamic module;
  dynamic entity;
  dynamic importKey;
  List<dynamic>? arrayOptions;
  dynamic arrayLanguages;
  dynamic contactsIds;
  dynamic linkedObjects;
  dynamic linkedObjectsIds;
  dynamic oldref;
  dynamic statut;
  dynamic status;
  dynamic stateId;
  dynamic regionId;
  dynamic demandReasonId;
  dynamic transportModeId;
  dynamic shippingMethod;
  dynamic multicurrencyTx;
  dynamic lastMainDoc;
  dynamic fkBank;
  dynamic fkAccount;
  dynamic lines;
  dynamic dateCreation;
  dynamic dateValidation;
  dynamic dateModification;
  dynamic dateUpdate;
  dynamic dateCloture;
  dynamic userAuthor;
  dynamic userCreation;
  dynamic userCreationId;
  dynamic userValid;
  dynamic userValidation;
  dynamic userValidationId;
  dynamic userClosingId;
  dynamic userModification;
  dynamic userModificationId;
  dynamic specimen;
  dynamic labelStatus;
  dynamic showphotoOnPopup;
  List<dynamic>? nb;
  dynamic output;
  List<dynamic>? extraparams;
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

  factory Line.fromMap(Map<String, dynamic> json) => Line(
        fkFacture: json["fk_facture"],
        fkParentLine: json["fk_parent_line"],
        desc: json["desc"],
        refExt: json["ref_ext"],
        localtax1Type: json["localtax1_type"],
        localtax2Type: json["localtax2_type"],
        fkRemiseExcept: json["fk_remise_except"],
        rang: json["rang"],
        fkFournprice: json["fk_fournprice"],
        paHt: json["pa_ht"],
        margeTx: json["marge_tx"],
        marqueTx: json["marque_tx"],
        remisePercent: json["remise_percent"],
        specialCode: json["special_code"],
        origin: json["origin"],
        originId: json["origin_id"],
        fkCodeVentilation: json["fk_code_ventilation"],
        dateStart: json["date_start"],
        dateEnd: json["date_end"],
        situationPercent: json["situation_percent"],
        fkPrevId: json["fk_prev_id"],
        multicurrencySubprice: json["multicurrency_subprice"],
        multicurrencyTotalHt: json["multicurrency_total_ht"],
        multicurrencyTotalTva: json["multicurrency_total_tva"],
        multicurrencyTotalTtc: json["multicurrency_total_ttc"],
        label: json["label"],
        ref: json["ref"],
        libelle: json["libelle"],
        productType: json["product_type"],
        productRef: json["product_ref"],
        productLabel: json["product_label"],
        productDesc: json["product_desc"],
        qty: json["qty"],
        subprice: json["subprice"],
        price: json["price"],
        fkProduct: json["fk_product"],
        vatSrcCode: json["vat_src_code"],
        tvaTx: json["tva_tx"],
        localtax1Tx: json["localtax1_tx"],
        localtax2Tx: json["localtax2_tx"],
        remise: json["remise"],
        totalHt: json["total_ht"],
        totalTva: json["total_tva"],
        totalLocaltax1: json["total_localtax1"],
        totalLocaltax2: json["total_localtax2"],
        totalTtc: json["total_ttc"],
        dateStartFill: json["date_start_fill"],
        dateEndFill: json["date_end_fill"],
        buyPriceHt: json["buy_price_ht"],
        buyprice: json["buyprice"],
        infoBits: json["info_bits"],
        fkUserAuthor: json["fk_user_author"],
        fkUserModif: json["fk_user_modif"],
        fkAccountingAccount: json["fk_accounting_account"],
        id: json["id"],
        rowid: json["rowid"],
        fkUnit: json["fk_unit"],
        dateDebutPrevue: json["date_debut_prevue"],
        dateDebutReel: json["date_debut_reel"],
        dateFinPrevue: json["date_fin_prevue"],
        dateFinReel: json["date_fin_reel"],
        weight: json["weight"],
        weightUnits: json["weight_units"],
        width: json["width"],
        widthUnits: json["width_units"],
        height: json["height"],
        heightUnits: json["height_units"],
        length: json["length"],
        lengthUnits: json["length_units"],
        surface: json["surface"],
        surfaceUnits: json["surface_units"],
        volume: json["volume"],
        volumeUnits: json["volume_units"],
        multilangs: json["multilangs"],
        description: json["description"],
        product: json["product"],
        productBarcode: json["product_barcode"],
        fkProductType: json["fk_product_type"],
        duree: json["duree"],
        module: json["module"],
        entity: json["entity"],
        importKey: json["import_key"],
        arrayOptions: json["array_options"] == null
            ? []
            : List<dynamic>.from(json["array_options"]!.map((x) => x)),
        arrayLanguages: json["array_languages"],
        contactsIds: json["contacts_ids"],
        linkedObjects: json["linked_objects"],
        linkedObjectsIds: json["linkedObjectsIds"],
        oldref: json["oldref"],
        statut: json["statut"],
        status: json["status"],
        stateId: json["state_id"],
        regionId: json["region_id"],
        demandReasonId: json["demand_reason_id"],
        transportModeId: json["transport_mode_id"],
        shippingMethod: json["shipping_method"],
        multicurrencyTx: json["multicurrency_tx"],
        lastMainDoc: json["last_main_doc"],
        fkBank: json["fk_bank"],
        fkAccount: json["fk_account"],
        lines: json["lines"],
        dateCreation: json["date_creation"],
        dateValidation: json["date_validation"],
        dateModification: json["date_modification"],
        dateUpdate: json["date_update"],
        dateCloture: json["date_cloture"],
        userAuthor: json["user_author"],
        userCreation: json["user_creation"],
        userCreationId: json["user_creation_id"],
        userValid: json["user_valid"],
        userValidation: json["user_validation"],
        userValidationId: json["user_validation_id"],
        userClosingId: json["user_closing_id"],
        userModification: json["user_modification"],
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
        codeVentilation: json["code_ventilation"],
      );

  Map<String, dynamic> toMap() => {
        "fk_facture": fkFacture,
        "fk_parent_line": fkParentLine,
        "desc": desc,
        "ref_ext": refExt,
        "localtax1_type": localtax1Type,
        "localtax2_type": localtax2Type,
        "fk_remise_except": fkRemiseExcept,
        "rang": rang,
        "fk_fournprice": fkFournprice,
        "pa_ht": paHt,
        "marge_tx": margeTx,
        "marque_tx": marqueTx,
        "remise_percent": remisePercent,
        "special_code": specialCode,
        "origin": origin,
        "origin_id": originId,
        "fk_code_ventilation": fkCodeVentilation,
        "date_start": dateStart,
        "date_end": dateEnd,
        "situation_percent": situationPercent,
        "fk_prev_id": fkPrevId,
        "multicurrency_subprice": multicurrencySubprice,
        "multicurrency_total_ht": multicurrencyTotalHt,
        "multicurrency_total_tva": multicurrencyTotalTva,
        "multicurrency_total_ttc": multicurrencyTotalTtc,
        "label": label,
        "ref": ref,
        "libelle": libelle,
        "product_type": productType,
        "product_ref": productRef,
        "product_label": productLabel,
        "product_desc": productDesc,
        "qty": qty,
        "subprice": subprice,
        "price": price,
        "fk_product": fkProduct,
        "vat_src_code": vatSrcCode,
        "tva_tx": tvaTx,
        "localtax1_tx": localtax1Tx,
        "localtax2_tx": localtax2Tx,
        "remise": remise,
        "total_ht": totalHt,
        "total_tva": totalTva,
        "total_localtax1": totalLocaltax1,
        "total_localtax2": totalLocaltax2,
        "total_ttc": totalTtc,
        "date_start_fill": dateStartFill,
        "date_end_fill": dateEndFill,
        "buy_price_ht": buyPriceHt,
        "buyprice": buyprice,
        "info_bits": infoBits,
        "fk_user_author": fkUserAuthor,
        "fk_user_modif": fkUserModif,
        "fk_accounting_account": fkAccountingAccount,
        "id": id,
        "rowid": rowid,
        "fk_unit": fkUnit,
        "date_debut_prevue": dateDebutPrevue,
        "date_debut_reel": dateDebutReel,
        "date_fin_prevue": dateFinPrevue,
        "date_fin_reel": dateFinReel,
        "weight": weight,
        "weight_units": weightUnits,
        "width": width,
        "width_units": widthUnits,
        "height": height,
        "height_units": heightUnits,
        "length": length,
        "length_units": lengthUnits,
        "surface": surface,
        "surface_units": surfaceUnits,
        "volume": volume,
        "volume_units": volumeUnits,
        "multilangs": multilangs,
        "description": description,
        "product": product,
        "product_barcode": productBarcode,
        "fk_product_type": fkProductType,
        "duree": duree,
        "module": module,
        "entity": entity,
        "import_key": importKey,
        "array_options": arrayOptions == null
            ? []
            : List<dynamic>.from(arrayOptions!.map((x) => x)),
        "array_languages": arrayLanguages,
        "contacts_ids": contactsIds,
        "linked_objects": linkedObjects,
        "linkedObjectsIds": linkedObjectsIds,
        "oldref": oldref,
        "statut": statut,
        "status": status,
        "state_id": stateId,
        "region_id": regionId,
        "demand_reason_id": demandReasonId,
        "transport_mode_id": transportModeId,
        "shipping_method": shippingMethod,
        "multicurrency_tx": multicurrencyTx,
        "last_main_doc": lastMainDoc,
        "fk_bank": fkBank,
        "fk_account": fkAccount,
        "lines": lines,
        "date_creation": dateCreation,
        "date_validation": dateValidation,
        "date_modification": dateModification,
        "date_update": dateUpdate,
        "date_cloture": dateCloture,
        "user_author": userAuthor,
        "user_creation": userCreation,
        "user_creation_id": userCreationId,
        "user_valid": userValid,
        "user_validation": userValidation,
        "user_validation_id": userValidationId,
        "user_closing_id": userClosingId,
        "user_modification": userModification,
        "user_modification_id": userModificationId,
        "specimen": specimen,
        "labelStatus": labelStatus,
        "showphoto_on_popup": showphotoOnPopup,
        "nb": nb == null ? [] : List<dynamic>.from(nb!.map((x) => x)),
        "output": output,
        "extraparams": extraparams == null
            ? []
            : List<dynamic>.from(extraparams!.map((x) => x)),
        "code_ventilation": codeVentilation,
      };
}
