// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

@HiveType(typeId: 17)
@JsonSerializable()
class UserModel {
  @HiveField(1)
  @JsonKey(name: "id")
  String? id;
  @HiveField(3)
  @JsonKey(name: "statut")
  String? statut;
  @HiveField(5)
  @JsonKey(name: "employee")
  String? employee;
  @HiveField(7)
  @JsonKey(name: "civility_code")
  String? civilityCode;
  @HiveField(9)
  @JsonKey(name: "fullname")
  dynamic fullname;
  @HiveField(11)
  @JsonKey(name: "gender")
  dynamic gender;
  @HiveField(13)
  @JsonKey(name: "birth")
  String? birth;
  @HiveField(15)
  @JsonKey(name: "email")
  String? email;
  @HiveField(17)
  @JsonKey(name: "personal_email")
  String? personalEmail;
  @HiveField(19)
  @JsonKey(name: "socialnetworks")
  List<dynamic>? socialnetworks;
  @HiveField(21)
  @JsonKey(name: "job")
  String? job;
  @HiveField(23)
  @JsonKey(name: "signature")
  String? signature;
  @HiveField(25)
  @JsonKey(name: "office_phone")
  String? officePhone;
  @HiveField(27)
  @JsonKey(name: "office_fax")
  String? officeFax;
  @HiveField(29)
  @JsonKey(name: "user_mobile")
  String? userMobile;
  @HiveField(31)
  @JsonKey(name: "personal_mobile")
  String? personalMobile;
  @HiveField(33)
  @JsonKey(name: "admin")
  String? admin;
  @HiveField(35)
  @JsonKey(name: "login")
  String? login;
  @HiveField(37)
  @JsonKey(name: "entity")
  String? entity;
  @HiveField(39)
  @JsonKey(name: "datec")
  int? datec;
  @HiveField(41)
  @JsonKey(name: "datem")
  int? datem;
  @HiveField(43)
  @JsonKey(name: "socid")
  dynamic socid;
  @HiveField(45)
  @JsonKey(name: "contact_id")
  dynamic contactId;
  @HiveField(47)
  @JsonKey(name: "fk_member")
  dynamic fkMember;
  @HiveField(49)
  @JsonKey(name: "fk_user")
  dynamic fkUser;
  @HiveField(51)
  @JsonKey(name: "fk_user_expense_validator")
  dynamic fkUserExpenseValidator;
  @HiveField(53)
  @JsonKey(name: "fk_user_holiday_validator")
  dynamic fkUserHolidayValidator;
  @HiveField(55)
  @JsonKey(name: "clicktodial_url")
  dynamic clicktodialUrl;
  @HiveField(57)
  @JsonKey(name: "clicktodial_login")
  dynamic clicktodialLogin;
  @HiveField(59)
  @JsonKey(name: "clicktodial_poste")
  dynamic clicktodialPoste;
  @HiveField(61)
  @JsonKey(name: "datelastlogin")
  int? datelastlogin;
  @HiveField(63)
  @JsonKey(name: "datepreviouslogin")
  int? datepreviouslogin;
  @HiveField(65)
  @JsonKey(name: "flagdelsessionsbefore")
  int? flagdelsessionsbefore;
  @HiveField(67)
  @JsonKey(name: "iplastlogin")
  String? iplastlogin;
  @HiveField(69)
  @JsonKey(name: "ippreviouslogin")
  String? ippreviouslogin;
  @HiveField(71)
  @JsonKey(name: "datestartvalidity")
  String? datestartvalidity;
  @HiveField(73)
  @JsonKey(name: "dateendvalidity")
  String? dateendvalidity;
  @HiveField(75)
  @JsonKey(name: "photo")
  dynamic photo;
  @HiveField(77)
  @JsonKey(name: "lang")
  dynamic lang;
  @HiveField(79)
  @JsonKey(name: "user_group_list")
  List<dynamic>? userGroupList;
  @HiveField(81)
  @JsonKey(name: "users")
  List<dynamic>? users;
  @HiveField(83)
  @JsonKey(name: "parentof")
  dynamic parentof;
  @HiveField(85)
  @JsonKey(name: "accountancy_code")
  String? accountancyCode;
  @HiveField(87)
  @JsonKey(name: "thm")
  dynamic thm;
  @HiveField(89)
  @JsonKey(name: "tjm")
  dynamic tjm;
  @HiveField(91)
  @JsonKey(name: "salary")
  dynamic salary;
  @HiveField(93)
  @JsonKey(name: "salaryextra")
  dynamic salaryextra;
  @HiveField(95)
  @JsonKey(name: "weeklyhours")
  dynamic weeklyhours;
  @HiveField(97)
  @JsonKey(name: "color")
  String? color;
  @HiveField(99)
  @JsonKey(name: "dateemployment")
  String? dateemployment;
  @HiveField(101)
  @JsonKey(name: "dateemploymentend")
  String? dateemploymentend;
  @HiveField(103)
  @JsonKey(name: "default_c_exp_tax_cat")
  dynamic defaultCExpTaxCat;
  @HiveField(105)
  @JsonKey(name: "ref_employee")
  String? refEmployee;
  @HiveField(107)
  @JsonKey(name: "national_registration_number")
  String? nationalRegistrationNumber;
  @HiveField(109)
  @JsonKey(name: "default_range")
  dynamic defaultRange;
  @HiveField(111)
  @JsonKey(name: "fk_warehouse")
  dynamic fkWarehouse;
  @HiveField(113)
  @JsonKey(name: "module")
  dynamic module;
  @HiveField(115)
  @JsonKey(name: "import_key")
  dynamic importKey;
  @HiveField(117)
  @JsonKey(name: "array_options")
  List<dynamic>? arrayOptions;
  @HiveField(119)
  @JsonKey(name: "array_languages")
  dynamic arrayLanguages;
  @HiveField(121)
  @JsonKey(name: "contacts_ids")
  dynamic contactsIds;
  @HiveField(123)
  @JsonKey(name: "linked_objects")
  dynamic linkedObjects;
  @HiveField(125)
  @JsonKey(name: "linkedObjectsIds")
  dynamic linkedObjectsIds;
  @HiveField(127)
  @JsonKey(name: "oldref")
  dynamic oldref;
  @HiveField(129)
  @JsonKey(name: "canvas")
  dynamic canvas;
  @HiveField(131)
  @JsonKey(name: "fk_project")
  dynamic fkProject;
  @HiveField(133)
  @JsonKey(name: "user")
  dynamic user;
  @HiveField(135)
  @JsonKey(name: "origin")
  dynamic origin;
  @HiveField(137)
  @JsonKey(name: "origin_id")
  dynamic originId;
  @HiveField(139)
  @JsonKey(name: "ref")
  String? ref;
  @HiveField(141)
  @JsonKey(name: "ref_ext")
  dynamic refExt;
  @HiveField(143)
  @JsonKey(name: "status")
  String? status;
  @HiveField(145)
  @JsonKey(name: "country_id")
  dynamic countryId;
  @HiveField(147)
  @JsonKey(name: "country_code")
  String? countryCode;
  @HiveField(149)
  @JsonKey(name: "state_id")
  String? stateId;
  @HiveField(151)
  @JsonKey(name: "region_id")
  dynamic regionId;
  @HiveField(153)
  @JsonKey(name: "barcode_type")
  dynamic barcodeType;
  @HiveField(155)
  @JsonKey(name: "barcode_type_coder")
  dynamic barcodeTypeCoder;
  @HiveField(157)
  @JsonKey(name: "mode_reglement_id")
  dynamic modeReglementId;
  @HiveField(159)
  @JsonKey(name: "cond_reglement_id")
  dynamic condReglementId;
  @HiveField(161)
  @JsonKey(name: "demand_reason_id")
  dynamic demandReasonId;
  @HiveField(163)
  @JsonKey(name: "transport_mode_id")
  dynamic transportModeId;
  @HiveField(165)
  @JsonKey(name: "shipping_method")
  dynamic shippingMethod;
  @HiveField(167)
  @JsonKey(name: "multicurrency_code")
  dynamic multicurrencyCode;
  @HiveField(169)
  @JsonKey(name: "multicurrency_tx")
  dynamic multicurrencyTx;
  @HiveField(171)
  @JsonKey(name: "last_main_doc")
  dynamic lastMainDoc;
  @HiveField(173)
  @JsonKey(name: "fk_bank")
  dynamic fkBank;
  @HiveField(175)
  @JsonKey(name: "fk_account")
  dynamic fkAccount;
  @HiveField(177)
  @JsonKey(name: "note_public")
  String? notePublic;
  @HiveField(179)
  @JsonKey(name: "note_private")
  String? notePrivate;
  @HiveField(181)
  @JsonKey(name: "name")
  dynamic name;
  @HiveField(183)
  @JsonKey(name: "lastname")
  String? lastname;
  @HiveField(185)
  @JsonKey(name: "firstname")
  String? firstname;
  @HiveField(187)
  @JsonKey(name: "civility_id")
  dynamic civilityId;
  @HiveField(189)
  @JsonKey(name: "date_creation")
  dynamic dateCreation;
  @HiveField(191)
  @JsonKey(name: "date_validation")
  dynamic dateValidation;
  @HiveField(193)
  @JsonKey(name: "date_modification")
  dynamic dateModification;
  @HiveField(195)
  @JsonKey(name: "date_update")
  dynamic dateUpdate;
  @HiveField(197)
  @JsonKey(name: "date_cloture")
  dynamic dateCloture;
  @HiveField(199)
  @JsonKey(name: "user_author")
  dynamic userAuthor;
  @HiveField(201)
  @JsonKey(name: "user_creation")
  dynamic userCreation;
  @HiveField(203)
  @JsonKey(name: "user_creation_id")
  dynamic userCreationId;
  @HiveField(205)
  @JsonKey(name: "user_valid")
  dynamic userValid;
  @HiveField(207)
  @JsonKey(name: "user_validation")
  dynamic userValidation;
  @HiveField(209)
  @JsonKey(name: "user_validation_id")
  dynamic userValidationId;
  @HiveField(211)
  @JsonKey(name: "user_closing_id")
  dynamic userClosingId;
  @HiveField(213)
  @JsonKey(name: "user_modification")
  dynamic userModification;
  @HiveField(215)
  @JsonKey(name: "user_modification_id")
  dynamic userModificationId;
  @HiveField(217)
  @JsonKey(name: "specimen")
  int? specimen;
  @HiveField(219)
  @JsonKey(name: "labelStatus")
  dynamic labelStatus;
  @HiveField(221)
  @JsonKey(name: "showphoto_on_popup")
  dynamic showphotoOnPopup;
  @HiveField(223)
  @JsonKey(name: "nb")
  List<dynamic>? nb;
  @HiveField(225)
  @JsonKey(name: "output")
  dynamic output;
  @HiveField(227)
  @JsonKey(name: "extraparams")
  List<dynamic>? extraparams;
  @HiveField(229)
  @JsonKey(name: "address")
  String? address;
  @HiveField(231)
  @JsonKey(name: "zip")
  String? zip;
  @HiveField(233)
  @JsonKey(name: "town")
  String? town;

  UserModel({
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
    this.userGroupList,
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

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
