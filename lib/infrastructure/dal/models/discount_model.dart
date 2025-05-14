// To parse this JSON data, do
//
//     final dicountModel = dicountModelFromJson(jsonString);

import 'dart:convert';

DiscountModel discountModelFromJson(String str) =>
    DiscountModel.fromJson(json.decode(str));

String discountModelToJson(DiscountModel data) => json.encode(data.toJson());

class DiscountModel {
  dynamic module;
  dynamic id;
  dynamic entity;
  dynamic importKey;
  List<dynamic>? arrayOptions;
  dynamic arrayLanguages;
  dynamic contactsIds;
  dynamic linkedObjectsIds;
  dynamic canvas;
  dynamic fkProject;
  dynamic contactId;
  dynamic user;
  dynamic originType;
  dynamic originId;
  dynamic ref;
  dynamic refExt;
  dynamic statut;
  dynamic status;
  dynamic countryId;
  dynamic countryCode;
  dynamic stateId;
  dynamic regionId;
  dynamic barcodeType;
  dynamic barcodeTypeCoder;
  dynamic modeReglementId;
  dynamic condReglementId;
  dynamic demandReasonId;
  dynamic transportModeId;
  dynamic shippingMethodId;
  dynamic shippingMethod;
  dynamic fkMulticurrency;
  dynamic multicurrencyCode;
  dynamic multicurrencyTx;
  dynamic multicurrencyTotalHt;
  dynamic multicurrencyTotalTva;
  dynamic multicurrencyTotalTtc;
  dynamic multicurrencyTotalLocaltax1;
  dynamic multicurrencyTotalLocaltax2;
  dynamic lastMainDoc;
  dynamic fkAccount;
  dynamic notePublic;
  dynamic notePrivate;
  dynamic totalHt;
  dynamic totalTva;
  dynamic totalLocaltax1;
  dynamic totalLocaltax2;
  dynamic totalTtc;
  dynamic lines;
  dynamic actiontypecode;
  dynamic name;
  dynamic lastname;
  dynamic firstname;
  dynamic civilityId;
  dynamic dateCreation;
  dynamic dateValidation;
  dynamic dateModification;
  dynamic tms;
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
  dynamic fkUserCreat;
  dynamic fkUserModif;
  dynamic specimen;
  dynamic totalpaid;
  List<dynamic>? extraparams;
  dynamic product;
  dynamic condReglementSupplierId;
  dynamic depositPercent;
  dynamic retainedWarrantyFkCondReglement;
  dynamic warehouseId;
  dynamic fkSoc;
  dynamic socid;
  dynamic discountType;
  dynamic amountHt;
  dynamic amountTva;
  dynamic amountTtc;
  dynamic multicurrencyAmountHt;
  dynamic multicurrencyAmountTva;
  dynamic multicurrencyAmountTtc;
  dynamic multicurrencySubprice;
  dynamic fkInvoiceSupplier;
  dynamic fkInvoiceSupplierLine;
  dynamic tvaTx;
  dynamic vatSrcCode;
  dynamic fkUser;
  dynamic description;
  dynamic datec;
  dynamic fkFactureLine;
  dynamic fkFacture;
  dynamic fkFactureSource;
  dynamic refFactureSource;
  dynamic typeFactureSource;
  dynamic fkInvoiceSupplierSource;
  dynamic refInvoiceSupplierSource;
  dynamic typeInvoiceSupplierSource;

