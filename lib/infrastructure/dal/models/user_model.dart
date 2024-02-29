// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

DolibarrUserModel userModelFromJson(String str) =>
    DolibarrUserModel.fromJson(json.decode(str));

String userModelToJson(DolibarrUserModel data) => json.encode(data.toJson());

class DolibarrUserModel {
  String? id;
  String? statut;
  String? employee;
  dynamic civilityCode;
  dynamic fullname;
  String? gender;
  String? birth;
  String? email;
  String? personalEmail;
  List<dynamic>? socialnetworks;
  String? job;
  String? signature;
  String? officePhone;
  String? officeFax;
  String? userMobile;
  String? personalMobile;
  String? admin;
  String? login;
  String? entity;
  int? datec;
  int? datem;
  dynamic socid;
  dynamic contactId;
  dynamic fkMember;
  dynamic fkUser;
  dynamic fkUserExpenseValidator;
  dynamic fkUserHolidayValidator;
  dynamic clicktodialUrl;
  dynamic clicktodialLogin;
  dynamic clicktodialPoste;
  int? datelastlogin;
  int? datepreviouslogin;
  String? flagdelsessionsbefore;
  String? iplastlogin;
  String? ippreviouslogin;
  String? datestartvalidity;
  String? dateendvalidity;
  dynamic photo;
  dynamic lang;
  Rights? rights;
  dynamic userGroupList;
  Conf? conf;
  List<dynamic>? users;
  dynamic parentof;
  String? accountancyCode;
  dynamic thm;
  dynamic tjm;
  dynamic salary;
  dynamic salaryextra;
  dynamic weeklyhours;
  String? color;
  String? dateemployment;
  String? dateemploymentend;
  dynamic defaultCExpTaxCat;
  dynamic refEmployee;
  dynamic nationalRegistrationNumber;
  dynamic defaultRange;
  dynamic fkWarehouse;
  dynamic module;
  dynamic importKey;
  List<dynamic>? arrayOptions;
  dynamic arrayLanguages;
  dynamic contactsIds;
  dynamic linkedObjects;
  dynamic linkedObjectsIds;
  dynamic oldref;
  dynamic canvas;
  dynamic fkProject;
  dynamic user;
  dynamic origin;
  dynamic originId;
  String? ref;
  dynamic refExt;
  String? status;
  dynamic countryId;
  String? countryCode;
  dynamic stateId;
  dynamic regionId;
  dynamic barcodeType;
  dynamic barcodeTypeCoder;
  dynamic modeReglementId;
  dynamic condReglementId;
  dynamic demandReasonId;
  dynamic transportModeId;
  dynamic shippingMethod;
  dynamic multicurrencyCode;
  dynamic multicurrencyTx;
  dynamic lastMainDoc;
  dynamic fkBank;
  dynamic fkAccount;
  String? notePublic;
  String? notePrivate;
  dynamic name;
  String? lastname;
  String? firstname;
  dynamic civilityId;
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
  int? specimen;
  dynamic labelStatus;
  dynamic showphotoOnPopup;
  List<dynamic>? nb;
  dynamic output;
  List<dynamic>? extraparams;
  String? address;
  String? zip;
  String? town;

  DolibarrUserModel({
    this.id,
    this.statut,
    this.employee,
    this.civilityCode,
    this.fullname,
    this.gender,
    this.birth,
    this.email,
    this.personalEmail,
    this.socialnetworks,
    this.job,
    this.signature,
    this.officePhone,
    this.officeFax,
    this.userMobile,
    this.personalMobile,
    this.admin,
    this.login,
    this.entity,
    this.datec,
    this.datem,
    this.socid,
    this.contactId,
    this.fkMember,
    this.fkUser,
    this.fkUserExpenseValidator,
    this.fkUserHolidayValidator,
    this.clicktodialUrl,
    this.clicktodialLogin,
    this.clicktodialPoste,
    this.datelastlogin,
    this.datepreviouslogin,
    this.flagdelsessionsbefore,
    this.iplastlogin,
    this.ippreviouslogin,
    this.datestartvalidity,
    this.dateendvalidity,
    this.photo,
    this.lang,
    this.rights,
    this.userGroupList,
    this.conf,
    this.users,
    this.parentof,
    this.accountancyCode,
    this.thm,
    this.tjm,
    this.salary,
    this.salaryextra,
    this.weeklyhours,
    this.color,
    this.dateemployment,
    this.dateemploymentend,
    this.defaultCExpTaxCat,
    this.refEmployee,
    this.nationalRegistrationNumber,
    this.defaultRange,
    this.fkWarehouse,
    this.module,
    this.importKey,
    this.arrayOptions,
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
    this.ref,
    this.refExt,
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
    this.shippingMethod,
    this.multicurrencyCode,
    this.multicurrencyTx,
    this.lastMainDoc,
    this.fkBank,
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
    this.address,
    this.zip,
    this.town,
  });

