import 'package:objectbox/objectbox.dart';

//final invoices = parseInvoicesFromJson(jsonResponse);

@Entity()
class InvoiceEntity {
  @Id(assignable: true)
  int id = 0;
  @Index(type: IndexType.value)
  @Unique(onConflict: ConflictStrategy.replace)
  String documentId;
  String ref;
  String status;
  String paye;
  String type;
  String totalHt;
  String totalTtc;
  String socid;
  int date;
  int dateLimReglement;
  int dateModification;
  String? condReglementCode;
  String? modeReglementCode;
  int totalpaid;
  String sumcreditnote;
  String remaintopay;
  String? refCustomer;
  String? fkFactureSource;
  String name;

  @Backlink('invoice')
  final lines = ToMany<InvoiceLineEntity>();

  InvoiceEntity({
    this.documentId = '',
    this.ref = '',
    this.status = '',
    this.paye = '',
    this.type = '',
    this.totalHt = '0',
    this.totalTtc = '0',
    this.socid = '',
    this.date = 0,
    this.dateLimReglement = 0,
    this.dateModification = 0,
    this.condReglementCode = '',
    this.modeReglementCode = '',
    this.totalpaid = 0,
    this.sumcreditnote = '0',
    this.remaintopay = '0',
    this.refCustomer,
    this.fkFactureSource,
    this.name = '',
  });
}

@Entity()
class InvoiceLineEntity {
  @Id()
  int id = 0;
  String? lineId;
  String? description;
  String? productLabel;
  String? qty;
  String? subprice;
  String? totalHt;
  String? totalTtc;
  String? paHt;
  String? fkFacture;
  String? fkProductType;
  String? fkProduct;
  String? productType;
  String? desc;
  final invoice = ToOne<InvoiceEntity>();
  InvoiceLineEntity(
      {this.lineId,
      this.description,
      this.productLabel,
      this.qty,
      this.subprice,
      this.totalHt,
      this.totalTtc,
      this.paHt,
      this.fkFacture,
      this.fkProductType,
      this.fkProduct,
      this.productType,
      this.desc});
}

List<InvoiceEntity> parseInvoiceListFromJson(List<dynamic> jsonList) {
  return jsonList.map((invoiceJson) {
    final invoice = InvoiceEntity(
      documentId: invoiceJson['id'],
      ref: invoiceJson['ref'],
      status: invoiceJson['status'],
      paye: invoiceJson['paye'],
      type: invoiceJson['type'],
      totalHt: invoiceJson['total_ht'],
      totalTtc: invoiceJson['total_ttc'],
      socid: invoiceJson['socid'],
      date: invoiceJson['date'],
      dateLimReglement: invoiceJson['date_lim_reglement'],
      dateModification: invoiceJson['date_modification'],
      condReglementCode: invoiceJson['cond_reglement_code'] ?? '',
      modeReglementCode: invoiceJson['mode_reglement_code'] ?? '',
      totalpaid: invoiceJson['totalpaid'],
      sumcreditnote: invoiceJson['sumcreditnote'] ?? '0',
      remaintopay: invoiceJson['remaintopay'],
      name: invoiceJson['name'] ?? '',
      refCustomer: invoiceJson['ref_customer'] ?? '',
      fkFactureSource: invoiceJson['fk_facture_source'] ?? '',
    );

    if (invoiceJson['lines'] is List) {
      invoice.lines.addAll(
        (invoiceJson['lines'] as List).map((lineJson) {
          return InvoiceLineEntity(
            lineId: lineJson['id'],
            description: lineJson['description'],
            productLabel: lineJson['product_label'],
            qty: lineJson['qty'],
            subprice: lineJson['subprice'],
            totalHt: lineJson['total_ht'],
            totalTtc: lineJson['total_ttc'],
            paHt: lineJson['pa_ht'],
            fkFacture: lineJson['fk_facture'],
            fkProductType: lineJson['fk_product_type'],
            fkProduct: lineJson['fk_product'],
            productType: lineJson['product_type'],
          );
        }),
      );
    }

    return invoice;
  }).toList();
}

InvoiceEntity parseInvoiceFromJson(Map<String, dynamic> invoiceJson) {
  final invoice = InvoiceEntity(
    documentId: invoiceJson['id'],
    ref: invoiceJson['ref'],
    status: invoiceJson['status'],
    paye: invoiceJson['paye'],
    type: invoiceJson['type'],
    totalHt: invoiceJson['total_ht'],
    totalTtc: invoiceJson['total_ttc'],
    socid: invoiceJson['socid'],
    date: invoiceJson['date'],
    dateLimReglement: invoiceJson['date_lim_reglement'],
    dateModification: invoiceJson['date_modification'],
    condReglementCode: invoiceJson['cond_reglement_code'] ?? '',
    modeReglementCode: invoiceJson['mode_reglement_code'] ?? '',
    totalpaid: invoiceJson['totalpaid'],
    sumcreditnote: invoiceJson['sumcreditnote'] ?? '0',
    remaintopay: invoiceJson['remaintopay'],
    name: invoiceJson['name'] ?? '',
    refCustomer: invoiceJson['ref_customer'] ?? '',
    fkFactureSource: invoiceJson['fk_facture_source'] ?? '',
  );

  if (invoiceJson['lines'] is List) {
    invoice.lines.addAll(
      (invoiceJson['lines'] as List).map((lineJson) {
        return InvoiceLineEntity(
          lineId: lineJson['id'],
          description: lineJson['description'],
          productLabel: lineJson['product_label'],
          qty: lineJson['qty'],
          subprice: lineJson['subprice'],
          totalHt: lineJson['total_ht'],
          totalTtc: lineJson['total_ttc'],
          paHt: lineJson['pa_ht'],
          fkFacture: lineJson['fk_facture'],
          fkProductType: lineJson['fk_product_type'],
          fkProduct: lineJson['fk_product'],
          productType: lineJson['product_type'],
        );
      }),
    );
  }

  return invoice;
}
