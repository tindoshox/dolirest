// import 'package:dolirest/infrastructure/dal/models/address_model.dart';
// import 'package:dolirest/infrastructure/dal/models/company_model.dart';
// import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
// import 'package:dolirest/infrastructure/dal/models/group_model.dart';
// import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
// import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
// import 'package:dolirest/infrastructure/dal/models/product_model.dart';
// import 'package:dolirest/infrastructure/dal/models/settings_model.dart';
// import 'package:dolirest/infrastructure/dal/models/user_model.dart';
// import 'package:dolirest/objectbox.g.dart';
// import 'package:get/get.dart';

// // generated file

// class ObjectBoxService extends GetxController {
//   late final Store store;

//   late final Box<CustomerModel> customerBox;
//   late final Box<InvoiceModel> invoiceBox;
//   late final Box<Line> lineBox;
//   late final Box<PaymentModel> paymentBox;
//   late final Box<ProductModel> productBox;
//   late final Box<GroupModel> groupBox;
//   late final Box<CompanyModel> companyBox;
//   late final Box<UserModel> userBox;
//   late final Box<AddressModel> addressBox;
//   late final Box<SettingsModel> settingsBox;
//   // Add more boxes as needed

//   ObjectBoxService._create(this.store) {
//     customerBox = Box<CustomerModel>(store);
//     invoiceBox = Box<InvoiceModel>(store);
//     lineBox = Box<Line>(store);
//     paymentBox = Box<PaymentModel>(store);
//     productBox = Box<ProductModel>(store);
//     groupBox = Box<GroupModel>(store);
//     companyBox = Box<CompanyModel>(store);
//     userBox = Box<UserModel>(store);
//     addressBox = Box<AddressModel>(store);
//     settingsBox = Box<SettingsModel>(store);
//   }

//   static Future<ObjectBoxService> create() async {
//     final store = await openStore(); // generated method
//     return ObjectBoxService._create(store);
//   }

//   void close() {
//     store.close();
//   }
// }
