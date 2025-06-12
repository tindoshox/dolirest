import 'package:dolirest/utils/utils.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class PaymentEntity {
  int id = 0;
  String amount;
  String type;
  DateTime date;
  String? num;
  @Unique(onConflict: ConflictStrategy.replace)
  String ref;
  String? refExt;
  String? fkBankLine;
  String invoiceId;

  PaymentEntity({
    required this.amount,
    required this.type,
    required this.date,
    this.num,
    @Unique(onConflict: ConflictStrategy.replace) required this.ref,
    this.refExt,
    this.fkBankLine,
    @Index(type: IndexType.value) required this.invoiceId,
  });
}

List<PaymentEntity> parsePaymentsFromJson(
    List<dynamic> jsonList, String invoiceId) {
  return jsonList.map((paymentJson) {
    final PaymentEntity payment = PaymentEntity(
      amount: paymentJson["amount"],
      type: paymentJson["type"],
      date: Utils.dateOnly(DateTime.parse(paymentJson["date"])),
      num: paymentJson["num"],
      ref: paymentJson["ref"],
      refExt: paymentJson["ref_ext"],
      fkBankLine: paymentJson["fk_bank_line"],
      invoiceId: invoiceId,
    );
    return payment;
  }).toList();
}