  factory DolibarrUserModel.fromJson(Map<String, dynamic> json) =>
      DolibarrUserModel(
        id: json["id"],
        statut: json["statut"],
        employee: json["employee"],
        civilityCode: json["civility_code"],
        fullname: json["fullname"],
        gender: json["gender"],
        birth: json["birth"],
        email: json["email"],
        personalEmail: json["personal_email"],
        socialnetworks: json["socialnetworks"] == null
            ? []
            : List<dynamic>.from(json["socialnetworks"]!.map((x) => x)),
        job: json["job"],
        signature: json["signature"],
        officePhone: json["office_phone"],
        officeFax: json["office_fax"],
        userMobile: json["user_mobile"],
        personalMobile: json["personal_mobile"],
        admin: json["admin"],
        login: json["login"],
        entity: json["entity"],
        datec: json["datec"],
        datem: json["datem"],
        socid: json["socid"],
        contactId: json["contact_id"],
        fkMember: json["fk_member"],
        fkUser: json["fk_user"],
        fkUserExpenseValidator: json["fk_user_expense_validator"],
        fkUserHolidayValidator: json["fk_user_holiday_validator"],
        clicktodialUrl: json["clicktodial_url"],
        clicktodialLogin: json["clicktodial_login"],
        clicktodialPoste: json["clicktodial_poste"],
        datelastlogin: json["datelastlogin"],
        datepreviouslogin: json["datepreviouslogin"],
        flagdelsessionsbefore: json["flagdelsessionsbefore"],
        iplastlogin: json["iplastlogin"],
        ippreviouslogin: json["ippreviouslogin"],
        datestartvalidity: json["datestartvalidity"],
        dateendvalidity: json["dateendvalidity"],
        photo: json["photo"],
        lang: json["lang"],
        rights: json["rights"] == null ? null : Rights.fromJson(json["rights"]),
        userGroupList: json["user_group_list"],
        conf: json["conf"] == null ? null : Conf.fromJson(json["conf"]),
        users: json["users"] == null
            ? []
            : List<dynamic>.from(json["users"]!.map((x) => x)),
        parentof: json["parentof"],
        accountancyCode: json["accountancy_code"],
        thm: json["thm"],
        tjm: json["tjm"],
        salary: json["salary"],
        salaryextra: json["salaryextra"],
        weeklyhours: json["weeklyhours"],
        color: json["color"],
        dateemployment: json["dateemployment"],
        dateemploymentend: json["dateemploymentend"],
        defaultCExpTaxCat: json["default_c_exp_tax_cat"],
        refEmployee: json["ref_employee"],
        nationalRegistrationNumber: json["national_registration_number"],
        defaultRange: json["default_range"],
        fkWarehouse: json["fk_warehouse"],
        module: json["module"],
        importKey: json["import_key"],
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
        user: json["user"],
        origin: json["origin"],
        originId: json["origin_id"],
        ref: json["ref"],
        refExt: json["ref_ext"],
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
        shippingMethod: json["shipping_method"],
        multicurrencyCode: json["multicurrency_code"],
        multicurrencyTx: json["multicurrency_tx"],
        lastMainDoc: json["last_main_doc"],
        fkBank: json["fk_bank"],
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
        address: json["address"],
        zip: json["zip"],
        town: json["town"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "statut": statut,
        "employee": employee,
        "civility_code": civilityCode,
        "fullname": fullname,
        "gender": gender,
        "birth": birth,
        "email": email,
        "personal_email": personalEmail,
        "socialnetworks": socialnetworks == null
            ? []
            : List<dynamic>.from(socialnetworks!.map((x) => x)),
        "job": job,
        "signature": signature,
        "office_phone": officePhone,
        "office_fax": officeFax,
        "user_mobile": userMobile,
        "personal_mobile": personalMobile,
        "admin": admin,
        "login": login,
        "entity": entity,
        "datec": datec,
        "datem": datem,
        "socid": socid,
        "contact_id": contactId,
        "fk_member": fkMember,
        "fk_user": fkUser,
        "fk_user_expense_validator": fkUserExpenseValidator,
        "fk_user_holiday_validator": fkUserHolidayValidator,
        "clicktodial_url": clicktodialUrl,
        "clicktodial_login": clicktodialLogin,
        "clicktodial_poste": clicktodialPoste,
        "datelastlogin": datelastlogin,
        "datepreviouslogin": datepreviouslogin,
        "flagdelsessionsbefore": flagdelsessionsbefore,
        "iplastlogin": iplastlogin,
        "ippreviouslogin": ippreviouslogin,
        "datestartvalidity": datestartvalidity,
        "dateendvalidity": dateendvalidity,
        "photo": photo,
        "lang": lang,
        "rights": rights?.toJson(),
        "user_group_list": userGroupList,
        "conf": conf?.toJson(),
        "users": users == null ? [] : List<dynamic>.from(users!.map((x) => x)),
        "parentof": parentof,
        "accountancy_code": accountancyCode,
        "thm": thm,
        "tjm": tjm,
        "salary": salary,
        "salaryextra": salaryextra,
        "weeklyhours": weeklyhours,
        "color": color,
        "dateemployment": dateemployment,
        "dateemploymentend": dateemploymentend,
        "default_c_exp_tax_cat": defaultCExpTaxCat,
        "ref_employee": refEmployee,
        "national_registration_number": nationalRegistrationNumber,
        "default_range": defaultRange,
        "fk_warehouse": fkWarehouse,
        "module": module,
        "import_key": importKey,
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
        "user": user,
        "origin": origin,
        "origin_id": originId,
        "ref": ref,
        "ref_ext": refExt,
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
        "shipping_method": shippingMethod,
        "multicurrency_code": multicurrencyCode,
        "multicurrency_tx": multicurrencyTx,
        "last_main_doc": lastMainDoc,
        "fk_bank": fkBank,
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
        "address": address,
        "zip": zip,
        "town": town,
      };
}

class Conf {
  Conf();

  factory Conf.fromJson(Map<String, dynamic> json) => Conf();

  Map<String, dynamic> toJson() => {};
}

class Rights {
  User? user;

  Rights({
    this.user,
  });

  factory Rights.fromJson(Map<String, dynamic> json) => Rights(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
      };
}

class User {
  Conf? user;
  Conf? self;
  Conf? userAdvance;
  Conf? selfAdvance;
  Conf? groupAdvance;

  User({
    this.user,
    this.self,
    this.userAdvance,
    this.selfAdvance,
    this.groupAdvance,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        user: json["user"] == null ? null : Conf.fromJson(json["user"]),
        self: json["self"] == null ? null : Conf.fromJson(json["self"]),
        userAdvance: json["user_advance"] == null
            ? null
            : Conf.fromJson(json["user_advance"]),
        selfAdvance: json["self_advance"] == null
            ? null
            : Conf.fromJson(json["self_advance"]),
        groupAdvance: json["group_advance"] == null
            ? null
            : Conf.fromJson(json["group_advance"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "self": self?.toJson(),
        "user_advance": userAdvance?.toJson(),
        "self_advance": selfAdvance?.toJson(),
        "group_advance": groupAdvance?.toJson(),
      };
}
