// To parse this JSON data, do
//
//     final thirdParty = thirdPartyFromMap(jsonString);

import 'dart:convert';

List<ThirdParty> thirdPartyFromMap(String str) =>
    List<ThirdParty>.from(json.decode(str).map((x) => ThirdParty.fromMap(x)));

String thirdPartyToMap(List<ThirdParty> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class ThirdParty {
  dynamic module;
  dynamic supplierCategories;
  dynamic prefixCustomerIsRequired;
  dynamic entity;
  dynamic name;
  dynamic nameAlias;
  dynamic status;
  dynamic phone;
  dynamic fax;
  dynamic email;
  dynamic noEmail;
  dynamic skype;
  dynamic twitter;
  dynamic facebook;
  dynamic linkedin;
  dynamic url;
  dynamic barcode;
  dynamic idprof1;
  dynamic idprof2;
  dynamic idprof3;
  dynamic idprof4;
  dynamic idprof5;
  dynamic idprof6;
  dynamic socialobject;
  dynamic tvaAssuj;
  dynamic tvaIntra;
  dynamic vatReverseCharge;
  dynamic localtax1Assuj;
  dynamic localtax1Value;
  dynamic localtax2Assuj;
  dynamic localtax2Value;
  dynamic managers;
  dynamic capital;
  dynamic typentId;
  dynamic typentCode;
  dynamic effectif;
  dynamic effectifId;
  dynamic formeJuridiqueCode;
  dynamic formeJuridique;
  dynamic remisePercent;
  dynamic remiseSupplierPercent;
  dynamic modeReglementId;
  dynamic condReglementId;
  dynamic depositPercent;
  dynamic modeReglementSupplierId;
  dynamic condReglementSupplierId;
  dynamic transportModeSupplierId;
  dynamic fkProspectlevel;
  dynamic dateModification;
  dynamic userModification;
  dynamic dateCreation;
  dynamic userCreation;
  dynamic client;
  dynamic prospect;
  dynamic fournisseur;
  dynamic codeClient;
  dynamic codeFournisseur;
  dynamic codeComptaClient;
  dynamic codeCompta;
  dynamic accountancyCodeCustomer;
  dynamic codeComptaFournisseur;
  dynamic accountancyCodeSupplier;
  dynamic codeComptaProduct;
  dynamic notePrivate;
  dynamic notePublic;
  dynamic stcommId;
  dynamic stcommPicto;
  dynamic statusProspectLabel;
  dynamic priceLevel;
  dynamic outstandingLimit;
  dynamic orderMinAmount;
  dynamic supplierOrderMinAmount;
  dynamic parent;
  dynamic defaultLang;
  dynamic ref;
  dynamic refExt;
  dynamic importKey;
  dynamic webservicesUrl;
  dynamic webservicesKey;
  dynamic logo;
  dynamic logoSmall;
  dynamic logoMini;
  dynamic logoSquarred;
  dynamic logoSquarredSmall;
  dynamic logoSquarredMini;
  dynamic accountancyCodeSell;
  dynamic accountancyCodeBuy;
  dynamic fkMulticurrency;
  dynamic fkWarehouse;
  dynamic multicurrencyCode;
  dynamic partnerships;
  dynamic bankAccount;
  dynamic id;
  dynamic arrayOptions;
  dynamic arrayLanguages;
  dynamic contactsIds;
  dynamic linkedObjects;
  dynamic linkedObjectsIds;
  dynamic oldref;
  dynamic canvas;
  dynamic fkProject;
  dynamic contactId;
  dynamic user;
  dynamic origin;
  dynamic originId;
  dynamic statut;
  dynamic countryId;
  dynamic countryCode;
  dynamic stateId;
  dynamic regionId;
  dynamic barcodeType;
  dynamic barcodeTypeCoder;
  dynamic demandReasonId;
  dynamic transportModeId;
  dynamic shippingMethodId;
  dynamic shippingMethod;
  dynamic multicurrencyTx;
  dynamic modelPdf;
  dynamic lastMainDoc;
  dynamic fkBank;
  dynamic fkAccount;
  dynamic lastname;
  dynamic firstname;
  dynamic civilityId;
  dynamic dateValidation;
  dynamic dateUpdate;
  dynamic dateCloture;
  dynamic userAuthor;
  dynamic userCreationId;
  dynamic userValid;
  dynamic userValidation;
  dynamic userValidationId;
  dynamic userClosingId;
  dynamic userModificationId;
  dynamic specimen;
  dynamic labelStatus;
  dynamic showphotoOnPopup;
  dynamic nb;
  dynamic output;
  dynamic extraparams;
  dynamic fkIncoterms;
  dynamic labelIncoterms;
  dynamic locationIncoterms;
  dynamic socialnetworks;
  dynamic address;
  dynamic zip;
  dynamic town;

  ThirdParty({
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

  factory ThirdParty.fromMap(Map<String, dynamic> json) => ThirdParty(
        module: json["module"],
        supplierCategories:
            List<dynamic>.from(json["SupplierCategories"].map((x) => x)),
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
        partnerships: List<dynamic>.from(json["partnerships"].map((x) => x)),
        bankAccount: json["bank_account"],
        id: json["id"],
        arrayOptions: List<dynamic>.from(json["array_options"].map((x) => x)),
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
        nb: List<dynamic>.from(json["nb"].map((x) => x)),
        output: json["output"],
        extraparams: List<dynamic>.from(json["extraparams"].map((x) => x)),
        fkIncoterms: json["fk_incoterms"],
        labelIncoterms: json["label_incoterms"],
        locationIncoterms: json["location_incoterms"],
        socialnetworks:
            List<dynamic>.from(json["socialnetworks"].map((x) => x)),
        address: json["address"],
        zip: json["zip"],
        town: json["town"],
      );

  Map<String, dynamic> toMap() => {
        "module": module,
        "SupplierCategories":
            List<dynamic>.from(supplierCategories.map((x) => x)),
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
        "partnerships": List<dynamic>.from(partnerships.map((x) => x)),
        "bank_account": bankAccount,
        "id": id,
        "array_options": List<dynamic>.from(arrayOptions.map((x) => x)),
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
        "nb": List<dynamic>.from(nb.map((x) => x)),
        "output": output,
        "extraparams": List<dynamic>.from(extraparams.map((x) => x)),
        "fk_incoterms": fkIncoterms,
        "label_incoterms": labelIncoterms,
        "location_incoterms": locationIncoterms,
        "socialnetworks": List<dynamic>.from(socialnetworks.map((x) => x)),
        "address": address,
        "zip": zip,
        "town": town,
      };
}
