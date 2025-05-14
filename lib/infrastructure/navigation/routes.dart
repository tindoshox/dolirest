// ignore_for_file: constant_identifier_names

class Routes {
  static Future<String> get initialRoute async {
    return HOME;
  }

  static const ADDPAYMENT = '/addpayment';
  static const CASHFLOW = '/cashflow';
  static const CREATEINVOICE = '/createinvoice';
  static const CUSTOMERDETAIL = '/customerdetail';
  static const CUSTOMERLIST = '/customerlist';
  static const DUETODAY = '/duetoday';
  static const EDITCUSTOMER = '/editcustomer';
  static const HOME = '/home';
  static const INVOICEDETAIL = '/invoicedetail';
  static const INVOICELIST = '/invoicelist';
  static const LOGIN = '/login';
  static const PAYMENT = '/payment';
  static const REPORTS = '/reports';
  static const SETTINGS = '/settings';
  static const DRAFTS = '/drafts';
}
