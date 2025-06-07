// To parse this JSON data, do
//
//     final invoiceModel = invoiceModelFromJson(jsonString);

import 'dart:convert';

List<InvoiceModel> listInvoiceFromJson(String str) => List<InvoiceModel>.from(
    json.decode(str).map((x) => InvoiceModel.fromJson(x)));

String listInvoiceToJson(List<InvoiceModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

InvoiceModel invoiceFromJson(String str) =>
    InvoiceModel.fromJson(json.decode(str));

String invoiceToJson(InvoiceModel data) => json.encode(data.toJson());

class InvoiceModel {
  String? id;
  String? ref;
  String? status;
  String? totalHt;
  String? totalTva;
  String? totalTtc;
  List<Line>? lines;
  String? name;
  int? dateModification;
  int? totalpaid;
  String? type;
  String? socid;
  String? paye;
  int? date;
  int? dateLimReglement;
  String? totaldeposits;
  String? totalcreditnotes;
  String? sumpayed;
  String? sumdeposit;
  String? sumcreditnote;
  String? remaintopay;
  int? datem;
  String? refCustomer;
  String? fkFactureSource;
  String? modeReglementCode;
  String? condReglementCode;

  InvoiceModel({
    this.id,
    this.ref,
    this.status,
    this.totalHt,
    this.totalTva,
    this.totalTtc,
    this.lines,
    this.name,
    this.dateModification,
    this.totalpaid,
    this.type,
    this.socid,
    this.paye,
    this.date,
    this.dateLimReglement,
    this.totaldeposits,
    this.totalcreditnotes,
    this.sumpayed,
    this.sumdeposit,
    this.sumcreditnote,
    this.remaintopay,
    this.datem,
    this.refCustomer,
    this.fkFactureSource,
    this.modeReglementCode,
    this.condReglementCode,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
        id: json["id"],
        ref: json["ref"],
        status: json["status"],
        totalHt: json["total_ht"],
        totalTva: json["total_tva"],
        totalTtc: json["total_ttc"],
        lines: json["lines"] == null
            ? []
            : List<Line>.from(json["lines"].map((x) => Line.fromJson(x))),
        name: json["name"],
        dateModification: json["date_modification"],
        totalpaid: json["totalpaid"],
        type: json["type"],
        socid: json["socid"] =
            json["socid"] is int ? json["socid"] : int.parse(json["socid"]),
        paye: json["paye"],
        date: json["date"] = json["date"],
        dateLimReglement: json["date_lim_reglement"],
        totaldeposits: json["totaldeposits"],
        totalcreditnotes: json["totalcreditnotes"],
        sumpayed: json["sumpayed"],
        sumdeposit: json["sumdeposit"],
        sumcreditnote: json["sumcreditnote"],
        remaintopay: json["remaintopay"],
        datem: json["datem"] = int.parse(json["datem"]),
        refCustomer: json["ref_customer"],
        fkFactureSource: json["fk_facture_source"],
        modeReglementCode: json["mode_reglement_code"],
        condReglementCode: json["cond_reglement_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ref": ref,
        "status": status,
        "total_ht": totalHt,
        "total_tva": totalTva,
        "total_ttc": totalTtc,
        "lines":
            lines == null ? [] : List<Line>.from(lines!.map((x) => x.toJson())),
        "name": name,
        "date_modification": dateModification,
        "totalpaid": totalpaid,
        "type": type,
        "socid": socid,
        "paye": paye,
        "date": date,
        "date_lim_reglement": dateLimReglement,
        "totaldeposits": totaldeposits,
        "totalcreditnotes": totalcreditnotes,
        "sumpayed": sumpayed,
        "sumdeposit": sumdeposit,
        "sumcreditnote": sumcreditnote,
        "remaintopay": remaintopay,
        "datem": datem,
        "ref_customer": refCustomer,
        "fk_facture_source": fkFactureSource,
        "mode_reglement_code": modeReglementCode,
        "cond_reglement_code": condReglementCode,
      };
}

class Line {
  int? id;
  String? ref;
  String? totalHt;
  String? totalTva;
  String? totalLocaltax1;
  String? totalLocaltax2;
  String? totalTtc;
  String? productType;
  String? fkProduct;
  String? desc;
  String? description;
  String? productRef;
  String? productLabel;
  String? productDesc;
  String? fkProductType;
  String? qty;
  String? subprice;
  String? tvaTx;
  String? label;
  String? libelle;
  String? fkAccountingAccount;
  int? fkFacture;
  String? fkWarehouse;

  Line({
    this.id,
    this.ref,
    this.totalHt,
    this.totalTva,
    this.totalLocaltax1,
    this.totalLocaltax2,
    this.totalTtc,
    this.productType,
    this.fkProduct,
    this.desc,
    this.description,
    this.productRef,
    this.productLabel,
    this.productDesc,
    this.fkProductType,
    this.qty,
    this.subprice,
    this.tvaTx,
    this.label,
    this.libelle,
    this.fkAccountingAccount,
    this.fkFacture,
    this.fkWarehouse,
  });

  factory Line.fromJson(Map<String, dynamic> json) => Line(
        id: json["id"] = json["id"] is int ? json["id"] : int.parse(json["id"]),
        ref: json["ref"],
        totalHt: json["total_ht"],
        totalTva: json["total_tva"],
        totalLocaltax1: json["total_localtax1"],
        totalLocaltax2: json["total_localtax2"],
        totalTtc: json["total_ttc"],
        productType: json["product_type"],
        fkProduct: json["fk_product"],
        desc: json["desc"],
        description: json["description"],
        productRef: json["product_ref"],
        productLabel: json["product_label"],
        productDesc: json["product_desc"],
        fkProductType: json["fk_product_type"],
        qty: json["qty"],
        subprice: json["subprice"],
        tvaTx: json["tva_tx"],
        label: json["label"],
        libelle: json["libelle"],
        fkAccountingAccount: json["fk_accounting_account"],
        fkFacture: json["fk_facture"] is int
            ? json["fk_facture"]
            : int.parse(json["fk_facture"]),
        fkWarehouse: json["fk_warehouse"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ref": ref,
        "total_ht": totalHt,
        "total_tva": totalTva,
        "total_localtax1": totalLocaltax1,
        "total_localtax2": totalLocaltax2,
        "total_ttc": totalTtc,
        "product_type": productType,
        "fk_product": fkProduct,
        "desc": desc,
        "description": description,
        "product_ref": productRef,
        "product_label": productLabel,
        "product_desc": productDesc,
        "fk_product_type": fkProductType,
        "qty": qty,
        "subprice": subprice,
        "tva_tx": tvaTx,
        "label": label,
        "libelle": libelle,
        "fk_accounting_account": fkAccountingAccount,
        "fk_facture": fkFacture,
        "fk_warehouse": fkWarehouse,
      };
}