  DiscountModel({
    this.module,
    this.id,
    this.entity,
    this.importKey,
    this.arrayOptions,
    this.arrayLanguages,
    this.contactsIds,
    this.linkedObjectsIds,
    this.canvas,
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
    this.barcodeType,
    this.barcodeTypeCoder,
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
    this.fkSoc,
    this.socid,
    this.discountType,
    this.amountHt,
    this.amountTva,
    this.amountTtc,
    this.multicurrencyAmountHt,
    this.multicurrencyAmountTva,
    this.multicurrencyAmountTtc,
    this.multicurrencySubprice,
    this.fkInvoiceSupplier,
    this.fkInvoiceSupplierLine,
    this.tvaTx,
    this.vatSrcCode,
    this.fkUser,
    this.description,
    this.datec,
    this.fkFactureLine,
    this.fkFacture,
    this.fkFactureSource,
    this.refFactureSource,
    this.typeFactureSource,
    this.fkInvoiceSupplierSource,
    this.refInvoiceSupplierSource,
    this.typeInvoiceSupplierSource,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) => DiscountModel(
        module: json["module"],
        id: json["id"],
        entity: json["entity"],
        importKey: json["import_key"],
        arrayOptions: json["array_options"] == null
            ? []
            : List<dynamic>.from(json["array_options"]!.map((x) => x)),
        arrayLanguages: json["array_languages"],
        contactsIds: json["contacts_ids"],
        linkedObjectsIds: json["linkedObjectsIds"],
        canvas: json["canvas"],
        fkProject: json["fk_project"],
        contactId: json["contact_id"],
        user: json["user"],
        originType: json["origin_type"],
        originId: json["origin_id"],
        ref: json["ref"],
        refExt: json["ref_ext"],
        statut: json["statut"],
        status: json["status"],
        countryId: json["country_id"],
        countryCode: json["country_code"],
        stateId: json["state_id"],
        regionId: json["region_id"],
        barcodeType: json["barcode_type"],
        barcodeTypeCoder: json["barcode_type_coder"],
        modeReglementId: json["mode_reglement_id"],
        condReglementId: json["cond_reglement_id"],
        demandReasonId: json["demand_reason_id"],
        transportModeId: json["transport_mode_id"],
        shippingMethodId: json["shipping_method_id"],
        shippingMethod: json["shipping_method"],
        fkMulticurrency: json["fk_multicurrency"],
        multicurrencyCode: json["multicurrency_code"],
        multicurrencyTx: json["multicurrency_tx"],
        multicurrencyTotalHt: json["multicurrency_total_ht"],
        multicurrencyTotalTva: json["multicurrency_total_tva"],
        multicurrencyTotalTtc: json["multicurrency_total_ttc"],
        multicurrencyTotalLocaltax1: json["multicurrency_total_localtax1"],
        multicurrencyTotalLocaltax2: json["multicurrency_total_localtax2"],
        lastMainDoc: json["last_main_doc"],
        fkAccount: json["fk_account"],
        notePublic: json["note_public"],
        notePrivate: json["note_private"],
        totalHt: json["total_ht"],
        totalTva: json["total_tva"],
        totalLocaltax1: json["total_localtax1"],
        totalLocaltax2: json["total_localtax2"],
        totalTtc: json["total_ttc"],
        lines: json["lines"],
        actiontypecode: json["actiontypecode"],
        name: json["name"],
        lastname: json["lastname"],
        firstname: json["firstname"],
        civilityId: json["civility_id"],
        dateCreation: json["date_creation"],
        dateValidation: json["date_validation"],
        dateModification: json["date_modification"],
        tms: json["tms"],
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
        fkUserCreat: json["fk_user_creat"],
        fkUserModif: json["fk_user_modif"],
        specimen: json["specimen"],
        totalpaid: json["totalpaid"],
        extraparams: json["extraparams"] == null
            ? []
            : List<dynamic>.from(json["extraparams"]!.map((x) => x)),
        product: json["product"],
        condReglementSupplierId: json["cond_reglement_supplier_id"],
        depositPercent: json["deposit_percent"],
        retainedWarrantyFkCondReglement:
            json["retained_warranty_fk_cond_reglement"],
        warehouseId: json["warehouse_id"],
        fkSoc: json["fk_soc"],
        socid: json["socid"],
        discountType: json["discount_type"],
        amountHt: json["amount_ht"],
        amountTva: json["amount_tva"],
        amountTtc: json["amount_ttc"],
        multicurrencyAmountHt: json["multicurrency_amount_ht"],
        multicurrencyAmountTva: json["multicurrency_amount_tva"],
        multicurrencyAmountTtc: json["multicurrency_amount_ttc"],
        multicurrencySubprice: json["multicurrency_subprice"],
        fkInvoiceSupplier: json["fk_invoice_supplier"],
        fkInvoiceSupplierLine: json["fk_invoice_supplier_line"],
        tvaTx: json["tva_tx"],
        vatSrcCode: json["vat_src_code"],
        fkUser: json["fk_user"],
        description: json["description"],
        datec: json["datec"],
        fkFactureLine: json["fk_facture_line"],
        fkFacture: json["fk_facture"],
        fkFactureSource: json["fk_facture_source"],
        refFactureSource: json["ref_facture_source"],
        typeFactureSource: json["type_facture_source"],
        fkInvoiceSupplierSource: json["fk_invoice_supplier_source"],
        refInvoiceSupplierSource: json["ref_invoice_supplier_source"],
        typeInvoiceSupplierSource: json["type_invoice_supplier_source"],
      );

  Map<String, dynamic> toJson() => {
        "module": module,
        "id": id,
        "entity": entity,
        "import_key": importKey,
        "array_options": arrayOptions == null
            ? []
            : List<dynamic>.from(arrayOptions!.map((x) => x)),
        "array_languages": arrayLanguages,
        "contacts_ids": contactsIds,
        "linkedObjectsIds": linkedObjectsIds,
        "canvas": canvas,
        "fk_project": fkProject,
        "contact_id": contactId,
        "user": user,
        "origin_type": originType,
        "origin_id": originId,
        "ref": ref,
        "ref_ext": refExt,
        "statut": statut,
        "status": status,
        "country_id": countryId,
        "country_code": countryCode,
        "state_id": stateId,
        "region_id": regionId,
        "barcode_type": barcodeType,
        "barcode_type_coder": barcodeTypeCoder,
        "mode_reglement_id": modeReglementId,
        "cond_reglement_id": condReglementId,
        "demand_reason_id": demandReasonId,
        "transport_mode_id": transportModeId,
        "shipping_method_id": shippingMethodId,
        "shipping_method": shippingMethod,
        "fk_multicurrency": fkMulticurrency,
        "multicurrency_code": multicurrencyCode,
        "multicurrency_tx": multicurrencyTx,
        "multicurrency_total_ht": multicurrencyTotalHt,
        "multicurrency_total_tva": multicurrencyTotalTva,
        "multicurrency_total_ttc": multicurrencyTotalTtc,
        "multicurrency_total_localtax1": multicurrencyTotalLocaltax1,
        "multicurrency_total_localtax2": multicurrencyTotalLocaltax2,
        "last_main_doc": lastMainDoc,
        "fk_account": fkAccount,
        "note_public": notePublic,
        "note_private": notePrivate,
        "total_ht": totalHt,
        "total_tva": totalTva,
        "total_localtax1": totalLocaltax1,
        "total_localtax2": totalLocaltax2,
        "total_ttc": totalTtc,
        "lines": lines,
        "actiontypecode": actiontypecode,
        "name": name,
        "lastname": lastname,
        "firstname": firstname,
        "civility_id": civilityId,
        "date_creation": dateCreation,
        "date_validation": dateValidation,
        "date_modification": dateModification,
        "tms": tms,
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
        "fk_user_creat": fkUserCreat,
        "fk_user_modif": fkUserModif,
        "specimen": specimen,
        "totalpaid": totalpaid,
        "extraparams": extraparams == null
            ? []
            : List<dynamic>.from(extraparams!.map((x) => x)),
        "product": product,
        "cond_reglement_supplier_id": condReglementSupplierId,
        "deposit_percent": depositPercent,
        "retained_warranty_fk_cond_reglement": retainedWarrantyFkCondReglement,
        "warehouse_id": warehouseId,
        "fk_soc": fkSoc,
        "socid": socid,
        "discount_type": discountType,
        "amount_ht": amountHt,
        "amount_tva": amountTva,
        "amount_ttc": amountTtc,
        "multicurrency_amount_ht": multicurrencyAmountHt,
        "multicurrency_amount_tva": multicurrencyAmountTva,
        "multicurrency_amount_ttc": multicurrencyAmountTtc,
        "multicurrency_subprice": multicurrencySubprice,
        "fk_invoice_supplier": fkInvoiceSupplier,
        "fk_invoice_supplier_line": fkInvoiceSupplierLine,
        "tva_tx": tvaTx,
        "vat_src_code": vatSrcCode,
        "fk_user": fkUser,
        "description": description,
        "datec": datec,
        "fk_facture_line": fkFactureLine,
        "fk_facture": fkFacture,
        "fk_facture_source": fkFactureSource,
        "ref_facture_source": refFactureSource,
        "type_facture_source": typeFactureSource,
        "fk_invoice_supplier_source": fkInvoiceSupplierSource,
        "ref_invoice_supplier_source": refInvoiceSupplierSource,
        "type_invoice_supplier_source": typeInvoiceSupplierSource,
      };
}
