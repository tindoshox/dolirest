class DocumentType {
  static const String invoice = "0";
  static const String typeCreditNote = "2";
}

class ValidationStatus {
  //Invoice Status
  static const String draft = "0"; ////"statut": "0"
  static const String validated = "1"; //"statut": "1"
  static const String creditAvalable = "2"; //"statut": "2"
}

class PaidStatus {
//Payment state
  static const String unpaid = "0"; //"paye": "0"
  static const String paid = "1"; //"paye": "1"
}

class SettingId {
  static final themeModeId = 1;
  static final userSettingId = 2;
  static final moduleSettingId = 3;
  static final urlSettingId = 4;
  static final tokenSettingId = 5;
}
