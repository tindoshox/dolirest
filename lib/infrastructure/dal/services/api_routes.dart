class ApiRoutes {
  static const apiStub = "/api/index.php/";
  static const login = "${apiStub}login";
  static const customers = "${apiStub}thirdparties"; //List of customer
  static const invoices = "${apiStub}invoices"; //List of invoices
  static const groups = "${apiStub}setup/dictionary/states";
  static const users = "${apiStub}users/info";
  static const banks = "${apiStub}bankaccounts";
  static const paymentTypes = "${apiStub}setup/dictionary/payment_types";
  static const products = "${apiStub}products";
  static const suppliersInvoices = "${apiStub}supplierinvoices";
  static const buildDocument = "${apiStub}documents/builddoc";
  static const buildReport = "${apiStub}reports/builddoc";
}
